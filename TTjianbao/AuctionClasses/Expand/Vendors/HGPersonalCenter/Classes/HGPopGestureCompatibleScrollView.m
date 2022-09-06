//
//  HGPopGestureCompatibleScrollView.m
//  HGPersonalCenterExtend
//
//  Created by Arch on 2019/5/16.
//

#import "HGPopGestureCompatibleScrollView.h"
#import "JHMallWatchTrackBaseCollection.h"
@implementation HGPopGestureCompatibleScrollView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if (self.contentOffset.x <= 0) {
        if ([otherGestureRecognizer.delegate isKindOfClass:NSClassFromString(@"_FDFullscreenPopGestureRecognizerDelegate")]) {
            return YES;
        }
    }
    return NO;
}

//// 返回YES表示可以继续传递触摸事件，这样两个嵌套的scrollView才能同时滚动
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
//   if ([otherGestureRecognizer.view  isKindOfClass:[UIScrollView class]]&&otherGestureRecognizer.view.tag==105) {
//       return YES;
//    }
//        return NO;
//
//}
@end
