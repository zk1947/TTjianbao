//
//  UIView+JHGestureAnimation.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/8/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "UIView+JHGestureAnimation.h"

@implementation UIView (JHGestureAnimation)

- (void)addPanGestureWithType : (DraggingType)type {
    
    //添加手势
//    UIPanGestureRecognizer *panRcognize=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    
    @weakify(self)
    UIPanGestureRecognizer *panRcognize = [[UIPanGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        @strongify(self)
        [self handlePanGesture:sender type:type];
    }];
    [panRcognize setMinimumNumberOfTouches:1];
    [panRcognize setEnabled:YES];
    [panRcognize delaysTouchesEnded];
    [panRcognize cancelsTouchesInView];
    [self addGestureRecognizer:panRcognize];
}
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer type : (DraggingType)type
{
    if (self.superview == nil) return;
    //移动状态
    UIGestureRecognizerState recState =  recognizer.state;
    
    switch (recState) {
        case UIGestureRecognizerStateBegan:
            
            break;
        case UIGestureRecognizerStateChanged:
            [self setupPointChange:recognizer type:type];
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (recognizer.state == UIGestureRecognizerStateEnded) {
                [self setupPointChange:recognizer type:type];
            }
        }
            break;
            
        default:
            break;
    }
    
    [recognizer setTranslation:CGPointMake(0, 0) inView:self.superview];
}
- (void)setupPointChange:(UIPanGestureRecognizer *)recognizer type : (DraggingType)type {
    CGPoint translatedPoint = [recognizer translationInView:self.superview];
    CGPoint newCenter = CGPointMake(recognizer.view.center.x+ translatedPoint.x,recognizer.view.center.y + translatedPoint.y);
    
    newCenter.x = MAX(recognizer.view.frame.size.width/2, newCenter.x);
    newCenter.x = MIN(ScreenW - recognizer.view.frame.size.width/2,newCenter.x);
    newCenter.y = MAX(recognizer.view.frame.size.height/2+UI.topSafeAreaHeight, newCenter.y);
    newCenter.y = MIN(ScreenH - recognizer.view.frame.size.height/2 - UI.topSafeAreaHeight - UI.bottomSafeAreaHeight,  newCenter.y);
    if (type == DraggingTypeRight) {
        newCenter.x = ScreenW - recognizer.view.width/2;
    }else if (type == DraggingTypeLeft) {
        newCenter.x = recognizer.view.width/2;
    }else {
        if (newCenter.x < ScreenW/2) {//小于：屏幕左边
            newCenter.x = recognizer.view.width/2;
        }
        else {
            newCenter.x = ScreenW - recognizer.view.width/2;
        }
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        recognizer.view.center = newCenter;
    }];
}
@end
