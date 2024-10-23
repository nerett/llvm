; ModuleID = 'app.c'
source_filename = "app.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-suse-linux"

; Function Attrs: nounwind uwtable
define dso_local void @app() local_unnamed_addr #0 {
  %1 = alloca [262144 x i32], align 16
  %2 = alloca [262144 x i32], align 16
  call void @llvm.lifetime.start.p0(i64 1048576, ptr nonnull %1) #4
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(1048576) %1, i8 0, i64 1048576, i1 false)
  call void @llvm.lifetime.start.p0(i64 1048576, ptr nonnull %2) #4
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(1048576) %2, i8 0, i64 1048576, i1 false)
  %3 = getelementptr inbounds [262144 x i32], ptr %1, i64 0, i64 102600
  store i32 0, ptr %3, align 16, !tbaa !5
  %4 = getelementptr inbounds [262144 x i32], ptr %1, i64 0, i64 102601
  store i32 1, ptr %4, align 4, !tbaa !5
  %5 = getelementptr inbounds [262144 x i32], ptr %1, i64 0, i64 102602
  store i32 0, ptr %5, align 8, !tbaa !5
  %6 = getelementptr inbounds [262144 x i32], ptr %1, i64 0, i64 103112
  store i32 0, ptr %6, align 16, !tbaa !5
  %7 = getelementptr inbounds [262144 x i32], ptr %1, i64 0, i64 103113
  store i32 1, ptr %7, align 4, !tbaa !5
  %8 = getelementptr inbounds [262144 x i32], ptr %1, i64 0, i64 103114
  store i32 1, ptr %8, align 8, !tbaa !5
  %9 = getelementptr inbounds [262144 x i32], ptr %1, i64 0, i64 103624
  store i32 1, ptr %9, align 16, !tbaa !5
  %10 = getelementptr inbounds [262144 x i32], ptr %1, i64 0, i64 103625
  store i32 1, ptr %10, align 4, !tbaa !5
  %11 = getelementptr inbounds [262144 x i32], ptr %1, i64 0, i64 103626
  store i32 0, ptr %11, align 8, !tbaa !5
  br label %12

12:                                               ; preds = %0, %90
  %13 = phi i32 [ 0, %0 ], [ %91, %90 ]
  br label %15

14:                                               ; preds = %90
  call void @llvm.lifetime.end.p0(i64 1048576, ptr nonnull %2) #4
  call void @llvm.lifetime.end.p0(i64 1048576, ptr nonnull %1) #4
  ret void

15:                                               ; preds = %12, %29
  %16 = phi i64 [ 0, %12 ], [ %20, %29 ]
  %17 = trunc i64 %16 to i32
  %18 = add i32 %17, 511
  %19 = and i32 %18, 511
  %20 = add nuw nsw i64 %16, 1
  %21 = trunc i64 %20 to i32
  %22 = and i32 %21, 511
  %23 = and i64 %20, 511
  %24 = zext nneg i32 %19 to i64
  %25 = trunc i64 %16 to i32
  %26 = trunc i64 %16 to i32
  %27 = trunc i64 %16 to i32
  br label %31

28:                                               ; preds = %29
  tail call void (...) @sim_flush() #4
  br label %93

29:                                               ; preds = %86
  %30 = icmp eq i64 %20, 512
  br i1 %30, label %28, label %15, !llvm.loop !9

31:                                               ; preds = %15, %86
  %32 = phi i64 [ 0, %15 ], [ %45, %86 ]
  %33 = shl nuw nsw i64 %32, 9
  %34 = trunc i64 %33 to i32
  %35 = add i32 %34, 261632
  %36 = and i32 %35, 261632
  %37 = or disjoint i32 %36, %19
  %38 = zext nneg i32 %37 to i64
  %39 = getelementptr inbounds [262144 x i32], ptr %1, i64 0, i64 %38
  %40 = load i32, ptr %39, align 4, !tbaa !5
  %41 = or disjoint i64 %33, %24
  %42 = getelementptr inbounds [262144 x i32], ptr %1, i64 0, i64 %41
  %43 = load i32, ptr %42, align 4, !tbaa !5
  %44 = add nsw i32 %43, %40
  %45 = add nuw nsw i64 %32, 1
  %46 = trunc i64 %33 to i32
  %47 = add i32 %46, 512
  %48 = and i32 %47, 261632
  %49 = or disjoint i32 %48, %19
  %50 = zext nneg i32 %49 to i64
  %51 = getelementptr inbounds [262144 x i32], ptr %1, i64 0, i64 %50
  %52 = load i32, ptr %51, align 4, !tbaa !5
  %53 = add nsw i32 %44, %52
  %54 = or disjoint i32 %48, %25
  %55 = zext nneg i32 %54 to i64
  %56 = getelementptr inbounds [262144 x i32], ptr %1, i64 0, i64 %55
  %57 = load i32, ptr %56, align 4, !tbaa !5
  %58 = add nsw i32 %53, %57
  %59 = or disjoint i32 %48, %22
  %60 = zext nneg i32 %59 to i64
  %61 = getelementptr inbounds [262144 x i32], ptr %1, i64 0, i64 %60
  %62 = load i32, ptr %61, align 4, !tbaa !5
  %63 = add nsw i32 %58, %62
  %64 = or disjoint i64 %33, %23
  %65 = getelementptr inbounds [262144 x i32], ptr %1, i64 0, i64 %64
  %66 = load i32, ptr %65, align 4, !tbaa !5
  %67 = add nsw i32 %63, %66
  %68 = or disjoint i32 %36, %22
  %69 = zext nneg i32 %68 to i64
  %70 = getelementptr inbounds [262144 x i32], ptr %1, i64 0, i64 %69
  %71 = load i32, ptr %70, align 4, !tbaa !5
  %72 = add nsw i32 %67, %71
  %73 = or disjoint i32 %36, %26
  %74 = zext nneg i32 %73 to i64
  %75 = getelementptr inbounds [262144 x i32], ptr %1, i64 0, i64 %74
  %76 = load i32, ptr %75, align 4, !tbaa !5
  %77 = add nsw i32 %72, %76
  switch i32 %77, label %86 [
    i32 3, label %83
    i32 2, label %78
  ]

78:                                               ; preds = %31
  %79 = or disjoint i64 %33, %16
  %80 = getelementptr inbounds [262144 x i32], ptr %1, i64 0, i64 %79
  %81 = load i32, ptr %80, align 4, !tbaa !5
  %82 = icmp eq i32 %81, 0
  br i1 %82, label %86, label %83

83:                                               ; preds = %31, %78
  %84 = or disjoint i64 %33, %16
  %85 = getelementptr inbounds [262144 x i32], ptr %2, i64 0, i64 %84
  store i32 1, ptr %85, align 4, !tbaa !5
  br label %86

86:                                               ; preds = %78, %31, %83
  %87 = phi i32 [ 16711935, %83 ], [ 255, %31 ], [ 255, %78 ]
  %88 = trunc i64 %32 to i32
  tail call void @sim_put_pixel(i32 noundef %27, i32 noundef %88, i32 noundef %87) #4
  %89 = icmp eq i64 %45, 512
  br i1 %89, label %29, label %31, !llvm.loop !12

90:                                               ; preds = %93
  %91 = add nuw nsw i32 %13, 1
  %92 = icmp eq i32 %91, 1000000
  br i1 %92, label %14, label %12, !llvm.loop !13

93:                                               ; preds = %28, %93
  %94 = phi i64 [ 0, %28 ], [ %98, %93 ]
  %95 = getelementptr inbounds [262144 x i32], ptr %2, i64 0, i64 %94
  %96 = load i32, ptr %95, align 4, !tbaa !5
  %97 = getelementptr inbounds [262144 x i32], ptr %1, i64 0, i64 %94
  store i32 %96, ptr %97, align 4, !tbaa !5
  store i32 0, ptr %95, align 4, !tbaa !5
  %98 = add nuw nsw i64 %94, 1
  %99 = icmp eq i64 %98, 262144
  br i1 %99, label %90, label %93, !llvm.loop !14
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(i64 immarg, ptr nocapture) #1

; Function Attrs: mustprogress nocallback nofree nounwind willreturn memory(argmem: write)
declare void @llvm.memset.p0.i64(ptr nocapture writeonly, i8, i64, i1 immarg) #2

declare void @sim_put_pixel(i32 noundef, i32 noundef, i32 noundef) local_unnamed_addr #3

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(i64 immarg, ptr nocapture) #1

declare void @sim_flush(...) local_unnamed_addr #3

attributes #0 = { nounwind uwtable "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { mustprogress nocallback nofree nounwind willreturn memory(argmem: write) }
attributes #3 = { "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cmov,+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3}
!llvm.ident = !{!4}

!0 = !{i32 1, !"wchar_size", i32 4}
!1 = !{i32 8, !"PIC Level", i32 2}
!2 = !{i32 7, !"PIE Level", i32 2}
!3 = !{i32 7, !"uwtable", i32 2}
!4 = !{!"clang version 18.1.8"}
!5 = !{!6, !6, i64 0}
!6 = !{!"int", !7, i64 0}
!7 = !{!"omnipotent char", !8, i64 0}
!8 = !{!"Simple C/C++ TBAA"}
!9 = distinct !{!9, !10, !11}
!10 = !{!"llvm.loop.mustprogress"}
!11 = !{!"llvm.loop.unroll.disable"}
!12 = distinct !{!12, !10, !11}
!13 = distinct !{!13, !10, !11}
!14 = distinct !{!14, !10, !11}
