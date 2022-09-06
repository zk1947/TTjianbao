//
//  JHAuthAlertView.m
//  TTjianbao
//
//  Created by lihui on 2021/3/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHAuthAlertView.h"
#import "UIView+JHGradient.h"
#import <SDAutoLayout/SDAutoLayout.h>

@interface JHAuthAlertView ()
@property (nonatomic, strong) UIView *contentView;
@end

@implementation JHAuthAlertView

+ (void)showText:(NSString *)text {
    JHAuthAlertView *alert = [[JHAuthAlertView alloc] initWithFrame:[UIScreen mainScreen].bounds text:text];
    [alert show];
}

- (instancetype)initWithFrame:(CGRect)frame text:(NSString *)text {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
//        [self addGestureRecognizer:tap];
        
        CGFloat contentW = 260.f;
        CGFloat contentH = 269.f;

        _contentView = [[UIView alloc] init];
        _contentView.frame = CGRectMake(0, 0, contentW, contentH);
        _contentView.centerY = self.centerY;
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.cornerRadius = 8.0;
        _contentView.layer.masksToBounds = YES;
        UITapGestureRecognizer *tapContent = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
        [_contentView addGestureRecognizer:tapContent];

        //1.
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_bg_auth_personal"]];
        [_contentView addSubview:imgView];
        
        //确定
        UIButton *sureButton = [UIButton buttonWithTitle:@"确定" titleColor:kColor333];
        sureButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:15.];
        sureButton.layer.cornerRadius = 20.f;
        sureButton.layer.masksToBounds = YES;
        [_contentView addSubview:sureButton];
        @weakify(self);
        [[sureButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self hide];
        }];

        //展示文字部分
        UILabel *msgLabel = [UILabel labelWithFont:[UIFont fontWithName:kFontNormal size:13] textColor:kColor333];
        msgLabel.text = text;
        msgLabel.numberOfLines = 0;
        msgLabel.textAlignment = NSTextAlignmentCenter;
        [_contentView addSubview:msgLabel];

        //布局
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.contentView);
            make.height.mas_equalTo(130.f);
        }];

        [sureButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(30);
            make.right.equalTo(self.contentView).offset(-30);
            make.bottom.equalTo(self.contentView).offset(-20);
            make.height.mas_equalTo(40.);
        }];

        [msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(22);
            make.right.equalTo(self.contentView).offset(-22);
            make.bottom.equalTo(sureButton.mas_top).offset(-20.f);
            make.top.equalTo(imgView.mas_bottom).offset(19.f);
        }];
        
        [sureButton layoutIfNeeded];
        [sureButton jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFED73A), HEXCOLOR(0xFECB33)] locations:@[@0, @1] startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    }
    return self;
}

- (void)show {
    @synchronized (self) {
        self.alpha = 0;
        _contentView.alpha = 0;
        [JHKeyWindow addSubview:self];
        [JHKeyWindow addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(JHKeyWindow);
            make.centerY.equalTo(JHKeyWindow).offset(-20);
            make.size.mas_equalTo(CGSizeMake(260., 269.f));
        }];
        
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
