all:
	clang-18 app.c main.c sim.c -O2 -lSDL2
#   clang-18 app.c main.c sim.c `sdl2-config --cflags --libs`

dump-ir:
	clang-18 app.c -emit-llvm -S -O1

mod-pass:
	clang-18 -fpass-plugin=../modifying_pass/libPass.o app.c -c -O2
	clang-18 app.o main.c sim.c ../modifying_pass/logger.c -O2 -lSDL2

run:
	./a.out

clean:
