#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"

using namespace llvm;

struct MyModPass : public PassInfoMixin<MyModPass> {
    PreservedAnalyses run(Module &M, ModuleAnalysisManager &AM) {
        for (auto &F : M) {
            if (F.getName() == "log_instruction") {
                continue;
            }

            LLVMContext &Ctx = F.getContext();
            IRBuilder<> builder(Ctx);
            Type *retType = Type::getVoidTy(Ctx);

            ArrayRef<Type *> instructionParamTypes = {builder.getInt8Ty()->getPointerTo(),
                                                    builder.getInt8Ty()->getPointerTo()};
            FunctionType* instructionLoggerFuncType = FunctionType::get(retType, instructionParamTypes, false);
            FunctionCallee instructionLogFunc = M.getOrInsertFunction("log_instruction", instructionLoggerFuncType);

            for (auto &B : F) {
                for (auto &I : B) {
                    if (auto* inst = dyn_cast<Instruction>(&I)) {
                        if (auto* phi = dyn_cast<PHINode>(&I)) {
                            continue;
                        }

                        builder.SetInsertPoint(&I);
                        for(auto &U : I.uses()) {
                            if (auto useInst = dyn_cast<Instruction>(U.getUser())) {
                                Value* useName = builder.CreateGlobalStringPtr(useInst->getOpcodeName());
                                Value* instName = builder.CreateGlobalStringPtr(inst->getOpcodeName());

                                Value* args[] = {useName, instName};
                                builder.CreateCall(instructionLogFunc, args);
                            }
                        }
                    }
                }
            }
        }
        return PreservedAnalyses::none();
    };
};

PassPluginLibraryInfo getPassPluginInfo() {
    const auto callback = [](PassBuilder &PB) {
    PB.registerOptimizerLastEPCallback([&](ModulePassManager &MPM, auto) {
        MPM.addPass(MyModPass{});
        return true;
    });
    };

    return {LLVM_PLUGIN_API_VERSION, "MyPlugin", "0.0.1", callback};
};

/* When a plugin is loaded by the driver, it will call this entry point to
obtain information about this plugin and about how to register its passes.
*/
extern "C" LLVM_ATTRIBUTE_WEAK PassPluginLibraryInfo llvmGetPassPluginInfo() {
    return getPassPluginInfo();
}
