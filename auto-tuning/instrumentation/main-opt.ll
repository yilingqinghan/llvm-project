; ModuleID = 'main.ll'
source_filename = "main.c"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx15.0.0"

@.str = private unnamed_addr constant [31 x i8] c"Usage: %s <a> <b> <condition>\0A\00", align 1
@.str.1 = private unnamed_addr constant [14 x i8] c"Result: %.2f\0A\00", align 1

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define double @example(double noundef %a, double noundef %b, double noundef %condition) #0 {
entry:
  %retval = alloca double, align 8
  %a.addr = alloca double, align 8
  %b.addr = alloca double, align 8
  %condition.addr = alloca double, align 8
  store double %a, ptr %a.addr, align 8
  store double %b, ptr %b.addr, align 8
  store double %condition, ptr %condition.addr, align 8
  %0 = load double, ptr %condition.addr, align 8
  %1 = load double, ptr %a.addr, align 8
  %fmod = frem double %1, 2.000000e+00
  %add = fadd double %0, %fmod
  %2 = load double, ptr %b.addr, align 8
  %fmod1 = frem double %2, 3.000000e+00
  %sub = fsub double %add, %fmod1
  %cmp = fcmp ogt double %sub, 0.000000e+00
  br i1 %cmp, label %if.then, label %if.else

if.then:                                          ; preds = %entry
  %3 = load double, ptr %a.addr, align 8
  %4 = load double, ptr %b.addr, align 8
  %mul = fmul double %3, %4
  store double %mul, ptr %retval, align 8
  br label %return

if.else:                                          ; preds = %entry
  %5 = load double, ptr %a.addr, align 8
  %6 = load double, ptr %b.addr, align 8
  %div = fdiv double %5, %6
  store double %div, ptr %retval, align 8
  br label %return

return:                                           ; preds = %if.else, %if.then
  %7 = load double, ptr %retval, align 8
  ret double %7
}

; Function Attrs: noinline nounwind optnone ssp uwtable(sync)
define i32 @main(i32 noundef %argc, ptr noundef %argv) #0 {
entry:
  %retval = alloca i32, align 4
  %argc.addr = alloca i32, align 4
  %argv.addr = alloca ptr, align 8
  %a = alloca double, align 8
  %b = alloca double, align 8
  %condition = alloca double, align 8
  %result = alloca double, align 8
  store i32 0, ptr %retval, align 4
  store i32 %argc, ptr %argc.addr, align 4
  store ptr %argv, ptr %argv.addr, align 8
  %0 = load i32, ptr %argc.addr, align 4
  %cmp = icmp ne i32 %0, 4
  br i1 %cmp, label %if.then, label %if.end

if.then:                                          ; preds = %entry
  %1 = load ptr, ptr %argv.addr, align 8
  %arrayidx = getelementptr inbounds ptr, ptr %1, i64 0
  %2 = load ptr, ptr %arrayidx, align 8
  %call = call i32 (ptr, ...) @printf(ptr noundef @.str, ptr noundef %2)
  store i32 1, ptr %retval, align 4
  br label %return

if.end:                                           ; preds = %entry
  %3 = load ptr, ptr %argv.addr, align 8
  %arrayidx1 = getelementptr inbounds ptr, ptr %3, i64 1
  %4 = load ptr, ptr %arrayidx1, align 8
  %call2 = call double @atof(ptr noundef %4)
  store double %call2, ptr %a, align 8
  %5 = load ptr, ptr %argv.addr, align 8
  %arrayidx3 = getelementptr inbounds ptr, ptr %5, i64 2
  %6 = load ptr, ptr %arrayidx3, align 8
  %call4 = call double @atof(ptr noundef %6)
  store double %call4, ptr %b, align 8
  %7 = load ptr, ptr %argv.addr, align 8
  %arrayidx5 = getelementptr inbounds ptr, ptr %7, i64 3
  %8 = load ptr, ptr %arrayidx5, align 8
  %call6 = call double @atof(ptr noundef %8)
  store double %call6, ptr %condition, align 8
  %9 = load double, ptr %a, align 8
  %10 = load double, ptr %b, align 8
  %11 = load double, ptr %condition, align 8
  %call7 = call double @example(double noundef %9, double noundef %10, double noundef %11)
  store double %call7, ptr %result, align 8
  %12 = load double, ptr %result, align 8
  %call8 = call i32 (ptr, ...) @printf(ptr noundef @.str.1, double noundef %12)
  store i32 0, ptr %retval, align 4
  br label %return

return:                                           ; preds = %if.end, %if.then
  %13 = load i32, ptr %retval, align 4
  ret i32 %13
}

declare i32 @printf(ptr noundef, ...) #1

declare double @atof(ptr noundef) #1

attributes #0 = { noinline nounwind optnone ssp uwtable(sync) "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }
attributes #1 = { "frame-pointer"="non-leaf" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="apple-m1" "target-features"="+aes,+altnzcv,+ccdp,+ccidx,+ccpp,+complxnum,+crc,+dit,+dotprod,+flagm,+fp-armv8,+fp16fml,+fptoint,+fullfp16,+jsconv,+lse,+neon,+pauth,+perfmon,+predres,+ras,+rcpc,+rdm,+sb,+sha2,+sha3,+specrestrict,+ssbs,+v8.1a,+v8.2a,+v8.3a,+v8.4a,+v8a,+zcm,+zcz" }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}

!0 = !{i32 2, !"SDK Version", [2 x i32] [i32 15, i32 1]}
!1 = !{i32 1, !"wchar_size", i32 4}
!2 = !{i32 8, !"PIC Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 1}
!5 = !{!"clang version 20.0.0git (https://github.com/yilingqinghan/llvm-project.git af4ae12780099d3df0b89bccc80fd69b240f345e)"}
