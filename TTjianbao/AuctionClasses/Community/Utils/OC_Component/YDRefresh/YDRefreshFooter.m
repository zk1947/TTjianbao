//
//  YDRefreshFooter.m
//  Cooking-Home
//
//  Created by Wuyd on 2019/7/16.
//  Copyright © 2019 Wuyd. All rights reserved.
//

#import "YDRefreshFooter.h"
#import <YYKit/YYKit.h>

static NSString *const JHLineString = @"——";
static NSString *const JHNoMoreString = @" 已经到底喽~ ";

@interface YDRefreshFooter()
@property (nonatomic, weak) UIActivityIndicatorView *loading;
@end


@implementation YDRefreshFooter

#pragma mark - 重写方法
#pragma mark - 在这里做一些初始化配置（比如添加子控件）

- (void)prepare {
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 50;
    
    //noMoreLabel
    UILabel *noMoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.mj_w, self.mj_h)];
    //noMoreLabel.backgroundColor = [UIColor clearColor];
    noMoreLabel.font = [UIFont fontWithName:kFontNormal size:12];
    noMoreLabel.textColor = [UIColor colorWithHexString:@"999999"];
    noMoreLabel.textAlignment = NSTextAlignmentCenter;
    noMoreLabel.text = @"";
    noMoreLabel.hidden = YES;
    [self addSubview:noMoreLabel];
    self.noMoreLabel = noMoreLabel;
    
    // loading
    UIActivityIndicatorView *loading = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [self addSubview:loading];
    self.loading = loading;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews {
    [super placeSubviews];
    self.noMoreLabel.frame = CGRectMake(0, 0, self.mj_w, self.mj_h);
    self.loading.center = CGPointMake(self.mj_w * 0.5, self.mj_h * 0.5);
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
    switch (state) {
        case MJRefreshStateIdle:
            [self.loading stopAnimating];
            self.noMoreLabel.hidden = YES;
            break;
        case MJRefreshStateRefreshing:
            [self.loading startAnimating];
            self.noMoreLabel.hidden = YES;
            break;
        case MJRefreshStateNoMoreData:
            [self.loading stopAnimating];
            self.noMoreLabel.hidden = NO;
            break;
        default:
            break;
    }
}

- (void)setShowNoMoreString:(BOOL)showNoMoreString {
    _showNoMoreString = showNoMoreString;
    if (showNoMoreString) {
        NSString *str = [NSString stringWithFormat:@"%@%@%@", JHLineString, JHNoMoreString, JHLineString];

        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:str];
        
        [attri addAttribute:NSFontAttributeName
                      value:[UIFont fontWithName:kFontNormal size:13]
                      range:NSMakeRange(0, attri.length)];
        
        [attri addAttribute:NSForegroundColorAttributeName
                      value:HEXCOLOR(0xBDBFC2)
                      range:NSMakeRange(0, JHLineString.length)];
        
        [attri addAttribute:NSForegroundColorAttributeName
                      value:HEXCOLOR(0xBDBFC2)
                      range:NSMakeRange(attri.length - JHLineString.length, JHLineString.length)];
        _noMoreLabel.attributedText = attri;
    } else {
        _noMoreLabel.text = @"";
    }
}

@end
