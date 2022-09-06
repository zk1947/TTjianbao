//
//  JHMallFollowHeader.m
//  TTjianbao
//
//  Created by jiang on 2020/4/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallFollowHeader.h"
@interface JHMallFollowHeader()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation JHMallFollowHeader


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configViews];
    }
    return self;
}

- (void)configViews {
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"我的关注";
    label.font = [UIFont fontWithName:kFontMedium size:15];
    [self addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.centerY.equalTo(self);
    }];
    
}

@end
