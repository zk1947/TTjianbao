//
//  JHRecycleSureButton.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/3/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleSureButton.h"

@interface JHRecycleSureButton()
@property(nonatomic, strong) CAGradientLayer * gradientLayer;
@end

@implementation JHRecycleSureButton

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self.layer addSublayer:self.gradientLayer];
        self.titleLabel.font = JHMediumFont(16);
        [self setTitleColor:HEXCOLOR(0x7A7353) forState:UIControlStateDisabled];
        [self setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        self.backgroundColor = HEXCOLOR(0xFFEF9F);
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    self.gradientLayer.hidden = !enabled;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.gradientLayer.frame = self.bounds;
}
- (CAGradientLayer *)gradientLayer {
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.frame = self.bounds;
        _gradientLayer.colors = @[(__bridge id)HEXCOLOR(0xFED73A).CGColor, (__bridge id)HEXCOLOR(0xFECB33).CGColor];
        _gradientLayer.locations = @[@0, @1];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(1, 0);
    }
    return _gradientLayer;
}


@end
