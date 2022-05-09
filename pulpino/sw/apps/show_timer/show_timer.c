#include <stdio.h>

#include "pulpino.h"
#include "timer.h"

int main(int argc, char const* argv[]) {

    reset_timer();
    start_timer();

    for (size_t i = 0; i < 10000; i++) {}
    printf("Current time: %d\n", get_time());

    for (size_t i = 0; i < 2000; i++) {}
    printf("Current time: %d\n", get_time());

    for (size_t i = 0; i < 35900; i++) {}
    printf("Current time: %d\n", get_time());

    return 0;
}
