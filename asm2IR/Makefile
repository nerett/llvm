LLVMFLAGS = $(shell llvm-config --cppflags --ldflags --libs)

all: clean
	clang++-18 -o asm2ir gen_ir.cpp ../gui_app/sim.c $(LLVMFLAGS) -lSDL2

run:
	./asm2ir ../gui_app/app.s

clean:
	rm -f debug.ll
