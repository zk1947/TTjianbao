//
//  JHCustomizeApplyProcessBaseView.m
//  TTjianbao
//
//  Created by apple on 2020/11/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeApplyProcessBaseView.h"
#import "TTjianbaoHeader.h"
#import "UIImage+JHColor.h"
#import "UIView+CornerRadius.h"
#import "UIView+JHGradient.h"
#import "UIView+Toast.h"

@interface JHCustomizeApplyProcessBaseView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong)  UIButton* backBtn;

@end

@implementation JHCustomizeApplyProcessBaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(cancelClick:) forControlEvents:UIControlEventTouchUpInside];
        _bar =  [[UIView alloc]init];
        _bar.backgroundColor= [CommHelp toUIColorByStr:@"#ffffff"];
        _bar.userInteractionEnabled = YES;
        _bar.layer.masksToBounds = YES;
        _bar.frame= CGRectMake(0, 0, ScreenW, 362);
        [_bar yd_setCornerRadius:8.f corners:UIRectCornerAllCorners];
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
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:15.f];
        _titleLabel.numberOfLines = 1;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.topView addSubview:_titleLabel];

        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            //  make.top.equalTo((_bar)).offset(15);
            make.center.equalTo(self.topView);
        }];

        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeButton setImage:[UIImage imageNamed:@"new_appraisal_close"] forState:UIControlStateNormal ];
        closeButton.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [closeButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
        [self.topView addSubview:closeButton];

        [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_titleLabel);
            make.right.equalTo(self.topView).offset(-5);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];

        [_bar bringSubviewToFront:self.topView];
    }
    return self;
}
- (void)creatBottomBtn:(NSInteger)btnNum{
    _sureBtn=[[UIButton alloc]init];
    [_sureBtn setTitle:@"下一步" forState:UIControlStateNormal];
    _sureBtn.titleLabel.font = JHFont(15);
    [_sureBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [_sureBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    _sureBtn.layer.cornerRadius = 22;
    _sureBtn.clipsToBounds = YES;
    [_sureBtn addTarget:self action:@selector(nextClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bar addSubview:_sureBtn];
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_bar);
        make.bottom.mas_equalTo(_bar).offset(-(10+UI.bottomSafeAreaHeight));
        make.size.mas_equalTo(CGSizeMake(320, 44));
    }];
    if (btnNum == 2) {
        _backBtn = [[UIButton alloc]init];
        [_backBtn setTitle:@"上一步" forState:UIControlStateNormal];
        _backBtn.titleLabel.font = JHFont(15);
        [_backBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        _backBtn.layer.borderColor = HEXCOLOR(0xBDBFC2).CGColor;
        _backBtn.layer.borderWidth = 0.5;
        _backBtn.layer.cornerRadius = 22;
        _backBtn.clipsToBounds = YES;
        [_backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bar addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(_bar).offset(-(10+UI.bottomSafeAreaHeight));
            make.size.mas_equalTo(CGSizeMake(160, 44));
            make.left.mas_equalTo((self.width-330)/2);
        }];
        [_sureBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_backBtn.mas_right).offset(10);
            make.bottom.mas_equalTo(_bar).offset(-(10+UI.bottomSafeAreaHeight));
            make.size.mas_equalTo(CGSizeMake(160, 44));
        }];
    }
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = HEXCOLOR(0xF5F6FA);
    [_bar addSubview:line];
    [line mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.sureBtn.mas_top).offset(-9);
        make.height.mas_equalTo(1);
    }];
}
- (void)close
{
    [self hiddenAlert];
}

-(void)nextClick:(UIButton *)sender{

}
-(void)backClick:(UIButton *)sender{

    [self popAlertView];
}
- (void)showAlert
{
    self.bar.top =  self.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.bar.bottom =  self.height;
    }];
}

- (void)hiddenAlert{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CustomizeApplyProcessFirstRemove" object:nil];
}
- (void)cancelClick:(UIButton *)sender{
    [self hiddenAlert];
}
- (void)pushAlertView{
    self.bar.bottom =  self.height;
    self.left =  self.width;
    [UIView animateWithDuration:0.5 animations:^{
        self.left =  0;
    }];
}
- (void)popAlertView{
    [UIView animateWithDuration:0.5 animations:^{
         self.left = self.width;
     } completion:^(BOOL finished) {
//         [self removeFromSuperview];
     }];
}
- (void)dealloc{
}

@end
