//
//  JHBuyAppraiseTVBoxView.m
//  TTjianbao
//
//  Created by wangjianios on 2020/12/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBuyAppraiseTVBoxView.h"

@implementation JHBuyAppraiseTVBoxView

+ (instancetype)shareInstance {
    
    static dispatch_once_t onceToken;
    static JHBuyAppraiseTVBoxView *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [JHBuyAppraiseTVBoxView new];
    });
    return instance;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self jh_cornerRadius:5.f];
        [self addSelfSubViews];
    }
    return self;
}

- (void)addSelfSubViews
{
    _coverImageView = [UIImageView jh_imageViewAddToSuperview:self];
    [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _livingContentView = [UIView jh_viewWithColor:UIColor.clearColor addToSuperview:self];
    [_livingContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.coverImageView);
    }];
    
    UIView *tapView = [UIView jh_viewWithColor:UIColor.clearColor addToSuperview:self];
    [tapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.coverImageView);
    }];
    @weakify(self);
    [tapView jh_addTapGesture:^{
        @strongify(self);
        if(self.switchPlayBlock) {
            self.switchPlayBlock();
        }
    }];
    
    _playStatusView = [UIImageView jh_imageViewWithImage:@"icon_video_play" addToSuperview:self];
    [_playStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.livingContentView);
        make.size.mas_equalTo(CGSizeMake(43, 43));
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
