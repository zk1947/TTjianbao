//
//  JHLikeButton.m
//  TTjianbao
//
//  Created by lihui on 2020/9/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLikeButton.h"
#import "TTjianbaoMarcoUI.h"

@interface JHLikeButton ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation JHLikeButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    _textLabel.text = title;
}

- (void)setSelected:(BOOL)selected {
    if (selected) {
        _iconImageView.image = [UIImage imageNamed:@"sq_toolbar_icon_like_selected"];
//        [self zanAnimation];
    }
    else {
        _iconImageView.image = [UIImage imageNamed:@"sq_toolbar_icon_like_normal"];
    }
}

- (void)initViews {
    UIImageView *icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sq_toolbar_icon_like_normal"]];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:icon];
    _iconImageView = icon;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"赞";
    label.textColor = kColor333;
    label.font = [UIFont fontWithName:kFontNormal size:11];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    _textLabel = label;

    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.mas_equalTo(15);
    }];
    
    [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.leading.trailing.equalTo(self);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(5);
    }];
}



-(void)zanAnimation {
    CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    k.values = @[@(0.1),@(1.0),@(1.5)];
    k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
    k.calculationMode = kCAAnimationLinear;
    [self.iconImageView.layer addAnimation:k forKey:@"show"];
}


@end
