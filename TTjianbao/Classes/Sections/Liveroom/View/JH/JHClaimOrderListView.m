//
//  JHClaimOrderListView.m
//  TTjianbao
//
//  Created by yaoyao on 2019/2/26.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHClaimOrderListView.h"
#import "JHClaimOrderListViewController.h"


@interface JHClaimOrderListView ()
@property (nonatomic, strong)JHClaimOrderListViewController *claimVC;
@end


@implementation JHClaimOrderListView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        [self addSubview:self.claimVC.view];
        self.claimVC.view.frame = CGRectMake(0, ScreenH-ScreenW, ScreenW, ScreenW);
    }
    return self;
}

- (JHClaimOrderListViewController *)claimVC {
    if (!_claimVC) {
        _claimVC = [[JHClaimOrderListViewController alloc] init];
        MJWeakSelf
        _claimVC.clickImage = ^(id sender) {
            if (weakSelf.clickImage) {
                weakSelf.clickImage(nil);
            }
        };
        _claimVC.isLiving = YES;
    }
    return _claimVC;
}


- (void)showAlert {
    CGRect rect = self.claimVC.view.frame;
    self.claimVC.view.mj_y = ScreenH;
    
    rect.origin.y = ScreenH - rect.size.height;
    
    [UIView animateWithDuration:0.25f animations:^{
        self.claimVC.view.frame = rect;
    }];
    
}



- (void)hiddenAlert {
    CGRect rect = self.claimVC.view.frame;
    rect.origin.y = ScreenH;
    [UIView animateWithDuration:0.25f animations:^{
        self.claimVC.view.frame = rect;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self hiddenAlert];
}

- (void)catchImage:(UIImage *)image {
    [self.claimVC catchImage:image];
}

- (BOOL)isAppraising {
    _isAppraising = self.claimVC.isApraising;
    return _isAppraising;
}
@end
