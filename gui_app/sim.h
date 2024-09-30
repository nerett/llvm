#pragma once

#define SIM_X_SIZE 1024
#define SIM_Y_SIZE 1024

void sim_init();
void sim_destroy();

void sim_put_pixel(int x, int y, int rgba);
void sim_flush();

void app();
