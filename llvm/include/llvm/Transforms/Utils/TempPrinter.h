#ifndef TEMP_PRINTER_H
#define TEMP_PRINTER_H

#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IR/LLVMContext.h" // 包含头文件
#include "llvm/IR/MDBuilder.h"
#include "llvm/IR/Metadata.h"
#include "llvm/Support/FileSystem.h"
#include "llvm/Support/Path.h"
#include "llvm/Support/raw_ostream.h"

#include <atomic>
#include <fstream>
#include <string>

namespace llvm {

#define OPTIMIZE_AND_DUMP_METADATA(BB, funcName, realOpt, whichRet, cost, budget, isValid, path) \
  { \
    llvm::OptimizationStats stats(llvm::getUniqueGlobalID(), funcName, realOpt, whichRet, cost, budget, isValid); \
    insertOptimizationMetadata((BB)->front(), stats); \
    dumpOptimizationData(stats, path); \
  }



struct OptimizationStats {
  uint64_t globalID;
  std::string funcName;
  bool realOpt;
  uint64_t whichRet;
  uint64_t cost;
  uint64_t budget;
  bool isValid;

  // 添加一个接受所有参数的构造函数
  OptimizationStats(uint64_t globalID, const std::string& funcName, bool realOpt, uint64_t whichRet, uint64_t cost, uint64_t budget, bool isValid)
    : globalID(globalID), funcName(funcName), realOpt(realOpt), whichRet(whichRet), cost(cost), budget(budget), isValid(isValid) {}
};


// 静态函数，用于生成全局唯一编号
inline uint64_t getUniqueGlobalID() {
  static std::atomic<uint64_t> GlobalCounter(0);
  return GlobalCounter.fetch_add(1, std::memory_order_relaxed);
}

inline void insertOptimizationMetadata(llvm::Instruction &I, const OptimizationStats &stats) {
  llvm::LLVMContext &Context = I.getContext();

  // 使用 ArrayRef 而不是 std::vector
  llvm::Metadata *metadataList[] = {
      llvm::ConstantAsMetadata::get(llvm::ConstantInt::get(Context, llvm::APInt(64, stats.globalID))),    // 全局唯一编号
      llvm::MDString::get(Context, stats.funcName),                                                       // 优化的函数名称
      llvm::ConstantAsMetadata::get(llvm::ConstantInt::get(Context, llvm::APInt(1, stats.realOpt ? 1 : 0))), // 是否实际优化
      llvm::ConstantAsMetadata::get(llvm::ConstantInt::get(Context, llvm::APInt(64, stats.whichRet))),    // 第几个 return
      llvm::ConstantAsMetadata::get(llvm::ConstantInt::get(Context, llvm::APInt(64, stats.cost))),        // 优化成本
      llvm::ConstantAsMetadata::get(llvm::ConstantInt::get(Context, llvm::APInt(64, stats.budget))),      // 优化预算
      llvm::ConstantAsMetadata::get(llvm::ConstantInt::get(Context, llvm::APInt(1, stats.isValid ? 1 : 0))) // 是否有效
  };

  // 使用 ArrayRef 直接包装 C 风格数组
  llvm::MDNode *OptMetadata = llvm::MDNode::get(Context, llvm::ArrayRef<llvm::Metadata*>(metadataList));

  // 设置 Metadata
  I.setMetadata("Topt_info", OptMetadata);
}

// 将优化数据输出到文件
inline void dumpOptimizationData(const OptimizationStats &stats,
                                 const std::string &FilePath) {
  std::error_code EC;
  bool isNewFile = !llvm::sys::fs::exists(FilePath);
  llvm::raw_fd_ostream FileStream(
      FilePath, EC, llvm::sys::fs::OF_Text | llvm::sys::fs::OF_Append);
  if (EC) {
    llvm::errs() << "Error opening file: " << EC.message() << "\n";
    return;
  }

  if (isNewFile) {
    // 在新文件中输出表头
    FileStream << "GlobalID,FunctionName,RealOptimization,WhichReturn,Cost,"
                  "Budget,IsValid\n";
  }

  // 输出优化统计数据
  FileStream << stats.globalID << "," << stats.funcName << ","
             << (stats.realOpt ? "True" : "False") << "," << stats.whichRet
             << "," << stats.cost << "," << stats.budget << ","
             << (stats.isValid ? "Valid" : "Invalid") << "\n";
}

} // namespace llvm

#endif // TEMP_PRINTER_H