//
//  JHCustomizeDetailNavMoreView.m
//  TTjianbao
//
//  Created by user on 2020/11/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeDetailNavMoreView.h"

@interface JHCustomizeDetailNavMoreView ()
//@property (nonatomic, strong) UIView   *contentView;
@property (nonatomic, strong) UIButton *hiddenBtn;
@property (nonatomic, strong) UIView   *lineView;
@property (nonatomic, strong) UIButton *shareBtn;
@end

@implementation JHCustomizeDetailNavMoreView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.backgroundColor = HEXCOLORA(0x000000, 0.6f);
    self.layer.cornerRadius = 4.f;
    
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.image = [UIImage imageNamed:@"customize_desc_moreView"];
    backImageView.userInteractionEnabled = YES;
    [self addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right).offset(-6.f);
        make.width.mas_equalTo(12.f);
        make.height.mas_equalTo(6.f);
    }];
    
    _lineView = [[UIView alloc] init];
    _lineView.backgroundColor = HEXCOLOR(0x999999);
    [self addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(5.f);
        make.right.equalTo(self.mas_right).offset(-5.f);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(1.f);
    }];
    
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_shareBtn setTitleColor:HEXCOLOR(0xFFFFFF) forState:UIControlStateNormal];
    _shareBtn.titleLabel.font      = [UIFont fontWithName:kFontMedium size:13.f];
    [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [_shareBtn addTarget:self action:@selector(shareBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_shareBtn];
    _shareBtn.userInteractionEnabled = YES;
    [_shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(backImageView.mas_top).offset(10.f);
        make.bottom.equalTo(self.lineView.mas_top).offset(-10.f);
    }];
    
    _hiddenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_hiddenBtn setTitleColor:HEXCOLOR(0xFFFFFF) forState:UIControlStateNormal];
    _hiddenBtn.titleLabel.font      = [UIFont fontWithName:kFontMedium size:13.f];
    [_hiddenBtn setTitle:@"隐藏" forState:UIControlStateNormal];
    [_hiddenBtn addTarget:self action:@selector(hiddenBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_hiddenBtn];
    [_hiddenBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self.lineView.mas_bottom).offset(10.f);
        make.bottom.equalTo(self.mas_bottom).offset(-10.f);
    }];
}

- (void)shareBtnAction:(UIButton *)sender {
    if (self.shareActionBlock) {
        self.shareActionBlock();
    }
}

- (void)hiddenBtnAction:(UIButton *)sender {
    if (self.hiddenActionBlock) {
        self.hiddenActionBlock();
    }
}

- (void)setHasHidden:(BOOL)hasHidden {
    _hasHidden = hasHidden;
    if (hasHidden) {
        [_hiddenBtn setTitle:@"取消隐藏" forState:UIControlStateNormal];
    } else {
        [_hiddenBtn setTitle:@"隐藏" forState:UIControlStateNormal];
    }
}

- (void)setHasHiddenButton:(BOOL)hasHiddenButton {
    _hasHiddenButton = hasHiddenButton;
    if (hasHiddenButton) { /// 有按钮
        _hiddenBtn.hidden = NO;
        _lineView.hidden = NO;
        [_shareBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.mas_top).offset(10.f);
            make.bottom.equalTo(self.lineView.mas_top).offset(-10.f);
        }];
    } else { /// 无按钮
        _hiddenBtn.hidden = YES;
        _lineView.hidden = YES;
        [_shareBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.mas_top).offset(0);
            make.bottom.equalTo(self.mas_bottom).offset(0);
        }];
    }
}

@end
