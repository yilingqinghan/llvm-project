# 编译测试文件
rm -rf ./build
clang -O2 -fno-inline -S -emit-llvm main.c -o main.ll # 务必加防内联看效果
# 准备构建
mkdir build && cd build
cmake -DLLVM_DIR=/home/yz/BOSCCC19/llvm/lib/cmake/llvm .. 
make
# 使用 opt 工具加载你的 LLVM Pass 插件，并应用该插件对输入的 LLVM IR 文件进行处理
opt -debug-pass-manager -load-pass-plugin ./libFunctionCallTimePass.so -passes=function-call-time ../main.ll -o main.instrumented.ll
# 将插桩后文件与计时文件链接为可执行
clang main.instrumented.ll ../timer.c -o main.instrumented
# 执行
./main.instrumented