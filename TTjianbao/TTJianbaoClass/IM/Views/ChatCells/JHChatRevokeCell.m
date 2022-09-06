//
//  JHChatRevokeCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatRevokeCell.h"

@interface JHChatRevokeCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *editButton;
@property (nonatomic, strong) UIStackView *stackView;
@end

@implementation JHChatRevokeCell


#pragma mark - Life Cycle Functions
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [self layoutViews];
}
- (void)dealloc {
    NSLog(@"IM释放-%@ 释放", [self class]);
}
- (void)didClickEdit : (UIButton *)sender {
    if (self.editEvent == nil) return;
    self.editEvent(self.message);
}
- (void)setupData {
    if (self.message == nil) return;
    self.titleLabel.attributedText = self.message.attText;
    self.editButton.hidden = !self.message.isEdit;
}
#pragma mark - UI
- (void)setupUI {
    self.contentView.userInteractionEnabled = false;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = HEXCOLOR(0xf5f6fa);
    [self addSubview:self.stackView];
}
- (void)layoutViews {
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(1);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(18);
    }];
}
#pragma mark - LAZY
- (void)setMessage:(JHMessage *)message {
    _message = message;
    [self setupData];
}
- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.titleLabel, self.editButton]];
        _stackView.spacing = 5;
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        
    }
    return _stackView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = HEXCOLOR(0x999999);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
    }
    return _titleLabel;
}
- (UIButton *)editButton {
    if (!_editButton) {
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editButton setTitle:@"重新编辑" forState:UIControlStateNormal];
        [_editButton setTitleColor:HEXCOLOR(0x408ffe) forState:UIControlStateNormal];
        _editButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        [_editButton addTarget:self action:@selector(didClickEdit:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _editButton;
}
@end
