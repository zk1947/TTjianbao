//
//  JHChatEvaluationCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/7/14.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatEvaluationCell.h"
@interface JHChatEvaluationCell ()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation JHChatEvaluationCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutViews];
}
- (void)setupData {
    if (self.model == nil) return;
    self.icon.image = [UIImage imageNamed:self.model.icon];
    self.titleLabel.text = self.model.title;
    
    [[RACObserve(self.model, isSelected) takeUntil:self.rac_prepareForReuseSignal] subscribeNext:^(id  _Nullable x) {
        BOOL isSelected = [x boolValue];
        if (isSelected) {
            self.icon.image = [UIImage imageNamed:self.model.icon];
        }else {
            self.icon.image = [UIImage imageNamed:self.model.nonIcon];
        }
    }];
}
#pragma mark - UI
- (void)setupUI {
    [self addSubview:self.icon];
    [self addSubview:self.titleLabel];
}
- (void)layoutViews {
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.centerX.mas_equalTo(0);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
    }];
}

#pragma mark - LAZY
- (void)setModel:(JHChatEvaluationModel *)model {
    _model = model;
    [self setupData];
}
- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _icon;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.font = [UIFont fontWithName:kFontNormal size:14];
    }
    return _titleLabel;
}
@end
