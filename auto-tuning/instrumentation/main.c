#include <stdio.h>
#include <stdlib.h>
#include <math.h>

// 原始函数
double example(double a, double b, double condition) {
    // 将 condition 改得更复杂
    if ((condition + fmod(a, 2.0) - fmod(b, 3.0)) > 0.0) {
        return a * b;
    } else {
        return a / b;
    }
}

int main(int argc, char *argv[]) {
    // 检查命令行参数是否正确
    if (argc != 4) {
        printf("Usage: %s <a> <b> <condition>\n", argv[0]);
        return 1;
    }

    // 转换参数为 double 类型
    double a = atof(argv[1]);         // 转换第一个参数为 double
    double b = atof(argv[2]);         // 转换第二个参数为 double
    double condition = atof(argv[3]); // 转换第三个参数为 double

    // 调用 example 函数并输出结果
    double result = example(a, b, condition);
    printf("Result: %.2f\n", result); // 保留两位小数

    return 0;
}