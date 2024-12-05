#!/bin/bash

# 开启调试输出
set -x

# 删除所有CSV文件
rm -f ./*.csv

# 生成LLVM汇编代码
../../build/bin/clang -O0 -fno-inline -S -emit-llvm main.c -o main.ll

# 移除optnone标记
sed -i 's/\<optnone\>//g' main.ll

# 运行mem2reg优化
../../build/bin/opt -passes="mem2reg" main.ll -S -o main.ll

# 使用simplifycfg优化，并生成新的LLVM代码
../../build/bin/opt -ir-dump-directory="testt" -passes="simplifycfg" main.ll -S -o main-opt.ll

# 编译优化后的代码
../../build/bin/clang main-opt.ll ./timer.c -lm -o main

# 检测当前操作系统
OS_TYPE=$(uname)
chmod +x main
# 根据操作系统决定是否使用 taskset
if [[ "$OS_TYPE" == "Linux" ]]; then
    # 在 Linux 上使用 taskset
    taskset -c 28 ./main 3245.123589 21323.78034 12124.17901
else
    # 在 macOS 或其他操作系统上，不使用 taskset
    ./main 3245.123589 21323.78034 12124.17901
fi

# # 编译未优化的代码
# ../../build/bin/clang main-unopt.ll ./timer.c -lm -o main

# # 在 macOS 或 Linux 上执行未优化的代码
# if [[ "$OS_TYPE" == "Linux" ]]; then
#     # 在 Linux 上使用 taskset
#     taskset -c 28 ./main 3245.123589 21323.78034 12124.17901
# else
#     # 在 macOS 或其他操作系统上，不使用 taskset
#     ./main 3245.123589 21323.78034 12124.17901
# fi
