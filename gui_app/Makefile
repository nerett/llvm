all:
	clang-18 app.c main.c sim.c -lSDL2
#   clang-18 app.c main.c sim.c `sdl2-config --cflags --libs`

dump-ir:
	clang-18 app.c main.c sim.c -emit-llvm -S -O2

run:
	./a.out
