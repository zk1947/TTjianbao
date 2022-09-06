//
//  JHRecommendHeader.m
//  TTjianbao
//
//  Created by lihui on 2020/3/5.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRecommendHeader.h"
#import "TTjianbaoMarcoKeyword.h"
#import "TTJianBaoColor.h"

@interface JHRecommendHeader()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation JHRecommendHeader


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configViews];
    }
    return self;
}

- (void)setTitle:(NSString *)title {
    
    // jiang add
//    if (title) {
//        return;
//    }
    
    _title = title;
    _titleLabel.text = _title;
}

- (void)configViews {
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = HEXCOLOR(0xF5F6FA);
    
    UIImageView *leftLine = [[UIImageView alloc] init];
    //leftLine.backgroundColor = HEXCOLOR(0xE3E3E3);
    leftLine.contentMode = UIViewContentModeScaleAspectFit;
    leftLine.image = [UIImage imageNamed:@"left_line_follow"];
    
    UIImageView *rightLine = [[UIImageView alloc] init];
    //rightLine.backgroundColor = HEXCOLOR(0xE3E3E3);
    rightLine.contentMode = UIViewContentModeScaleAspectFit;
    rightLine.image = [UIImage imageNamed:@"right_line_follow"];

    UIImageView *loveImage = [[UIImageView alloc] init];
    loveImage.image = [UIImage imageNamed:@"red_heart"];
    loveImage.contentMode = UIViewContentModeScaleAspectFit;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = IS_OPEN_RECOMMEND ? @"为您推荐" : @"推荐";
    label.font = [UIFont fontWithName:kFontMedium size:16];
    label.textColor = BLACK_COLOR;
    _titleLabel = label;
    
    [self addSubview:view];
    [view addSubview:leftLine];
    [view addSubview:rightLine];
    [view addSubview:loveImage];
    [view addSubview:label];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.mas_equalTo(46);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(view);
        make.centerX.equalTo(view).offset(10);
    }];
    
    [loveImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(label.mas_left).offset(-5);
        make.height.mas_equalTo(15);
        make.width.mas_equalTo(18);
        make.centerY.equalTo(label);
    }];
    
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(loveImage.mas_left).offset(-10);
        make.height.mas_equalTo(3.5);
        make.width.mas_equalTo(29);
        make.centerY.equalTo(view);
    }];
    
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(10);
        make.height.mas_equalTo(3.5);
        make.width.mas_equalTo(29);
        make.centerY.equalTo(view);
    }];
}
@end
