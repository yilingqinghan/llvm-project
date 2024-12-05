# 设置最低版本要求
cmake_minimum_required(VERSION 3.13)

# 项目名称
project(FunctionCallTimePass)

# 查找 LLVM 安装
find_package(LLVM REQUIRED CONFIG)

# 输出 LLVM 信息，便于调试
message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

# 添加 LLVM 必要的 include 和 definitions
include_directories(${LLVM_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS})

# 使用动态链接，避免符号冲突
set(LLVM_ENABLE_DYLIB ON)

# 精确指定所需的 LLVM 组件，避免重复注册问题
llvm_map_components_to_libnames(llvm_libs
    core             # LLVMCore
    support          # LLVMSupport
    irreader         # LLVMIRReader
    analysis         # LLVMAnalysis
    transformutils   # LLVMTransformUtils
    passes           # LLVMPasses
)

# 添加 Pass 的源文件
add_library(FunctionCallTimePass MODULE FunctionCallTimePass.cpp)

# 设置目标属性
set_target_properties(FunctionCallTimePass PROPERTIES
    COMPILE_FLAGS "-fno-rtti"   # LLVM 通常禁用 RTTI
)

# 链接到所需的 LLVM 动态库
target_link_libraries(FunctionCallTimePass PRIVATE ${llvm_libs})

# 启用诊断信息，帮助调试
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
