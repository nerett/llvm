#include "sim.h"

#define MAX_EPOCH 1000000
//#define MAX_EPOCH 2
#define ALIVE_COLOR 0x00FF00FF
#define DEAD_COLOR 0x000000FF

// Conway's Game of Life
void app()
{
    int cur_field[SIM_X_SIZE * SIM_Y_SIZE] = { 0 };
    int next_field[SIM_X_SIZE * SIM_Y_SIZE] = { 0 };
    int nc = 0;

    // Initial configuration (R-pentomino)
    // layer 1
    cur_field[200%SIM_X_SIZE + 200%SIM_Y_SIZE*SIM_X_SIZE] = 0;
    cur_field[201%SIM_X_SIZE + 200%SIM_Y_SIZE*SIM_X_SIZE] = 1;
    cur_field[202%SIM_X_SIZE + 200%SIM_Y_SIZE*SIM_X_SIZE] = 0;
    // layer 2
    cur_field[200%SIM_X_SIZE + 201%SIM_Y_SIZE*SIM_X_SIZE] = 0;
    cur_field[201%SIM_X_SIZE + 201%SIM_Y_SIZE*SIM_X_SIZE] = 1;
    cur_field[202%SIM_X_SIZE + 201%SIM_Y_SIZE*SIM_X_SIZE] = 1;
    // layer 3
    cur_field[200%SIM_X_SIZE + 202%SIM_Y_SIZE*SIM_X_SIZE] = 1;
    cur_field[201%SIM_X_SIZE + 202%SIM_Y_SIZE*SIM_X_SIZE] = 1;
    cur_field[202%SIM_X_SIZE + 202%SIM_Y_SIZE*SIM_X_SIZE] = 0;


    for (int epoch = 0; epoch < MAX_EPOCH; ++epoch) {
        for (int i = 0; i < SIM_X_SIZE; ++i) {
            for (int j = 0; j < SIM_Y_SIZE; ++j) {
                nc = 0;

                nc += cur_field[(i - 1 + SIM_X_SIZE)%SIM_X_SIZE + (j - 1 + SIM_Y_SIZE)%SIM_Y_SIZE*SIM_X_SIZE];
                nc += cur_field[(i - 1 + SIM_X_SIZE)%SIM_X_SIZE + (j - 0 + SIM_Y_SIZE)%SIM_Y_SIZE*SIM_X_SIZE];
                nc += cur_field[(i - 1 + SIM_X_SIZE)%SIM_X_SIZE + (j + 1 + SIM_Y_SIZE)%SIM_Y_SIZE*SIM_X_SIZE];
                nc += cur_field[(i - 0 + SIM_X_SIZE)%SIM_X_SIZE + (j + 1 + SIM_Y_SIZE)%SIM_Y_SIZE*SIM_X_SIZE];
                nc += cur_field[(i + 1 + SIM_X_SIZE)%SIM_X_SIZE + (j + 1 + SIM_Y_SIZE)%SIM_Y_SIZE*SIM_X_SIZE];
                nc += cur_field[(i + 1 + SIM_X_SIZE)%SIM_X_SIZE + (j - 0 + SIM_Y_SIZE)%SIM_Y_SIZE*SIM_X_SIZE];
                nc += cur_field[(i + 1 + SIM_X_SIZE)%SIM_X_SIZE + (j - 1 + SIM_Y_SIZE)%SIM_Y_SIZE*SIM_X_SIZE];
                nc += cur_field[(i - 0 + SIM_X_SIZE)%SIM_X_SIZE + (j - 1 + SIM_Y_SIZE)%SIM_Y_SIZE*SIM_X_SIZE];

                if ((nc == 3) || (nc == 2 && cur_field[i + j*SIM_X_SIZE])) {
                    next_field[i + j*SIM_X_SIZE] = 1;
                    sim_put_pixel(i, j, ALIVE_COLOR);
                } else {
                    sim_put_pixel(i, j, DEAD_COLOR);
                }
            }
        }

        sim_flush();

        for (int k = 0; k < SIM_X_SIZE * SIM_Y_SIZE; ++k) {
            cur_field[k] = next_field[k];
            next_field[k] = 0;
        }
    }
}
