//
//  JHCheckingView.m
//  TTjianbao
//
//  Created by lihui on 2020/3/6.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCheckingView.h"

@interface JHCheckingView ()


@property (nonatomic, strong) UIImageView *redDotImage;

@end


@implementation JHCheckingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 15;
        self.layer.masksToBounds = YES;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    UIImageView *imageV = [[UIImageView alloc] init];
    imageV.image = [UIImage imageNamed:@"icon_person_sign"];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:imageV];
    
    UIImageView *redDot = [[UIImageView alloc] init];
    redDot.image = [UIImage imageNamed:@"icon_my_reddot"];
    redDot.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:redDot];
    redDot.hidden = YES;
    _redDotImage = redDot;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = JHLocalizedString(@"signInPolite");
    label.textColor = HEXCOLOR(0xFF4200);
    label.font = [UIFont fontWithName:kFontNormal size:11];
    [self addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-5-15);
        make.top.bottom.equalTo(self);
        make.centerY.equalTo(self);
    }];
    
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(label.mas_left).offset(-10);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(13, 12));
    }];
    
    [_redDotImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageV.mas_right);
        make.centerY.equalTo(imageV.mas_top);
        make.size.mas_equalTo(CGSizeMake(10, 10));
    }];
}

- (void)hiddenReddot:(BOOL)isHidden {
    _redDotImage.hidden = isHidden;
}

@end
