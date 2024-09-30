#include "sim.h"

int main()
{
    sim_init();
    app();
    sim_destroy();

    return 0;
}
