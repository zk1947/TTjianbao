//
//  JHGestView.m
//  TTjianbao
//
//  Created by yaoyao on 2019/4/18.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHGestView.h"
#import "TTjianbaoHeader.h"

@interface JHGestView ()<UIGestureRecognizerDelegate> {
    CGPoint beginPoint;
}
@end

@implementation JHGestView

- (void)setGestView:(UIView *)gestView {
    _gestView = gestView;
    
    [self initGest];
}

- (void)initGest{
    self.backgroundColor = [UIColor clearColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeSelf)];
    [self addGestureRecognizer:tap];

    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(blankAction)];
    [self.gestView addGestureRecognizer:tap1];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGestureHandler:)];
    pan.delegate=self;
    [self.gestView addGestureRecognizer:pan];

    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeAction:)];
    [self.gestView addGestureRecognizer:swipe];
    
}

- (void)closeSelf {
    [self hiddenAlert];
}

- (void)swipeAction:(UISwipeGestureRecognizer *)gest {
    
    if (gest.direction == UISwipeGestureRecognizerDirectionDown) {
        [self hiddenAlert];
    }
}

- (void)panGestureHandler:(UIPanGestureRecognizer *)gesture {
    
    CGPoint translation = [gesture translationInView:gesture.view];
    if ([gesture.view isKindOfClass:[UIScrollView class]]) {
        UIScrollView * view=(UIScrollView*)gesture.view;
        if (view.contentOffset.y<=0) {
            view.panGestureRecognizer.enabled = NO;
           view.panGestureRecognizer.enabled = YES;
        }
        else{
            
             view.panGestureRecognizer.enabled = NO;
        }
    }
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            beginPoint = translation;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if (translation.y>beginPoint.y) {
                self.mj_y = translation.y - beginPoint.y;
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            if (self.centerY>ScreenH/2.+100) {
                [self hiddenAlert];
            }else {
                [self showAlert];
            }
            break;
        }
        default:
            break;
    }
}

- (void)blankAction {
    
}

- (void)showAlert {
    CGRect rect = self.frame;
    rect.origin.y = ScreenH - rect.size.height;
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = rect;
    }];
}

- (void)hiddenAlert {
    CGRect rect = self.frame;
    rect.origin.y = ScreenH;
    [UIView animateWithDuration:0.25f animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (self.hideComplete) {
            self.hideComplete();
        }
    }];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *gesture =(UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint translation = [gesture translationInView:gesture.view];
        if (translation.y<0) {
            return NO;
        }
    if ([gestureRecognizer.view isKindOfClass:[UIScrollView class]]) {
            UIScrollView * view=(UIScrollView*)gestureRecognizer.view;
            if (view.contentOffset.y<=0) {
                return YES;
            }
            return NO;
        }
    }
  return YES;
}

@end
