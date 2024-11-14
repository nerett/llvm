#include "llvm/ExecutionEngine/ExecutionEngine.h"
#include "llvm/ExecutionEngine/GenericValue.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Support/raw_ostream.h"

#include <stdio.h>

#include <fstream>
#include <iostream>
#include <unordered_map>

#include "../gui_app/sim.h"

using namespace llvm;

#define MDIM 512
#define MSIZE 262144

const int REG_FILE_SIZE = 32;
uint64_t REG_FILE[REG_FILE_SIZE];

void do_PUT_PIXEL(uint64_t r1, uint64_t r2, uint64_t imm) {
    sim_put_pixel(r1, r2, imm);
}

void do_FLUSH() {
    sim_flush();
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        outs() << "[ERROR] Need 1 argument: file with assembler code\n";
        return 1;
    }
    std::ifstream input;
    input.open(argv[1]);
    if (!input.is_open()) {
        outs() << "[ERROR] Can't open " << argv[1] << "\n";
        return 1;
    }

    LLVMContext context;
    Module *module = new Module("top", context);
    IRBuilder<> builder(context);

    ArrayType *regFileType = ArrayType::get(builder.getInt64Ty(), REG_FILE_SIZE);
    module->getOrInsertGlobal("regFile", regFileType);
    GlobalVariable *regFile = module->getNamedGlobal("regFile");

    // declare void @main()
    FunctionType *funcType = FunctionType::get(builder.getVoidTy(), false);
    Function *mainFunc = Function::Create(funcType, Function::ExternalLinkage, "main", module);

    std::string name;
    std::string arg;
    std::unordered_map<std::string, BasicBlock *> BBMap;

    outs() << "\n#[FILE]:\nBBs:";

    while (input >> name) {
        if (!name.compare("STR") || !name.compare("LDA") ||
            !name.compare("BLE") || !name.compare("BEQ")) {
            input >> arg >> arg >> arg >> arg;
            continue;
        } else if (!name.compare("ADD") || !name.compare("SUB") ||
                   !name.compare("PUT_PIXEL")) {
            input >> arg >> arg >> arg;
            continue;
        } else if (!name.compare("CPYM") || !name.compare("MOV")) {
            input >> arg >> arg;
            continue;
        } else if (!name.compare("ALLOCM") || !name.compare("LIFETIME_START") ||
                   !name.compare("FREEM") || !name.compare("INM") ||
                   !name.compare("BR")) {
            input >> arg;
            continue;
        } else if (!name.compare("FLUSH") || !name.compare("HLT")) {
            continue;
        }

        outs() << name << " ";
        BBMap[name] = BasicBlock::Create(context, name, mainFunc);
    }
    outs() << "\n";
    input.close();
    input.open(argv[1]);

    // Funcions types
    Type *voidType = Type::getVoidTy(context);
    FunctionType *voidFuncType = FunctionType::get(voidType, false);

    ArrayRef<Type *> doPutPixelArgTypes = {Type::getInt64Ty(context), Type::getInt64Ty(context), Type::getInt64Ty(context)};
    FunctionType *doPutPixelFuncType = FunctionType::get(voidType, doPutPixelArgTypes, false);

    FunctionCallee doPutPixelFunc = module->getOrInsertFunction("do_PUT_PIXEL", doPutPixelFuncType);
    FunctionCallee doFlushFunc = module->getOrInsertFunction("do_FLUSH", voidFuncType);

    ArrayType *arrayTy = ArrayType::get(IntegerType::get(context, 8), MSIZE);
    PointerType *arrayTyPtr = PointerType::get(arrayTy, 0);

    ArrayRef<Type *> llvmLifetimeStartArgTypes = {Type::getInt64Ty(context), builder.getPtrTy()};
    FunctionType *llvmLifetimeStartFuncType = FunctionType::get(voidType, llvmLifetimeStartArgTypes, false);
    Function *llvmLifetimeStartFunc = Function::Create(
        llvmLifetimeStartFuncType, Function::ExternalLinkage, "llvm.lifetime.start.p0", module);

    ArrayRef<Type *> llvmLifetimeEndArgTypes = {Type::getInt64Ty(context), builder.getPtrTy()};
    FunctionType *llvmLifetimeEndFuncType =
        FunctionType::get(voidType, llvmLifetimeEndArgTypes, false);
    Function *llvmLifetimeEndFunc = Function::Create(
        llvmLifetimeEndFuncType, Function::ExternalLinkage, "llvm.lifetime.end.p0", module);

    ArrayRef<Type *> llvmMemsetArgTypes = {builder.getPtrTy(), Type::getInt8Ty(context),
                                           Type::getInt64Ty(context), Type::getInt1Ty(context)};
    FunctionType *llvmMemsetFuncType = FunctionType::get(voidType, llvmMemsetArgTypes, false);
    Function *llvmMemsetFunc = Function::Create(
        llvmMemsetFuncType, Function::ExternalLinkage, "llvm.memset.p0.i64", module);

    ArrayRef<Type *> llvmMemcpyArgTypes = {builder.getPtrTy(), builder.getPtrTy(),
                                           Type::getInt64Ty(context), Type::getInt1Ty(context)};
    FunctionType *llvmMemcpyFuncType = FunctionType::get(voidType, llvmMemcpyArgTypes, false);
    Function *llvmMemcpyFunc = Function::Create(
        llvmMemcpyFuncType, Function::ExternalLinkage, "llvm.memcpy.p0.p0.i64", module);

    while (input >> name) {
        if (!name.compare("ALLOCM")) {
            input >> arg;
            outs() << "\tALLOCATE: " << arg << "\n";

            Value *arg1 = builder.CreateConstGEP2_64(regFileType, regFile, 0, std::stoll(arg.substr(1)));
            llvm::AllocaInst *alloca = builder.CreateAlloca(ArrayType::get(builder.getInt8Ty(), MSIZE), nullptr);
            alloca->setAlignment(llvm::Align(1));
            builder.CreateStore(alloca, arg1);

            continue;
        } else if (!name.compare("LIFETIME_START")) {
            input >> arg;
            Value *arg1 =
                builder.CreateConstGEP2_64(regFileType, regFile, 0, std::stoll(arg.substr(1)));

            builder.CreateCall(llvmLifetimeStartFunc,
                               {builder.getInt64(MSIZE), builder.CreateLoad(arrayTyPtr, arg1)});
            builder.CreateCall(llvmMemsetFunc,
                               {builder.CreateLoad(arrayTyPtr, arg1), builder.getInt8(0),
                                builder.getInt64(MSIZE), builder.getInt1(0)});

            continue;
        } else if (!name.compare("FREEM")) {
            input >> arg;
            Value *arg1 = builder.CreateConstGEP2_64(regFileType, regFile, 0, std::stoll(arg.substr(1)));
            builder.CreateCall(llvmLifetimeEndFunc, {builder.getInt64(1250), arg1});

            continue;
        } else if (!name.compare("CPYM")) {
            input >> arg;
            Value *arg1 = builder.CreateConstGEP2_64(regFileType, regFile, 0, std::stoll(arg.substr(1)));

            input >> arg;
            Value *arg2 = builder.CreateConstGEP2_64(regFileType, regFile, 0, std::stoll(arg.substr(1)));

            builder.CreateCall(llvmMemcpyFunc,
                               {builder.CreateLoad(arrayTyPtr, arg1), builder.CreateLoad(arrayTyPtr, arg2),
                                builder.getInt64(MSIZE), builder.getInt1(0)});

            continue;
        } else if (!name.compare("INM")) {
            input >> arg;
            Value *arg1 = builder.CreateConstGEP2_64(regFileType, regFile, 0, std::stoll(arg.substr(1)));

            builder.CreateCall(llvmMemsetFunc,
                               {builder.CreateLoad(arrayTyPtr, arg1), builder.getInt8(0),
                                builder.getInt64(MSIZE), builder.getInt1(0)});

            continue;
        } else if (!name.compare("STR")) {
            input >> arg;
            outs() << "\tSTR " << arg;

            Value *arg1 = builder.CreateConstGEP2_64(regFileType, regFile, 0, std::stoll(arg.substr(1)));

            input >> arg;
            outs() << " " << arg;
            Value *arg2 = builder.CreateConstGEP2_64(regFileType, regFile, 0, std::stoll(arg.substr(1)));

            input >> arg;
            outs() << " " << arg;
            Value *arg3 = builder.CreateConstGEP2_64(regFileType, regFile, 0, std::stoll(arg.substr(1)));

            input >> arg;
            outs() << " " << arg << "\n";
            Value *arg4 = builder.getInt64(std::stoll(arg));

            Value* x = builder.CreateURem(arg2, builder.getInt64(MDIM));
            Value* y = builder.CreateURem(arg3, builder.getInt64(MDIM));
            Value* offset = builder.CreateAdd(x, builder.CreateMul(y, builder.getInt64(MDIM)));

            Value *gep_val = builder.CreateInBoundsGEP(builder.getInt8Ty(),
                                                       builder.CreateLoad(arrayTyPtr, arg1), offset);
            builder.CreateStore(arg4, gep_val);

            continue;
        } else if (!name.compare("LDA")) {
            input >> arg;
            Value *arg1 = builder.CreateConstGEP2_64(regFileType, regFile, 0, std::stoll(arg.substr(1)));

            input >> arg;
            Value *arg2 = builder.CreateConstGEP2_64(regFileType, regFile, 0, std::stoll(arg.substr(1)));

            input >> arg;
            Value *arg3 = builder.CreateConstGEP2_64(regFileType, regFile, 0, std::stoll(arg.substr(1)));

            input >> arg;
            Value *arg4 = builder.CreateConstGEP2_64(regFileType, regFile, 0, std::stoll(arg.substr(1)));

            Value* x = builder.CreateURem(arg3, builder.getInt64(MDIM));
            Value* y = builder.CreateURem(arg4, builder.getInt64(MDIM));
            Value* offset = builder.CreateAdd(x, builder.CreateMul(y, builder.getInt64(MDIM)));

            Value *gep_val = builder.CreateInBoundsGEP(builder.getInt8Ty(),
                                                       builder.CreateLoad(arrayTyPtr, arg2), offset);

            Value* curr = builder.CreateLoad(builder.getInt64Ty(), arg4);
            Value* loaded = builder.CreateLoad(arrayTyPtr, gep_val);
            builder.CreateStore(builder.CreateAdd(curr, loaded), gep_val);

            continue;
        } else if (!name.compare("MOV")) {
            input >> arg;
            Value *arg1 = builder.CreateConstGEP2_64(regFileType, regFile, 0, std::stoll(arg.substr(1)));

            input >> arg;
            Value *arg2 = builder.getInt64(std::stoll(arg));

            builder.CreateStore(arg2, arg1);

            continue;
        } else if (!name.compare("ADD")) {
            input >> arg;
            outs() << "\t" << arg << " = ";
            Value *res = builder.CreateConstGEP2_64(regFileType, regFile, 0, std::stoll(arg.substr(1)));

            input >> arg;
            outs() << arg << " + (";
            Value *arg1 = builder.CreateConstGEP2_64(regFileType, regFile, 0, std::stoll(arg.substr(1)));

            input >> arg;
            outs() << arg << ")\n";
            Value *arg2 = builder.getInt64(std::stoll(arg));

            Value *add_res = builder.CreateAdd(builder.CreateLoad(builder.getInt64Ty(), arg1), arg2);
            builder.CreateStore(add_res, res);

            continue;
        } else if (!name.compare("SUB")) {
            input >> arg;
            outs() << "\t" << arg << " = ";
            Value *res = builder.CreateConstGEP2_64(regFileType, regFile, 0, std::stoll(arg.substr(1)));

            input >> arg;
            outs() << arg << " - (";
            Value *arg1 = builder.CreateConstGEP2_64(regFileType, regFile, 0, std::stoll(arg.substr(1)));

            input >> arg;
            outs() << arg << ")\n";
            Value *arg2 = builder.getInt64(std::stoll(arg));

            Value *add_res = builder.CreateSub(builder.CreateLoad(builder.getInt64Ty(), arg1), arg2);
            builder.CreateStore(add_res, res);

            continue;
        } else if (!name.compare("BR")) {
            input >> name;
            outs() << "\tBRANCH -> " << name << "\n";
            builder.CreateBr(BBMap[name]);

            continue;
        } else if (!name.compare("BLE")) {
            input >> arg;
            outs() << "\tif (" << arg;
            Value *arg1_ptr =
                builder.CreateConstGEP2_64(regFileType, regFile, 0, std::stoll(arg.substr(1)));

            input >> arg;
            outs() << " == " << arg << ") {\n";
            Value *imm = builder.getInt64(std::stoll(arg));

            input >> arg;
            outs() << "\t\tbranch to " << arg << "\n";
            outs() << "\t} else {\n";

            input >> name;
            outs() << "\t\tbranch to " << name << "\n";
            outs() << "\t}\n";

            Value *icmp_eq_res =
                builder.CreateICmpULT(builder.CreateLoad(builder.getInt64Ty(), arg1_ptr), imm);
            builder.CreateCondBr(icmp_eq_res, BBMap[arg], BBMap[name]);
            builder.SetInsertPoint(BBMap[arg]);

            continue;
        } else if (!name.compare("BEQ")) {
            input >> arg;
            outs() << "\tif (" << arg;
            Value *arg1_ptr =
                builder.CreateConstGEP2_64(regFileType, regFile, 0, std::stoll(arg.substr(1)));

            input >> arg;
            outs() << " == " << arg << ") {\n";
            Value *imm = builder.getInt64(std::stoll(arg));

            input >> arg;
            outs() << "\t\tBRANCH -> " << arg << "\n";
            outs() << "\t} else {\n";

            input >> name;
            outs() << "\t\tBRANCH -> " << name << "\n";
            outs() << "\t}\n";

            Value *icmp_eq_res =
                builder.CreateICmpEQ(builder.CreateLoad(builder.getInt64Ty(), arg1_ptr), imm);
            builder.CreateCondBr(icmp_eq_res, BBMap[arg], BBMap[name]);
            builder.SetInsertPoint(BBMap[arg]);

            continue;
        } else if (!name.compare("HLT")) {
            outs() << "\tHLT\n";
            builder.CreateRetVoid();
            if (input >> name) {
                outs() << "BB " << name << "\n";
                builder.SetInsertPoint(BBMap[name]);
            }

            continue;
        } else if (!name.compare("PUT_PIXEL")) {
            input >> arg;
            outs() << "\tPUT_PIXEL " << arg;
            Value *arg1 = builder.getInt64(std::stoll(arg.substr(1)));
            input >> arg;
            outs() << " " << arg;
            Value *arg2 = builder.getInt64(std::stoll(arg.substr(1)));
            input >> arg;
            outs() << " " << arg << "\n";
            Value *arg3 = builder.getInt64(std::stoll(arg.substr(1)));
            input >> arg;
            outs() << " " << arg << "\n";
            Value *args[] = {arg1, arg2, arg3};
            builder.CreateCall(doPutPixelFunc, args);

            continue;
        } else if (!name.compare("FLUSH")) {
            outs() << "\tSIM_FLUSH\n";
            builder.CreateCall(doFlushFunc);

            continue;
        }

        outs() << "BB " << name << "\n";
        builder.SetInsertPoint(BBMap[name]);
    }

    bool verif = verifyFunction(*mainFunc, &outs());
    outs() << "[VERIFICATION] " << (!verif ? "OK\n\n" : "FAIL\n\n");

    outs() << "\n#[LLVM IR]:\n";
    module->print(outs(), nullptr);
    outs() << "\n";

    outs() << "\n#[Running code]\n";
    InitializeNativeTarget();
    InitializeNativeTargetAsmPrinter();

    ExecutionEngine *ee = EngineBuilder(std::unique_ptr<Module>(module)).create();
    ee->InstallLazyFunctionCreator([=](const std::string &fnName) -> void * {
        std::cout << "ERROR: unknown function: " << fnName << '\n';
        return nullptr;
    });

    ee->addGlobalMapping(regFile, (void *)REG_FILE);
    ee->finalizeObject();

    sim_init();

    ArrayRef<GenericValue> noargs;
    ee->runFunction(mainFunc, noargs);
    outs() << "#[Code was run]\n";

    sim_destroy();
    return 0;
}
