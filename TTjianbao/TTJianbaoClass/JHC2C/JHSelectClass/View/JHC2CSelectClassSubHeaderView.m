//
//  JHC2CSelectClassSubHeaderView.m
//  TTjianbao
//
//  Created by hao on 2021/5/28.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CSelectClassSubHeaderView.h"

@interface JHC2CSelectClassSubHeaderView ()
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation JHC2CSelectClassSubHeaderView
@dynamic title;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_offset(15);
        make.centerY.equalTo(self);
    }];
}
- (void)setTitle:(NSString *)title{
    self.titleLabel.text = title;

}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _titleLabel.textColor = HEXCOLOR(0x333333);
    }
    return _titleLabel;
}

@end
