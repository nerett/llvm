#include <stdio.h>

void log_instruction(char* prev_name, char* next_name)
{
    printf("[LOG] '%s' <- '%s'\n", next_name, prev_name);
}
