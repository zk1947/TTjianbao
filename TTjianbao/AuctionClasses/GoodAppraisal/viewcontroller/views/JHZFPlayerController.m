//
//  JHZFPlayerController.m
//  TTjianbao
//
//  Created by mac on 2019/6/12.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHZFPlayerController.h"

@implementation JHZFPlayerController

- (void)setContainerView:(UIView *)containerView {
    containerView.userInteractionEnabled = YES;
    [self.gestureControl addGestureToView:containerView];
    [super setContainerView:containerView];

}

- (void)layoutPlayerSubViews {
//    [super performSelector:@selector(layoutPlayerSubViews)];
    if (self.containerView && self.currentPlayerManager.view) {
        UIView *superview = nil;
        if (self.isFullScreen) {
            superview = self.orientationObserver.fullScreenContainerView;
        } else if (self.containerView) {
            superview = self.containerView;
        }
        [superview addSubview:self.currentPlayerManager.view];
        
        [self.containerView addSubview:self.controlView];

        self.currentPlayerManager.view.frame = self.playViewFrame;
        self.controlView.frame = CGRectMake(0, 0, self.containerView.bounds.size.width, self.containerView.bounds.size.height - UI.bottomSafeAreaHeight);
        
    }
}

@end
