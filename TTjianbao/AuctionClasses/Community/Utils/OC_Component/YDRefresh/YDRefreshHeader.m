//
//  YDRefreshHeader.m
//  Cooking-Home
//
//  Created by Wuyd on 2019/7/7.
//  Copyright © 2019 Wuyd. All rights reserved.
//

#import "YDRefreshHeader.h"

@interface YDRefreshHeader ()

@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;

@end


@implementation YDRefreshHeader

#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare {
    [super prepare];
    
    self.automaticallyChangeAlpha = YES;
    
    // 设置控件的高度
    self.mj_h = 60;
    
    _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"refresh_arrow"]];
    _arrowView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:_arrowView];
    
    // loading
    _loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:_loadingView];
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews {
    [super placeSubviews];
    
    _arrowView.bounds = CGRectMake(0, 0, 25, 25);
    _arrowView.center = CGPointMake(self.mj_w/2, self.mj_h/2 - 5);
    _loadingView.center = CGPointMake(self.mj_w/2, self.mj_h/2);
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change {
    [super scrollViewContentOffsetDidChange:change];
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change {
    [super scrollViewContentSizeDidChange:change];
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change {
    [super scrollViewPanStateDidChange:change];
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState;
    
    if (state == MJRefreshStateIdle) { //普通闲置状态
        if (oldState == MJRefreshStateRefreshing) {
            self.arrowView.transform = CGAffineTransformIdentity;
            
            [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                self.loadingView.alpha = 0.0;
            } completion:^(BOOL finished) {
                // 如果执行完动画发现不是idle状态，就直接返回，进入其他状态
                if (self.state != MJRefreshStateIdle) return;
                self.loadingView.alpha = 1.0;
                [self.loadingView stopAnimating];
                self.arrowView.hidden = NO;
            }];
            
        } else {
            [self.loadingView stopAnimating];
            self.arrowView.hidden = NO;
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                self.arrowView.transform = CGAffineTransformIdentity;
            }];
        }
        
    } else if (state == MJRefreshStatePulling) { //松开就可以进行刷新的状态
        self.arrowView.hidden = NO;
        [self.loadingView stopAnimating];
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
            self.arrowView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
        
    } else if (state == MJRefreshStateRefreshing) { //正在刷新中的状态
        self.arrowView.hidden = YES;
        self.loadingView.alpha = 1;
        [self.loadingView startAnimating];
        
    }
}

#pragma mark 监听拖拽比例（控件被拖出来的比例）
- (void)setPullingPercent:(CGFloat)pullingPercent {
    [super setPullingPercent:pullingPercent];
}

@end
