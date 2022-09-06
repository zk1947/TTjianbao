//
//  JHRecycleImageTemplateBaseCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleImageTemplateBaseCell.h"
@interface JHRecycleImageTemplateBaseCell()
@property (nonatomic, strong) UILabel *startLabel;
@property (nonatomic, strong) UIStackView *stackView;

@end

@implementation JHRecycleImageTemplateBaseCell

#pragma mark - Life Cycle Functions
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupBaseUI];
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [self layoutBaseViews];
}
- (void)dealloc {
    NSLog(@"回收订单详情-%@ 释放", [self class]);
}
#pragma mark - Public functions
- (void)setupSelectedImageUI {
    [self.bgimageView jh_borderWithColor:HEXCOLOR(0xffd70f) borderWidth:1];
}
- (void)setupNomalImageUI {
    [self.bgimageView jh_borderWithColor:HEXCOLOR(0xf0f0f3) borderWidth:1];
}


#pragma mark - setupUI
- (void)setupBaseUI {
    self.backgroundColor = HEXCOLOR(0xffffff);
    [self addSubview:self.bgimageView];
    [self addSubview:self.deleteButton];
    [self addSubview:self.stackView];
    [self setupNomalImageUI];
}
- (void)layoutBaseViews {
    [self.bgimageView jh_cornerRadius:2];
    [self.bgimageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(6);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(54, 54));
    }];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.centerX.mas_equalTo(self.bgimageView.mas_centerX);
        make.height.mas_equalTo(16);
        make.width.lessThanOrEqualTo(@54);
    }];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgimageView.mas_top).offset(-10);
        make.left.equalTo(self.bgimageView.mas_right).offset(-10);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}
#pragma mark - Lazy
- (UIImageView *)bgimageView {
    if (!_bgimageView) {
        _bgimageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _bgimageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgimageView;
}
- (UILabel *)startLabel {
    if (!_startLabel) {
        _startLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _startLabel.text = @"*";
        _startLabel.textColor = HEXCOLOR(0xff4e58);
        _startLabel.font = [UIFont fontWithName:kFontNormal size:8];
    }
    return _startLabel;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.font = [UIFont fontWithName:kFontNormal size:11];
    }
    return _titleLabel;
}
- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.startLabel, self.titleLabel]];
        _stackView.spacing = 3;
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.alignment = UIStackViewAlignmentFill;
        _stackView.distribution = UIStackViewDistributionFill;
    }
    return _stackView;
}
- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteButton setImage:[UIImage imageNamed:@"recycle_template_delete_icon"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(didClickDeleteWithAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deleteButton;
}


@end
