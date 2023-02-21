#include "printer.h"
#include <stdio.h>
void print_error(const char* const message){
    fprintf(stderr, "%s\n", message);
}

void print_message(const char* const message){
    fprintf(stdout, "%s\n", message);
}

