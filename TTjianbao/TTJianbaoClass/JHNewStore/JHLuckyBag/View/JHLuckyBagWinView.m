//
//  JHLuckyBagWinView.m
//  TTjianbao
//
//  Created by zk on 2021/11/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHLuckyBagWinView.h"

@interface JHLuckyBagWinView ()

@property(nonatomic,strong) UIButton *maskView;//遮罩
@property(nonatomic,strong) UIImageView *animationView;//
@property(nonatomic,strong) UIImageView *iconImgv;//
@property(nonatomic,strong) UIImageView *goldImgv;//
@property(nonatomic,strong) UIView *cardView;//
@property(nonatomic,strong) UIView *headView;//头部渐变
@property(nonatomic,strong) UIButton *closeBtn;//关闭按钮
@property(nonatomic,strong) UILabel *titLab;//
@property(nonatomic,strong) UILabel *priceLab;//
@property(nonatomic,strong) UILabel *conLab;//
@property(nonatomic,strong) UIImageView *imgv;//
@property(nonatomic,strong) UIButton *submitBtn;//
@property(nonatomic,strong) OrderMode *orderModel;

@end

@implementation JHLuckyBagWinView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView{
    
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, 0, 260, 570);
    self.center = CGPointMake(kScreenWidth/2, kScreenHeight/2);
    
    [self addSubview:self.animationView];
    [self.animationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(0);
        make.width.height.mas_equalTo(240);
    }];
    
    [self addSubview:self.iconImgv];
    [self.iconImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(63);
        make.width.height.mas_equalTo(75);
    }];
    
    [self addSubview:self.goldImgv];
    [self.goldImgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.iconImgv.mas_right).offset(-20);
        make.top.mas_equalTo(self.iconImgv.mas_top).offset(30);
        make.width.height.mas_equalTo(40);
    }];
    
    [self addSubview:self.cardView];
    [self.cardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(120);
        make.height.mas_equalTo(450);
    }];
    
    [self.cardView addSubview:self.headView];
    
    [self.cardView addSubview:self.closeBtn];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5);
        make.top.mas_equalTo(5);
        make.width.height.mas_equalTo(30);
    }];
    
    [self.cardView addSubview:self.titLab];
    [self.titLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(26);
        make.height.mas_equalTo(21);
    }];
    
    [self.cardView addSubview:self.imgv];
    [self.imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.cardView);
        make.top.mas_equalTo(self.titLab.mas_bottom).offset(10);
        make.width.height.mas_equalTo(240);
    }];
    
    [self addSubview:self.priceLab];
    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.top.mas_equalTo(self.imgv.mas_bottom).offset(11);
        make.height.mas_equalTo(28);
    }];
    
    [self addSubview:self.conLab];
    [self.conLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(self.priceLab.mas_bottom).offset(10);
    }];
    
    [self addSubview:self.submitBtn];
}

-(void)show:(OrderMode *)model{
    //刷新数据
    self.orderModel = model;
    [self.imgv jh_setImageWithUrl:model.goodsUrl placeHolder:@"newStore_detail_shopProduct_Placeholder"];
    NSString *priceString = [NSString stringWithFormat:@"￥%@",model.originOrderPrice];
    self.priceLab.text = priceString;
    [self changePercentFont:self.priceLab withFont:JHMediumFont(13)];
    self.conLab.text = model.goodsTitle;
    
    [[JHRootController currentViewController].view addSubview:self.maskView];
    [[JHRootController currentViewController].view addSubview:self];
    dispatch_async(dispatch_get_main_queue(), ^{
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        animation.fromValue = [NSNumber numberWithFloat:0.f];
        animation.toValue = [NSNumber numberWithFloat: M_PI *2];
        animation.duration = 3.5;
        animation.autoreverses = NO;
        animation.fillMode = kCAFillModeForwards;
        animation.repeatCount = MAXFLOAT;
        [self.animationView.layer addAnimation:animation forKey:nil];
    });
}

- (void)remove{
    [_maskView removeFromSuperview];
    [self removeFromSuperview];
}

-(void)changePercentFont:(UILabel *)lab withFont:(UIFont *)font{
    if (lab.text.length<=1||lab.text==nil) {
        return;
    }
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:lab.text];
    NSString *temp = nil;
    for(int i =0; i < attrStr.length; i++) {
        temp = [lab.text substringWithRange:NSMakeRange(i, 1)];
        if ([temp isEqualToString:@"￥"]) {
            [attrStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(i, 1)];
            lab.attributedText = attrStr;
        }
    }
}

- (void)submitBtnAction:(UIButton *)btn{
    if (self.payBlock) {
        self.payBlock(self.orderModel);
    }
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

- (UIImageView *)animationView{
    if (!_animationView) {
        UIImageView *animationView = [UIImageView new];
        animationView.image = JHImageNamed(@"luckybag_scroll_icon");
        _animationView = animationView;
    }
    return _animationView;
}

- (UIImageView *)iconImgv{
    if (!_iconImgv) {
        UIImageView *iconImgv = [UIImageView new];
        iconImgv.image = JHImageNamed(@"live_luckybag_icon");
        _iconImgv = iconImgv;
    }
    return _iconImgv;
}

- (UIImageView *)goldImgv{
    if (!_goldImgv) {
        UIImageView *goldImgv = [UIImageView new];
        goldImgv.image = JHImageNamed(@"lucky_gold_icon");
        _goldImgv = goldImgv;
    }
    return _goldImgv;
}

- (UIView *)cardView{
    if (!_cardView) {
        UIView *cardView = [UIView new];
        cardView.backgroundColor = [UIColor whiteColor];
        [cardView jh_cornerRadius:8];
        _cardView = cardView;
    }
    return _cardView;
}

- (UIView *)headView{
    if (!_headView) {
        UIView *headView = [UIView new];
        headView.frame = CGRectMake(0, 0, self.width, 55);
        [self addGradualColor:headView];
        _headView = headView;
    }
    return _headView;
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
        titLab.text = @"恭喜抽中福袋";
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
        conLab.text = @"店名031@宝友166711790";
        conLab.textColor= kColor333;
        conLab.font = JHMediumFont(13);
        conLab.numberOfLines = 0;
        _conLab = conLab;
    }
    return _conLab;
}

- (UILabel *)priceLab{
    if (!_priceLab) {
        UILabel *priceLab = [UILabel new];
        priceLab.text = @"￥0.00";
        priceLab.textColor= HEXCOLOR(0xFF4200);
        priceLab.font = [UIFont fontWithName:@"DIN Alternate" size:24];
        _priceLab = priceLab;
    }
    return _priceLab;
}

- (UIImageView *)imgv{
    if (!_imgv) {
        UIImageView *imgv = [UIImageView new];
        imgv.image = JHImageNamed(@"newStore_detail_shopProduct_Placeholder");
        imgv.contentMode = UIViewContentModeScaleAspectFill;
        imgv.clipsToBounds = YES;
        [imgv jh_cornerRadius:8];
        _imgv = imgv;
    }
    return _imgv;
}

- (UIButton *)submitBtn{
    if (!_submitBtn) {
        UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        submitBtn.frame = CGRectMake(10, self.height-53, self.width-20, 38);
        [self addGradualColor2:submitBtn];
        [submitBtn jh_cornerRadius:20];
        [submitBtn setTitle:@"去支付" forState:UIControlStateNormal];
        [submitBtn setTitleColor:kColor333 forState:UIControlStateNormal];
        submitBtn.titleLabel.font = JHMediumFont(15);
        [submitBtn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _submitBtn = submitBtn;
    }
    return _submitBtn;
}

- (void)addGradualColor:(UIView *)view{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)HEXCOLOR(0xFFF9D3).CGColor, (__bridge id)HEXCOLOR(0xFFFFFF).CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1.0);
    gradientLayer.frame = view.bounds;
    [view.layer addSublayer:gradientLayer];
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

