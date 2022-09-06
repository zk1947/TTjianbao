//
//  JHBottomAnimationView.m
//  TTjianbao
//
//  Created by wangjianios on 2020/7/8.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBottomAnimationView.h"

@implementation JHBottomAnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _bottomAnimationView = [UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:self];
        [_bottomAnimationView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
        }];

    }
    return self;
}

- (void)setBottomAnimationViewHeight:(CGFloat)bottomAnimationViewHeight
{
    _bottomAnimationViewHeight = bottomAnimationViewHeight;
    
    [_bottomAnimationView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(self.bottomAnimationViewHeight);
        make.height.mas_equalTo(_bottomAnimationViewHeight);
    }];
}

- (void)show
{
    if(_bottomAnimationViewHeight != 0)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.15 animations:^{
                [_bottomAnimationView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.bottom.equalTo(self);
                }];
                [self layoutIfNeeded];
            }];
        });
    }
}

- (void)dissmiss
{
    if(_bottomAnimationViewHeight != 0)
    {
        [UIView animateWithDuration:0.15 animations:^{
            [_bottomAnimationView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self).offset(self.bottomAnimationViewHeight);
            }];
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }
    else
    {
        [self removeFromSuperview];
    }
}


@end
