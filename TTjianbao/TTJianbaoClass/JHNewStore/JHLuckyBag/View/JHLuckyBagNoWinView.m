//
//  JHLuckyBagNoWinView.m
//  TTjianbao
//
//  Created by zk on 2021/11/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHLuckyBagNoWinView.h"

@interface JHLuckyBagNoWinView ()

@property(nonatomic,strong) UIButton *maskView;//遮罩
@property(nonatomic,strong) UIButton *closeBtn;//关闭按钮
@property(nonatomic,strong) UILabel *titLab;//
@property(nonatomic,strong) UILabel *conLab;//
@property(nonatomic,strong) UIImageView *imgv;//
@property(nonatomic,strong) UIButton *submitBtn;//

@end

@implementation JHLuckyBagNoWinView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    
    self.backgroundColor = [UIColor whiteColor];
    [self jh_cornerRadius:8];
    self.frame = CGRectMake(0, 0, 260, 246);
    self.center = [UIApplication sharedApplication].keyWindow.center;
    
    [self addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(5);
        make.width.height.mas_equalTo(30);
    }];
    
    [self addSubview:self.titLab];
    [self.titLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(26);
        make.height.mas_equalTo(21);
    }];
    
    [self addSubview:self.imgv];
    [self.imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(self.titLab.mas_bottom).offset(18);
        make.width.mas_equalTo(89);
        make.height.mas_equalTo(71);
    }];
    
    [self addSubview:self.conLab];
    [self.conLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(self.imgv.mas_bottom).offset(13);
        make.width.height.mas_equalTo(21);
    }];
    
    [self addSubview:self.submitBtn];
}

- (void)show{
    [[JHRootController currentViewController].view addSubview:self.maskView];
    [[JHRootController currentViewController].view addSubview:self];
}

- (void)remove{
    [_maskView removeFromSuperview];
    [self removeFromSuperview];
}

#pragma mark - Lazy load Methods：

- (UIButton *)maskView{
    if (!_maskView) {
        UIButton *maskView = [UIButton buttonWithType:UIButtonTypeCustom];
        maskView.frame = [UIScreen mainScreen].bounds;
        maskView.alpha = 0.5;
        maskView.backgroundColor = [UIColor blackColor];
        _maskView = maskView;
    }
    return _maskView;
}

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [closeBtn setImage:JHImageNamed(@"appraisepaycopon_close") forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn = closeBtn;
    }
    return _closeBtn;
}

- (UILabel *)titLab{
    if (!_titLab) {
        UILabel *titLab = [UILabel new];
        titLab.text = @"很遗憾";
        titLab.textColor= kColor333;
        titLab.font = JHMediumFont(15);
        titLab.textAlignment = NSTextAlignmentCenter;
        _titLab = titLab;
    }
    return _titLab;
}

- (UILabel *)conLab{
    if (!_conLab) {
        UILabel *conLab = [UILabel new];
        conLab.text = @"您未抽中本轮福袋";
        conLab.textColor= kColor333;
        conLab.font = JHFont(14);
        conLab.textAlignment = NSTextAlignmentCenter;
        _conLab = conLab;
    }
    return _conLab;
}

- (UIImageView *)imgv{
    if (!_imgv) {
        UIImageView *imgv = [UIImageView new];
        imgv.image = JHImageNamed(@"img_default_page");
        _imgv = imgv;
    }
    return _imgv;
}

- (UIButton *)submitBtn{
    if (!_submitBtn) {
        UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        submitBtn.frame = CGRectMake(25, self.height-60, self.width-50, 40);
        [self addGradualColor2:submitBtn];
        [submitBtn jh_cornerRadius:20];
        [submitBtn setTitle:@"我知道了" forState:UIControlStateNormal];
        [submitBtn setTitleColor:kColor333 forState:UIControlStateNormal];
        submitBtn.titleLabel.font = JHMediumFont(15);
        [submitBtn addTarget:self action:@selector(remove) forControlEvents:UIControlEventTouchUpInside];
        _submitBtn = submitBtn;
    }
    return _submitBtn;
}

- (void)addGradualColor2:(UIView *)view{
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.colors = @[(__bridge id)HEXCOLOR(0xFEE100).CGColor, (__bridge id)HEXCOLOR(0xFFC242).CGColor];
    gradientLayer2.startPoint = CGPointMake(0, 0);
    gradientLayer2.endPoint = CGPointMake(1.0, 0.0);
    gradientLayer2.frame = view.bounds;
    [view.layer addSublayer:gradientLayer2];
}

@end
