//
//  JHOperationViewHeader.m
//  TTjianbao
//
//  Created by jiangchao on 2020/6/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "JHOperationViewHeader.h"


@interface JHOperationViewHeader()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation JHOperationViewHeader


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configViews];
    }
    return self;
}
- (void)configViews {
    
    UIView *view = [[UIView alloc] init];
    //view.backgroundColor = [UIColor redColor];
    
    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = HEXCOLOR(0xE3E3E3);
    
    UIView *rightLine = [[UIView alloc] init];
    rightLine.backgroundColor = HEXCOLOR(0xE3E3E3);

    UILabel *label = [[UILabel alloc] init];
    label.text = @"版主操作区，请勿滥用权限";
    label.textColor = HEXCOLOR(0x999999);
    label.font = [UIFont fontWithName:kFontNormal size:12];
    _titleLabel = label;
    
    [self addSubview:view];
    [view addSubview:leftLine];
    [view addSubview:rightLine];
    [view addSubview:label];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.leading.trailing.equalTo(self);
        make.height.mas_equalTo(self);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(view);
        make.centerX.equalTo(view);
    }];
    
    [leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(label.mas_left).offset(-25);
        make.height.mas_equalTo(.5);
        make.left.offset(15);
        make.centerY.equalTo(label);
    }];
    
    [rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label.mas_right).offset(15);
        make.height.mas_equalTo(.5);
        make.right.offset(-15);
        make.centerY.equalTo(label);
    }];
}
@end

