//
//  JHChatMediaCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatMediaCell.h"
@interface JHChatMediaCell ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLabel;

@end
@implementation JHChatMediaCell

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

- (void)configWithModel : (JHChatMediaModel *)model {
    self.model = model;
    [self setupData];
}
- (void)setupData {
    if (self.model == nil) return;
    self.titleLabel.text = self.model.title;
//    self.icon.image = [UIImage imageNamed:self.model.iconName];
    
    [[RACObserve(self.model, isSelected)
      takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(id  _Nullable x) {
        BOOL isSelected = [x boolValue];
        self.titleLabel.text = isSelected ? self.model.selTitle : self.model.title;
        NSString *image = isSelected ? self.model.selIconName : self.model.iconName;
        self.icon.image = [UIImage imageNamed:image];
    }];
}
#pragma mark - UI
- (void)setupUI {
    self.backgroundColor = HEXCOLOR(0xf8f8f8);
    [self.containerView addSubview:self.icon];
    [self addSubview:self.containerView];
    [self addSubview:self.titleLabel];
}
- (void)layoutViews {
    [self.containerView jh_cornerRadius:8];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(self.containerView.mas_width);
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(26, 26));
        make.center.mas_equalTo(0);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
    }];
}
#pragma mark - LAZY
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectZero];
        _containerView.backgroundColor = HEXCOLOR(0xffffff);
    }
    return _containerView;
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
        _titleLabel.textColor = HEXCOLOR(0x666666);
        _titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
@end
