//
//  JHChatNewMessageView.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatNewMessageView.h"
@interface JHChatNewMessageView()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation JHChatNewMessageView
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

- (void)setupDataWithNum : (NSInteger) num {
    
    NSString *str = [NSString stringWithFormat:@"%ld", (long)num];
    
    if (num > 99) {
        str = @"99+";
    }
    
    self.titleLabel.text = [NSString stringWithFormat:@"%@条新消息", str];
}
#pragma mark - UI
- (void)setupUI {
    
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
}
- (void)layoutViews {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.height.mas_equalTo(24);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(0);
        make.left.equalTo(self.contentView.mas_left).offset(14);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
    }];
}
#pragma mark - LAZY
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = HEXCOLOR(0xffffff);
        [_contentView jh_cornerRadius:12 shadowColor:HEXCOLORA(0x000000, 0.05)];
        _contentView.userInteractionEnabled = true;
        @weakify(self)
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            @strongify(self)
            if (self.clickHandler == nil) return;
            self.clickHandler();
        }];
        [_contentView addGestureRecognizer:tap];
    }
    return _contentView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = HEXCOLOR(0xf23730);
        _titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}
@end
