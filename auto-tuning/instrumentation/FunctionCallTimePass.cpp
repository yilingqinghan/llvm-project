#include "llvm/IR/PassManager.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Passes/PassBuilder.h"

using namespace llvm;

// TODO 要改成匹配if conversion的IR

namespace {
class FunctionCallTimePass : public PassInfoMixin<FunctionCallTimePass> {
public:
  PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM) {
    // 跳过空函数或被标记为 optnone 的函数
    if (F.isDeclaration() || F.hasFnAttribute(Attribute::OptimizeNone)) {
      errs() << "Skipping pass: " << F.getName() << " due to optnone or declaration\n";
      return PreservedAnalyses::all();
    }

    LLVMContext &Context = F.getContext();
    Module *M = F.getParent();

    // 插桩：在函数入口记录时间
    Value *StartTimeAlloca = nullptr; // 用于存储开始时间
    if (!F.empty()) {
      BasicBlock &EntryBlock = F.getEntryBlock();
      IRBuilder<> EntryBuilder(&EntryBlock, EntryBlock.begin());

      // 声明 _ly_fun_b 函数
      FunctionCallee BeginFunc = M->getOrInsertFunction(
          "_ly_fun_b", FunctionType::get(EntryBuilder.getInt64Ty(), false));

      // 调用 _ly_fun_b 并将结果存储到变量
      StartTimeAlloca = EntryBuilder.CreateAlloca(EntryBuilder.getInt64Ty());
      Value *StartTime = EntryBuilder.CreateCall(BeginFunc, {});
      EntryBuilder.CreateStore(StartTime, StartTimeAlloca);
    }

    // 插桩：在函数返回之前打印执行时间
    for (auto &BB : F) {
      for (auto &I : BB) {
        if (auto *RetInst = dyn_cast<ReturnInst>(&I)) {
          IRBuilder<> RetBuilder(RetInst);

          // 声明 _ly_fun_e 函数
          Type *ParamTys[] = {
              Type::getInt8Ty(Context)->getPointerTo(), // i8*
              Type::getInt64Ty(Context)                 // i64
          };
          FunctionType *FT = FunctionType::get(Type::getVoidTy(Context), ParamTys, false);
          FunctionCallee EndFunc = M->getOrInsertFunction("_ly_fun_e", FT);

          // 创建全局字符串保存函数名
          Value *FuncName = RetBuilder.CreateGlobalStringPtr(F.getName(), ".func_name");
          Value *StartTime = RetBuilder.CreateLoad(RetBuilder.getInt64Ty(), StartTimeAlloca);

          // 调用 _ly_fun_e
          RetBuilder.CreateCall(EndFunc, {FuncName, StartTime});
        }
      }
    }

    errs() << "Instrumented function: " << F.getName() << "\n";
    return PreservedAnalyses::none();
  }
};
} // namespace

// 插件注册
llvm::PassPluginLibraryInfo getFunctionCallTimePassPluginInfo() {
  return {LLVM_PLUGIN_API_VERSION, "FunctionCallTimePass", LLVM_VERSION_STRING,
          [](PassBuilder &PB) {
            PB.registerPipelineParsingCallback(
                [](StringRef Name, FunctionPassManager &FPM,
                   ArrayRef<PassBuilder::PipelineElement>) {
                  if (Name == "function-call-time") {
                    FPM.addPass(FunctionCallTimePass());
                    return true;
                  }
                  return false;
                });
          }};
}

// 外部接口
extern "C" LLVM_ATTRIBUTE_WEAK ::llvm::PassPluginLibraryInfo
llvmGetPassPluginInfo() {
  return getFunctionCallTimePassPluginInfo();
}
