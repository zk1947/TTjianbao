//
//  JHRushPurChaseButton.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/9/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRushPurChaseButton.h"

@interface JHRushPurChaseButton()
@property(nonatomic, strong) CAGradientLayer * gradLayer;
@end

@implementation JHRushPurChaseButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}


- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        self.titleLbl.font = JHBoldFont(20);
        self.bottomLbl.font = JHFont(14);
        self.titleLbl.textColor = UIColor.whiteColor;
        self.bottomLbl.textColor = UIColor.whiteColor;
        self.backgroundColor = HEXCOLOR(0xFF5200);
        [self.titleLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.top.mas_equalTo(6);
        }];
        
        [self.bottomLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.bottom.mas_equalTo(-8);
        }];

    }else{
        self.titleLbl.font = JHBoldFont(18);
        self.bottomLbl.font = JHFont(12);
        self.backgroundColor = UIColor.whiteColor;
        self.titleLbl.textColor = HEXCOLOR(0x333333);
        self.bottomLbl.textColor = HEXCOLOR(0x999999);
        [self.titleLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.top.mas_equalTo(5);
        }];
        
        [self.bottomLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.bottom.mas_equalTo(-5);
        }];

    }
    self.gradLayer.hidden = !selected;
}

- (void)setItems{
    self.layer.cornerRadius = 8;
    self.layer.masksToBounds = YES;
    self.backgroundColor = HEXCOLOR(0xffffff);
    [self addSubview:self.titleLbl];
    [self addSubview:self.bottomLbl];
    self.gradLayer = [self addGradualColor];
}


- (void)layoutItems{
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.top.mas_equalTo(5);
    }];
    
    [self.bottomLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.bottom.mas_equalTo(-5);
    }];
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        UILabel *label = [UILabel new];
        label.font = JHBoldFont(18);
        label.textColor = HEXCOLOR(0x333333);
        label.text = @"11:00";
        _titleLbl = label;
    }
    return _titleLbl;
}
- (UILabel *)bottomLbl{
    if (!_bottomLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(12);
        label.textColor = HEXCOLOR(0x999999);
        label.text = @"抢购中";
        _bottomLbl = label;
    }
    return _bottomLbl;
}
- (CAGradientLayer*)addGradualColor{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)HEXCOLOR(0xFF8C00).CGColor, (__bridge id)HEXCOLOR(0xFF5200).CGColor];
    gradientLayer.locations = @[@0, @1];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 1.0);
    gradientLayer.frame = self.bounds;
    [self.layer insertSublayer:gradientLayer atIndex:0];
    self.gradLayer.hidden = YES;
    return gradientLayer;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.gradLayer.frame = self.bounds;
}
@end
