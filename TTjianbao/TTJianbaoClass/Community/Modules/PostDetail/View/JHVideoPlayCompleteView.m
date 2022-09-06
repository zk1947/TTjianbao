//
//  JHVideoPlayCompleteView.m
//  TTjianbao
//
//  Created by wangjianios on 2020/11/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHVideoPlayCompleteView.h"

@interface JHVideoPlayCompleteView ()

@property (nonatomic, assign) UIView *bgView;

@end

@implementation JHVideoPlayCompleteView

-(void)dealloc {
    NSLog(@"🔥");
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXCOLORA(0x000000, 0.5);
        [self addSelfSubViews];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTouchAction)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)viewTouchAction {
    // 屏幕点击事件,防止显示图点击事件穿透.
}

- (void)addSelfSubViews {

    UIView *bgView = [UIView jh_viewWithColor:UIColor.clearColor addToSuperview:self];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo([JHVideoPlayCompleteView viewSize]);
    }];
    _bgView = bgView;
    
    UILabel *tipLabel = [UILabel jh_labelWithText:@"分享到" font:12 textColor:UIColor.whiteColor textAlignment:1 addToSuperView:bgView];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(bgView);
    }];
    
    ///左线
    [[UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:bgView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32, 1));
        make.centerY.equalTo(tipLabel);
        make.right.equalTo(tipLabel.mas_left).offset(-8);
    }];
    
    ///右线
    [[UIView jh_viewWithColor:UIColor.whiteColor addToSuperview:bgView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(32, 1));
        make.centerY.equalTo(tipLabel);
        make.left.equalTo(tipLabel.mas_right).offset(8);
    }];
    
    UIButton *wechatButton = [UIButton jh_buttonWithImage:@"operation_weixin_icon" target:self action:@selector(weChatShare) addToSuperView:bgView];
    [wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_centerX).offset(-25);
        make.size.mas_equalTo(CGSizeMake(43, 43));
        make.top.equalTo(tipLabel.mas_bottom).offset(20);
    }];
    [[UILabel jh_labelWithText:@"微信" font:12 textColor:UIColor.whiteColor textAlignment:1 addToSuperView:bgView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(wechatButton);
        make.top.equalTo(wechatButton.mas_bottom).offset(10);
    }];
    
    UIButton *timeLineButton = [UIButton jh_buttonWithImage:@"operation_quan_icon" target:self action:@selector(weChatTimeLineShare) addToSuperView:bgView];
    [timeLineButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_centerX).offset(25);
        make.top.height.width.equalTo(wechatButton);
    }];
    [[UILabel jh_labelWithText:@"朋友圈" font:12 textColor:UIColor.whiteColor textAlignment:1 addToSuperView:bgView] mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(timeLineButton);
        make.top.equalTo(timeLineButton.mas_bottom).offset(10);
    }];
    
    UIButton *rePlayButton = [UIButton jh_buttonWithImage:@"common_reset_white" target:self action:@selector(rePlayButton) addToSuperView:bgView];
    rePlayButton.jh_fontNum(14).jh_titleColor(UIColor.whiteColor).jh_title(@" 重播");
    [rePlayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 20));
        make.bottom.centerX.equalTo(bgView);
    }];
}

- (void)weChatShare {
    if(_clickActionBlock)
    {
        _clickActionBlock(1);
    }
}

- (void)weChatTimeLineShare {
    if(_clickActionBlock)
    {
        _clickActionBlock(2);
    }
}
- (void)rePlayButton {
    if(_clickActionBlock)
    {
        _clickActionBlock(3);
    }
}

+ (CGSize)viewSize {
    return CGSizeMake(150, 142);
}

- (void)setEdgeTop:(CGFloat)edgeTop {
    [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(edgeTop / 2.f);
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
