; ModuleID = 'app.c'
source_filename = "app.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-suse-linux"

; Function Attrs: nounwind uwtable
define dso_local void @app() local_unnamed_addr #0 {
  %1 = alloca [512 x [512 x i32]], align 16
  %2 = alloca [512 x [512 x i32]], align 16
  call void @llvm.lifetime.start.p0(i64 1048576, ptr nonnull %1) #4
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(1048576) %1, i8 0, i64 1048576, i1 false)
  call void @llvm.lifetime.start.p0(i64 1048576, ptr nonnull %2) #4
  call void @llvm.memset.p0.i64(ptr noundef nonnull align 16 dereferenceable(1048576) %2, i8 0, i64 1048576, i1 false)
  %3 = getelementptr inbounds [512 x [512 x i32]], ptr %1, i64 0, i64 200, i64 200
  store i32 0, ptr %3, align 16, !tbaa !5
  %4 = getelementptr inbounds [512 x [512 x i32]], ptr %1, i64 0, i64 201, i64 200
  store i32 1, ptr %4, align 16, !tbaa !5
  %5 = getelementptr inbounds [512 x [512 x i32]], ptr %1, i64 0, i64 202, i64 200
  store i32 0, ptr %5, align 16, !tbaa !5
  %6 = getelementptr inbounds [512 x [512 x i32]], ptr %1, i64 0, i64 200, i64 201
  store i32 0, ptr %6, align 4, !tbaa !5
  %7 = getelementptr inbounds [512 x [512 x i32]], ptr %1, i64 0, i64 201, i64 201
  store i32 1, ptr %7, align 4, !tbaa !5
  %8 = getelementptr inbounds [512 x [512 x i32]], ptr %1, i64 0, i64 202, i64 201
  store i32 1, ptr %8, align 4, !tbaa !5
  %9 = getelementptr inbounds [512 x [512 x i32]], ptr %1, i64 0, i64 200, i64 202
  store i32 1, ptr %9, align 8, !tbaa !5
  %10 = getelementptr inbounds [512 x [512 x i32]], ptr %1, i64 0, i64 201, i64 202
  store i32 1, ptr %10, align 8, !tbaa !5
  %11 = getelementptr inbounds [512 x [512 x i32]], ptr %1, i64 0, i64 202, i64 202
  store i32 0, ptr %11, align 8, !tbaa !5
  br label %12

12:                                               ; preds = %0, %85
  %13 = phi i32 [ 0, %0 ], [ %86, %85 ]
  br label %15

14:                                               ; preds = %85
  call void @llvm.lifetime.end.p0(i64 1048576, ptr nonnull %2) #4
  call void @llvm.lifetime.end.p0(i64 1048576, ptr nonnull %1) #4
  ret void

15:                                               ; preds = %12, %24
  %16 = phi i64 [ 0, %12 ], [ %19, %24 ]
  %17 = add nuw i64 %16, 511
  %18 = and i64 %17, 511
  %19 = add nuw nsw i64 %16, 1
  %20 = and i64 %19, 511
  %21 = trunc i64 %16 to i32
  %22 = trunc i64 %16 to i32
  br label %26

23:                                               ; preds = %24
  tail call void (...) @sim_flush() #4
  br label %66

24:                                               ; preds = %64
  %25 = icmp eq i64 %19, 512
  br i1 %25, label %23, label %15, !llvm.loop !9

26:                                               ; preds = %15, %64
  %27 = phi i64 [ 0, %15 ], [ %35, %64 ]
  %28 = add nuw i64 %27, 511
  %29 = and i64 %28, 511
  %30 = getelementptr inbounds [512 x [512 x i32]], ptr %1, i64 0, i64 %18, i64 %29
  %31 = load i32, ptr %30, align 4, !tbaa !5
  %32 = getelementptr inbounds [512 x [512 x i32]], ptr %1, i64 0, i64 %18, i64 %27
  %33 = load i32, ptr %32, align 4, !tbaa !5
  %34 = add nsw i32 %33, %31
  %35 = add nuw nsw i64 %27, 1
  %36 = and i64 %35, 511
  %37 = getelementptr inbounds [512 x [512 x i32]], ptr %1, i64 0, i64 %18, i64 %36
  %38 = load i32, ptr %37, align 4, !tbaa !5
  %39 = add nsw i32 %34, %38
  %40 = getelementptr inbounds [512 x [512 x i32]], ptr %1, i64 0, i64 %16, i64 %36
  %41 = load i32, ptr %40, align 4, !tbaa !5
  %42 = add nsw i32 %39, %41
  %43 = getelementptr inbounds [512 x [512 x i32]], ptr %1, i64 0, i64 %20, i64 %36
  %44 = load i32, ptr %43, align 4, !tbaa !5
  %45 = add nsw i32 %42, %44
  %46 = getelementptr inbounds [512 x [512 x i32]], ptr %1, i64 0, i64 %20, i64 %27
  %47 = load i32, ptr %46, align 4, !tbaa !5
  %48 = add nsw i32 %45, %47
  %49 = getelementptr inbounds [512 x [512 x i32]], ptr %1, i64 0, i64 %20, i64 %29
  %50 = load i32, ptr %49, align 4, !tbaa !5
  %51 = add nsw i32 %48, %50
  %52 = getelementptr inbounds [512 x [512 x i32]], ptr %1, i64 0, i64 %16, i64 %29
  %53 = load i32, ptr %52, align 4, !tbaa !5
  %54 = add nsw i32 %51, %53
  switch i32 %54, label %62 [
    i32 3, label %59
    i32 2, label %55
  ]

55:                                               ; preds = %26
  %56 = getelementptr inbounds [512 x [512 x i32]], ptr %1, i64 0, i64 %16, i64 %27
  %57 = load i32, ptr %56, align 4, !tbaa !5
  %58 = icmp eq i32 %57, 0
  br i1 %58, label %62, label %59

59:                                               ; preds = %26, %55
  %60 = getelementptr inbounds [512 x [512 x i32]], ptr %2, i64 0, i64 %16, i64 %27
  store i32 1, ptr %60, align 4, !tbaa !5
  %61 = trunc i64 %27 to i32
  tail call void @sim_put_pixel(i32 noundef %21, i32 noundef %61, i32 noundef 16711935) #4
  br label %64

62:                                               ; preds = %26, %55
  %63 = trunc i64 %27 to i32
  tail call void @sim_put_pixel(i32 noundef %22, i32 noundef %63, i32 noundef 255) #4
  br label %64

64:                                               ; preds = %59, %62
  %65 = icmp eq i64 %35, 512
  br i1 %65, label %24, label %26, !llvm.loop !11

66:                                               ; preds = %88, %23
  %67 = phi i64 [ 0, %23 ], [ %89, %88 ]
  br label %68

68:                                               ; preds = %68, %66
  %69 = phi i64 [ 0, %66 ], [ %83, %68 ]
  %70 = getelementptr inbounds [512 x [512 x i32]], ptr %2, i64 0, i64 %67, i64 %69
  %71 = getelementptr inbounds i32, ptr %70, i64 4
  %72 = load <4 x i32>, ptr %70, align 16, !tbaa !5
  %73 = load <4 x i32>, ptr %71, align 16, !tbaa !5
  %74 = getelementptr inbounds [512 x [512 x i32]], ptr %1, i64 0, i64 %67, i64 %69
  %75 = getelementptr inbounds i32, ptr %74, i64 4
  store <4 x i32> %72, ptr %74, align 16, !tbaa !5
  store <4 x i32> %73, ptr %75, align 16, !tbaa !5
  store <4 x i32> zeroinitializer, ptr %70, align 16, !tbaa !5
  store <4 x i32> zeroinitializer, ptr %71, align 16, !tbaa !5
  %76 = or disjoint i64 %69, 8
  %77 = getelementptr inbounds [512 x [512 x i32]], ptr %2, i64 0, i64 %67, i64 %76
  %78 = getelementptr inbounds i32, ptr %77, i64 4
  %79 = load <4 x i32>, ptr %77, align 16, !tbaa !5
  %80 = load <4 x i32>, ptr %78, align 16, !tbaa !5
  %81 = getelementptr inbounds [512 x [512 x i32]], ptr %1, i64 0, i64 %67, i64 %76
  %82 = getelementptr inbounds i32, ptr %81, i64 4
  store <4 x i32> %79, ptr %81, align 16, !tbaa !5
  store <4 x i32> %80, ptr %82, align 16, !tbaa !5
  store <4 x i32> zeroinitializer, ptr %77, align 16, !tbaa !5
  store <4 x i32> zeroinitializer, ptr %78, align 16, !tbaa !5
  %83 = add nuw nsw i64 %69, 16
  %84 = icmp eq i64 %83, 512
  br i1 %84, label %88, label %68, !llvm.loop !12

85:                                               ; preds = %88
  %86 = add nuw nsw i32 %13, 1
  %87 = icmp eq i32 %86, 1000000
  br i1 %87, label %14, label %12, !llvm.loop !15

88:                                               ; preds = %68
  %89 = add nuw nsw i64 %67, 1
  %90 = icmp eq i64 %89, 512
  br i1 %90, label %85, label %66, !llvm.loop !16
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
!9 = distinct !{!9, !10}
!10 = !{!"llvm.loop.mustprogress"}
!11 = distinct !{!11, !10}
!12 = distinct !{!12, !10, !13, !14}
!13 = !{!"llvm.loop.isvectorized", i32 1}
!14 = !{!"llvm.loop.unroll.runtime.disable"}
!15 = distinct !{!15, !10}
!16 = distinct !{!16, !10}
