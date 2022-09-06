//
//  JHZanHUD.m
//  TTjianbao
//
//  Created by wuyd on 2019/9/24.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHZanHUD.h"
#import <SDAutoLayout/SDAutoLayout.h>


@interface JHZanHUD ()
@property (nonatomic, strong) UIView *contentView;
@end

@implementation JHZanHUD

+ (void)showText:(NSString *)text {
    JHZanHUD *hud = [[JHZanHUD alloc] initWithFrame:[UIScreen mainScreen].bounds text:text];
    [hud show];
}

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [self addGestureRecognizer:tap];
        
        CGFloat contentH = 300.0;
        
        _contentView = [UIView new];
        _contentView.frame = CGRectMake(0, 0, contentH, contentH);
        _contentView.centerY = self.centerY;
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 4.0;
        _contentView.layer.masksToBounds = YES;
        UITapGestureRecognizer *tapContent = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [_contentView addGestureRecognizer:tapContent];
        //_contentView.userInteractionEnabled = NO;
        
        //1.
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hud_icon_zan_header_bg"]];
        [_contentView addSubview:imgView];
        
        //2.
        UILabel *msgLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:13] textColor:kColor333];
        msgLabel.top = CGRectGetMaxY(imgView.frame);
        msgLabel.left = 45.0;
        msgLabel.size = CGSizeMake(ScreenWidth-45*2, contentH - imgView.height - 50.0);
        msgLabel.textAlignment = NSTextAlignmentCenter;
        msgLabel.text = text;
        msgLabel.numberOfLines = 0;
        [_contentView addSubview:msgLabel];
        
        //button
        CGFloat btnH = 50;
        
        UIButton *okBtn = [UIButton buttonWithTitle:@"确认" titleColor:kColor333];
        okBtn.left = 0;
        okBtn.bottom = _contentView.bottom;
        okBtn.size = CGSizeMake(contentH, btnH);
        [_contentView addSubview:okBtn];
        @weakify(self);
        [[okBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self hide];
        }];

        UIView *btnTopLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentH, 0.5)];
        btnTopLine.backgroundColor = kColorEEE;
        [okBtn addSubview:btnTopLine];
        
        //布局
        imgView.sd_layout
        .leftEqualToView(_contentView)
        .rightEqualToView(_contentView)
        .topEqualToView(_contentView)
        .heightIs(153.0);
        
        okBtn.sd_layout
        .leftEqualToView(_contentView)
        .rightEqualToView(_contentView)
        .bottomEqualToView(_contentView)
        .heightIs(50.0);
        
        btnTopLine.sd_layout
        .topEqualToView(okBtn)
        .leftEqualToView(okBtn)
        .rightEqualToView(okBtn)
        .heightIs(0.5);
        
        msgLabel.sd_layout
        .leftEqualToView(_contentView)
        .rightEqualToView(_contentView)
        .topSpaceToView(imgView, 0)
        .bottomSpaceToView(okBtn, 0);
    }
    return self;
}


- (void)show {
    @synchronized (self) {
        self.alpha = 0;
        _contentView.alpha = 0;
        [JHKeyWindow addSubview:self];
        [JHKeyWindow addSubview:_contentView];
        _contentView.sd_layout
        .leftSpaceToView(JHKeyWindow, (ScreenWidth-300)/2)
        .rightSpaceToView(JHKeyWindow, (ScreenWidth-300)/2)
        .centerYEqualToView(JHKeyWindow).offset(-20);
        
        [UIView animateWithDuration:0.25 animations:^{
            self.alpha = 1.0;
            _contentView.alpha = 1.0;
        }];
    }
}

- (void)hide {
    @synchronized (self) {
        [UIView animateWithDuration:0.25 animations:^{
            //self.transform = CGAffineTransformMakeScale(0.1, 0.1);
            self.alpha = 0;
            _contentView.alpha = 0;
        } completion:^(BOOL finished) {
            if (finished) {
                [self removeFromSuperview];
                [_contentView removeFromSuperview];
            }
        }];
    }
}

- (void)dealloc {
    _contentView = nil;
    DDLogDebug(@"JHUserTitleUpHUD::dealloc");
}

@end
