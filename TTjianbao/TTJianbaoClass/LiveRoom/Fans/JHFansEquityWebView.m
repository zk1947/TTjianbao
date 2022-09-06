//
//  JHFansEquityWebView.m
//  TTjianbao
//
//  Created by liuhai on 2021/3/27.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHFansEquityWebView.h"
#import "JHWebView.h"
#import "UIView+CornerRadius.h"

@interface JHFansEquityWebView ()
@property (nonatomic, strong)  UIButton* sureBtn;
@property(nonatomic,strong) UIView * bar;
@property(nonatomic,strong) UILabel * titleLabel;
@property(nonatomic,strong) UIView * topView;

@end

@implementation JHFansEquityWebView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:CGRectMake(0, 0 ,kScreenWidth , kScreenHeight)];
    if (self) {
        [self addTarget:self action:@selector(hiddenAlert) forControlEvents:UIControlEventTouchUpInside];
        _bar =  [[UIView alloc]init];
        _bar.backgroundColor= HEXCOLOR(0xFFFFFF);
        _bar.userInteractionEnabled = YES;
        _bar.layer.masksToBounds = YES;
        _bar.frame= CGRectMake(0, kScreenHeight - frame.size.height, ScreenW, frame.size.height);
        [_bar yd_setCornerRadius:12.f corners:UIRectCornerAllCorners];
        [self addSubview:_bar];

        self.topView =  [[UIView alloc] init];
        // topView.frame = CGRectMake(0,0,375,50);
        self.topView.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
        self.topView.layer.cornerRadius = 0;
        self.topView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.1].CGColor;
        self.topView.layer.shadowOffset = CGSizeMake(0,1);
        self.topView.layer.shadowOpacity = 1;
        self.topView.layer.shadowRadius = 5;
        [_bar addSubview:self.topView];
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo((_bar)).offset(0);
            make.left.right.equalTo(_bar);
            make.height.offset(50);

        }];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = kColor333;
        _titleLabel.text = @"粉丝团规则说明";
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:15.f];
        _titleLabel.numberOfLines = 1;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.topView addSubview:_titleLabel];

        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            //  make.top.equalTo((_bar)).offset(15);
            make.center.equalTo(self.topView);
        }];

        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setImage:[UIImage imageNamed:@"newStore_icon_back_black"] forState:UIControlStateNormal ];
        closeButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [closeButton addTarget:self action:@selector(hiddenAlert) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:closeButton];


        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleLabel);
            make.left.equalTo(self.topView).offset(0);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        JHWebView *webview = [[JHWebView alloc] init];
        [_bar addSubview:webview];
        [webview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(50);
            make.left.mas_equalTo(0);
            make.right.bottom.mas_equalTo(0);
//            make.height.mas_equalTo(400);
        }];
        [webview jh_loadWebURL:H5_BASE_STRING(@"/jianhuo/app/fensRule.html")];
        
        [_bar bringSubviewToFront:self.topView];
    }
    return self;
}
- (void)showAlert
{
    self.bar.top =  self.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.bar.bottom =  self.height;
    }];
}

-(void)hiddenAlert{
   [UIView animateWithDuration:0.25 animations:^{
        self.bar.top = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}
@end
