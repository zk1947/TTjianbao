//
//  JHDotButtonView.m
//  TTjianbao
//
//  Created by yaoyao on 2019/12/1.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHDotButtonView.h"

@implementation JHDotButtonView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.dotLabel = [JHDoteNumberLabel new];
        self.dotLabel.mj_h = 15;
        
        self.dotLabel.text = @"0";
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.button];
        [self.button setTitleColor:kColor333 forState:UIControlStateNormal];
        self.button.titleLabel.font = [UIFont fontWithName:kFontNormal size:15];
        self.button.titleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:self.dotLabel];

    }
    return self;
}

- (void)setType:(JHDotButtonType)type {

    _type = type;
    if (type == 1) {
        self.button.layer.cornerRadius = self.frame.size.height/2.;
        self.button.layer.masksToBounds = YES;
        self.button.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.dotLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(-5);
            make.trailing.offset(5);
            make.height.width.equalTo(@15);
        }];
        
        [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.leading.trailing.equalTo(self);
        }];
        self.button.backgroundColor = kGlobalThemeColor;
        [self bringSubviewToFront:self.dotLabel];
        
    }else if (type == 2){
        UIBezierPath *cornerRadiusPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerTopLeft cornerRadii:CGSizeMake(self.frame.size.height/2., self.frame.size.height/2.)];
        CAShapeLayer *cornerRadiusLayer = [[CAShapeLayer alloc] init];
        cornerRadiusLayer.frame = self.bounds;
        cornerRadiusLayer.path = cornerRadiusPath.CGPath;
        self.button.layer.mask = cornerRadiusLayer;
        
        [self.dotLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.leading.equalTo(self);
            make.height.width.equalTo(@15);
        }];
        
        [self.button mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.leading.trailing.equalTo(self);
        }];
        
        self.button.backgroundColor = HEXCOLORA(0x000000, 0.7);
        
    }else if (type == 0){
        self.dotLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        self.dotLabel.layer.borderWidth = 1;
        [self.dotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(3);
            make.top.equalTo(self).offset(-3);
            make.height.width.equalTo(@15);
        }];
        
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.leading.trailing.equalTo(self);
        }];
    }else if (type == 3){
        self.dotLabel.layer.borderColor = [UIColor whiteColor].CGColor;
        self.dotLabel.layer.borderWidth = 1;
        [self.dotLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.trailing.equalTo(self).offset(3);
            make.top.equalTo(self).offset(-3);
            make.height.width.equalTo(@15);
        }];
        
        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.leading.trailing.equalTo(self);
        }];
    }
    
}


- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    [super addTarget:target action:action forControlEvents:controlEvents];
    [self.button addTarget:target action:action forControlEvents:controlEvents];
}
@end
