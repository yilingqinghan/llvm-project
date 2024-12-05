; ModuleID = 'main.ll'
source_filename = "main.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = private unnamed_addr constant [31 x i8] c"Usage: %s <a> <b> <condition>\0A\00", align 1
@.str.1 = private unnamed_addr constant [14 x i8] c"Result: %.2f\0A\00", align 1
@.func_name = private unnamed_addr constant [20 x i8] c"FoldTwoEntryPHINode\00", align 1
@.func_name.1 = private unnamed_addr constant [20 x i8] c"FoldTwoEntryPHINode\00", align 1

; Function Attrs: noinline nounwind uwtable
define dso_local double @example(double noundef %a, double noundef %b, double noundef %condition) #0 {
entry:
  %0 = alloca i64, align 8
  %1 = call i64 @_ly_fun_b()
  store i64 %1, ptr %0, align 8
  %call = call double @fmod(double noundef %a, double noundef 2.000000e+00) #4
  %add = fadd double %condition, %call
  %call1 = call double @fmod(double noundef %b, double noundef 3.000000e+00) #4
  %sub = fsub double %add, %call1
  %cmp = fcmp ogt double %sub, 0.000000e+00
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %mul = fmul double %a, %b
  br label %return

if.else:                                          ; preds = %entry
  %div = fdiv double %a, %b
  br label %return

return:                                           ; preds = %if.else, %if.then
  %retval.0 = phi double [ %mul, %if.then ], [ %div, %if.else ]
  %2 = load i64, ptr %0, align 8
  call void @_ly_fun_e(ptr @.func_name, i64 %2)
  ret double %retval.0
}

; Function Attrs: nounwind
declare double @fmod(double noundef, double noundef) #1

; Function Attrs: noinline nounwind uwtable
define dso_local i32 @main(i32 noundef %argc, ptr noundef %argv) #0 {
entry:
  %0 = alloca i64, align 8
  %1 = call i64 @_ly_fun_b()
  store i64 %1, ptr %0, align 8
  %cmp = icmp ne i32 %argc, 4
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %arrayidx = getelementptr inbounds ptr, ptr %argv, i64 0
  %2 = load ptr, ptr %arrayidx, align 8
  %call = call i32 (ptr, ...) @printf(ptr noundef @.str, ptr noundef %2)
  br label %return

if.end:                                           ; preds = %entry
  %arrayidx1 = getelementptr inbounds ptr, ptr %argv, i64 1
  %3 = load ptr, ptr %arrayidx1, align 8
  %call2 = call double @atof(ptr noundef %3) #5
  %arrayidx3 = getelementptr inbounds ptr, ptr %argv, i64 2
  %4 = load ptr, ptr %arrayidx3, align 8
  %call4 = call double @atof(ptr noundef %4) #5
  %arrayidx5 = getelementptr inbounds ptr, ptr %argv, i64 3
  %5 = load ptr, ptr %arrayidx5, align 8
  %call6 = call double @atof(ptr noundef %5) #5
  %call7 = call double @example(double noundef %call2, double noundef %call4, double noundef %call6)
  %call8 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, double noundef %call7)
  br label %return

return:                                           ; preds = %if.end, %if.then
  %retval.0 = phi i32 [ 1, %if.then ], [ 0, %if.end ]
  %6 = load i64, ptr %0, align 8
  call void @_ly_fun_e(ptr @.func_name.1, i64 %6)
  ret i32 %retval.0
}

declare i32 @printf(ptr noundef, ...) #2

; Function Attrs: nounwind willreturn memory(read)
declare double @atof(ptr noundef) #3

declare i64 @_ly_fun_b()

declare void @_ly_fun_e(ptr, i64)

attributes #0 = { noinline nounwind uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { nounwind willreturn memory(read) "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }
attributes #5 = { nounwind willreturn memory(read) }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"clang version 19.1.0 (https://codeup.aliyun.com/bosc_compiler_team/BOSCCC19.git 6b8da4aea0752fc9ce3134c076524c0fc422bcf5)"}
