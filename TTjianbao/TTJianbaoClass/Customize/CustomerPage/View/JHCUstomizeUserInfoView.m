//
//  JHCUstomizeUserInfoView.m
//  TTjianbao
//
//  Created by user on 2020/12/6.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCUstomizeUserInfoView.h"
#import "TTjianbaoMarcoUI.h"

@interface JHCUstomizeUserInfoView ()
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UILabel *detailCountLabel;
@end

@implementation JHCUstomizeUserInfoView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _detailLabel = [[UILabel alloc] init];
    _detailLabel.text = @"";
    _detailLabel.textColor = kColor999;
    _detailLabel.textAlignment = NSTextAlignmentCenter;
    _detailLabel.font = [UIFont fontWithName:kFontNormal size:12];
    [self addSubview:_detailLabel];
    
    _detailCountLabel = [[UILabel alloc] init];
    _detailCountLabel.text = @"0";
    _detailCountLabel.textColor = kColor333;
    _detailCountLabel.textAlignment = NSTextAlignmentCenter;
    _detailCountLabel.font = [UIFont fontWithName:kFontBoldDIN size:18];
    [self addSubview:_detailCountLabel];
    
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self);
    }];
    
    [_detailCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.centerX.equalTo(self.detailLabel);
        make.bottom.equalTo(self.detailLabel.mas_top);
    }];
}

- (void)setTitle:(NSString *)title value:(NSString *)value {
    if (title) {
        _detailLabel.text = title;
    }
    if (value) {
        _detailCountLabel.text = value;
    }
}

- (void)setTitle:(NSString *)title {
    if (!title) {
        return;
    }
    _title = title;
    _detailLabel.text = _title;
}

- (void)setValue:(NSString *)value {
    if (!value) {
        return;
    }
    _value = value;
    _detailCountLabel.text = value;
}


@end



