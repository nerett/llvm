#include <stdlib.h>
#include <SDL2/SDL.h>
#include "sim.h"

static SDL_Renderer* renderer = NULL;
static SDL_Window* window = NULL;

void sim_init()
{
    SDL_Init(SDL_INIT_VIDEO);

    window = SDL_CreateWindow("sim", SDL_WINDOWPOS_CENTERED, SDL_WINDOWPOS_CENTERED, SIM_X_SIZE, SIM_Y_SIZE, 0);
    renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_SOFTWARE | SDL_RENDERER_PRESENTVSYNC);

    SDL_SetRenderDrawColor(renderer, 0, 0, 0, SDL_ALPHA_OPAQUE);
    SDL_RenderClear(renderer);
}

void sim_destroy()
{
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
}

void sim_put_pixel(int x, int y, int rgba)
{
    Uint8 r = rgba >> 24;
    Uint8 g = rgba >> 16;
    Uint8 b = rgba >> 8;
    Uint8 a = rgba;

    SDL_SetRenderDrawColor(renderer, r, g, b, a);
    SDL_RenderDrawPoint(renderer, x, y);
}

void sim_flush()
{
    SDL_PumpEvents();
    if (SDL_HasEvent(SDL_QUIT) == SDL_TRUE) {
        sim_destroy();
        exit(EXIT_SUCCESS);
    }

    SDL_RenderPresent(renderer);
}
