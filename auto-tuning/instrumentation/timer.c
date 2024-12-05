#include <stdio.h>
#include <time.h>

long _ly_fun_b() {
    struct timespec start;
    clock_gettime(CLOCK_MONOTONIC, &start);
    return start.tv_sec * 1000000000L + start.tv_nsec; // 纳秒精度
}

void _ly_fun_e(const char *name, long start) {
    struct timespec end;
    clock_gettime(CLOCK_MONOTONIC, &end);
    long duration = (end.tv_sec * 1000000000L + end.tv_nsec) - start; // 纳秒精度
    printf("%s 耗时【 %ld ns】\n", name, duration);
}
