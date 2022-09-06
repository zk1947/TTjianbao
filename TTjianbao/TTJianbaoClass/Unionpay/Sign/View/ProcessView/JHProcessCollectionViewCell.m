//
//  JHProcessCollectionViewCell.m
//  TTjianbao
//
//  Created by lihui on 2020/4/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHProcessCollectionViewCell.h"
#import "JHUnionPayModel.h"
#import "UIView+JHShadow.h"

@interface JHProcessCollectionViewCell ()

@property (nonatomic, strong) UILabel *circleProcessLabel;
@property (nonatomic, strong) UILabel *processLabel;
@property (nonatomic, strong) UIView *leftLine;
@property (nonatomic, strong) UIView *rightLine;

@end

@implementation JHProcessCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)setProcessModel:(JHProcessModel *)processModel {
    if (!processModel) {
        return;
    }
    
    _processModel = processModel;
    _processLabel.text = _processModel.title;
    _leftLine.backgroundColor = _processModel.leftlineColor;
    _rightLine.backgroundColor = _processModel.rightlineColor;
    
    if (_processModel.isFinished) { ///已完成UI
        _circleProcessLabel.backgroundColor = HEXCOLOR(0xFFEE00);
        _circleProcessLabel.layer.borderColor = [[UIColor whiteColor] CGColor];
        _circleProcessLabel.layer.borderWidth = 0.1f;
        _circleProcessLabel.text = _processModel.index.stringValue;
        _processLabel.textColor = HEXCOLOR(0x333333);
    }
    else {  ///未完成UI
        _circleProcessLabel.layer.borderColor = [HEXCOLOR(0xE3E3E3) CGColor];
        _circleProcessLabel.layer.borderWidth = 15/2.f;
        _circleProcessLabel.text = @"";
        _processLabel.textColor = HEXCOLOR(0x999999);
    }
    
    if (!_processModel.showLeftLine) {
        _leftLine.hidden = YES;
        [_circleProcessLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_left).offset(self.circleProcessLabel.width);
        }];
    }
    if (!_processModel.showRightLine) {
        _rightLine.hidden = YES;
        [_circleProcessLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_right).offset(-self.circleProcessLabel.width);
        }];
    }
    
    [self layoutIfNeeded];
}

- (void)initViews {
    _circleProcessLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _circleProcessLabel.textAlignment = NSTextAlignmentCenter;
    _circleProcessLabel.font = [UIFont fontWithName:kFontMedium size:12];
    _circleProcessLabel.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_circleProcessLabel];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"";
    titleLabel.font = [UIFont fontWithName:kFontNormal size:11];
    titleLabel.textColor = HEXCOLOR(0x999999);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    _processLabel = titleLabel;
    [self.contentView addSubview:_processLabel];
    
    UIView *leftLine = [[UIView alloc] init];
    leftLine.backgroundColor = HEXCOLOR(0xE3E3E3);
    [self.contentView addSubview:leftLine];
    _leftLine = leftLine;
    
    UIView *rightLine = [[UIView alloc] init];
    rightLine.backgroundColor = HEXCOLOR(0xE3E3E3);
    [self.contentView addSubview:rightLine];
    _rightLine = rightLine;
    
    [_circleProcessLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(self.contentView).offset(12);
        make.size.mas_equalTo(CGSizeMake(25, 25));
    }];
    
    [_processLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.circleProcessLabel.mas_bottom).offset(4);
        make.centerX.equalTo(self.circleProcessLabel);
    }];

    //左侧线条
    [_leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.circleProcessLabel.mas_left);
        make.centerY.equalTo(self.circleProcessLabel);
        make.height.mas_equalTo(1);
    }];
    
    ///右侧线条
    [_rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.circleProcessLabel.mas_right);
        make.right.equalTo(self.contentView);
        make.centerY.equalTo(self.leftLine);
        make.height.equalTo(self.leftLine);
    }];

    [_circleProcessLabel layoutIfNeeded];
    _circleProcessLabel.layer.cornerRadius = _circleProcessLabel.height/2;
    _circleProcessLabel.clipsToBounds = YES;
    _circleProcessLabel.layer.borderColor = [HEXCOLOR(0xE3E3E3) CGColor];
    _circleProcessLabel.layer.borderWidth = 15/2.f;
    
}


@end
