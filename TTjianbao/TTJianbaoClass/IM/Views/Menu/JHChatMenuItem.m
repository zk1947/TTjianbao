//
//  JHChatMenuItem.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatMenuItem.h"
@interface JHChatMenuItem()
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLabel;
@end
@implementation JHChatMenuItem
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
    self.icon.image = [UIImage imageNamed:self.model.iconName];
    self.titleLabel.text = self.model.title;
}
#pragma mark -UI
- (void)setupUI {
    [self addSubview:self.icon];
    [self addSubview:self.titleLabel];
}
- (void)layoutViews {
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
    }];
}
#pragma mark -LAZY
- (void)setModel:(JHChatMenuItemModel *)model {
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
        _titleLabel.textColor = HEXCOLOR(0xffffff);
        _titleLabel.font = [UIFont fontWithName:kFontNormal size:8];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
@end
