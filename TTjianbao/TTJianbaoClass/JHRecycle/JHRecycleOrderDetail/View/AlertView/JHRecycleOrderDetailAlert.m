//
//  JHRecycleOrderDetailAlert.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderDetailAlert.h"
#import "UIView+JHGradient.h"


static const CGFloat ButtonHeight = 40.f;

@interface JHRecycleOrderDetailAlert()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UIView *agreementView;
/** 协议按钮*/
@property (nonatomic, strong) UIButton *agreementLogoButton;
@property (nonatomic, strong) UIButton *agreementButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;
@end

@implementation JHRecycleOrderDetailAlert

#pragma mark - Life Cycle Functions
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
    }
    return self;
}

- (instancetype)initWithDesc : (NSString *)desc {
    self = [super initWithFrame:CGRectZero];
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
    NSLog(@"回收订单详情-%@ 释放", [self class]);
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        if (touch.view == self) {
            [self removeFromSuperview];
            return;
        }
    }
}
#pragma mark - Public Functions
- (void)showAlertWithDesc : (NSString *)desc {
    self.detailLabel.text = desc;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
}
- (void)showAlertWithDesc : (NSString *)desc in : (UIView *)view {
    self.detailLabel.text = desc;
    [view addSubview:self];
}
- (void)didAgreementButtonClick {
    self.agreementLogoButton.selected = !self.agreementLogoButton.selected;
}

- (void)didAgreementWebButtonClick {
    if (self.agreementHandle) {
        self.agreementHandle();
    }
}

#pragma mark - Action functions

- (void)didClickCancelAction : (UIButton *)sender {
    [self removeFromSuperview];
    if (self.cancelHandle) {
        self.cancelHandle();
    }
}
- (void)didClickConfirmAction : (UIButton *)sender {
    if (!self.agreementLogoButton.isSelected) {
        JHTOAST(@"请先同意产品所有权确认及处置委托书");
        return;
    }
    [self removeFromSuperview];
    if (self.handle) {
        self.handle();
    }
}

#pragma mark - Private Functions

#pragma mark - Bind
- (void)bindData {
    
}
#pragma mark - setupUI
- (void)setupUI {
    self.frame = [UIScreen mainScreen].bounds;
    self.contentMode=UIViewContentModeScaleAspectFit;
    self.backgroundColor= [UIColor colorWithRed:0.09f green:0.09f blue:0.09f alpha:0.5f];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.agreementView];
    [self.agreementView addSubview:self.agreementLogoButton];
    [self.agreementView addSubview:self.agreementButton];
    [self.contentView addSubview:self.stackView];
}
- (void)layoutViews {
    [self.contentView jh_cornerRadius:8];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(260);
//        make.height.mas_equalTo(232);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(32);
        make.height.mas_equalTo(24);
        make.left.right.equalTo(self.contentView).offset(0);
    }];
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
        make.left.mas_equalTo(22);
        make.right.mas_equalTo(-22);
        
    }];
    [self.agreementView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.detailLabel.mas_bottom).offset(15);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.bottom.equalTo(self.stackView.mas_top).offset(-30);
        make.height.mas_equalTo(18);
    }];
    [self.agreementLogoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.agreementView);
        make.left.mas_equalTo(self.agreementView);
        make.width.height.mas_equalTo(18);
    }];
    [self.agreementButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.agreementLogoButton.mas_right);
        make.centerY.mas_equalTo(self.agreementView);
        make.height.mas_equalTo(self.agreementView);
        make.right.mas_equalTo(self.agreementView);
    }];
    [self.stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-29);
        make.left.right.equalTo(self.detailLabel);
        make.height.mas_equalTo(ButtonHeight);
    }];
}


#pragma mark - Lazy
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectZero];
        _contentView.backgroundColor = HEXCOLOR(0xffffff);
    }
    return _contentView;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.text = @"提示";
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:18];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}
- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _detailLabel.textColor = HEXCOLOR(0x333333);
        _detailLabel.numberOfLines = 0;
        _detailLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _detailLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _detailLabel;
}
- (UIView *)agreementView {
    if (!_agreementView) {
        _agreementView = [[UIView alloc]initWithFrame:CGRectZero];
//        _agreementView.backgroundColor = UIColor.redColor;
    }
    return _agreementView;
}
- (UIButton *)agreementLogoButton {
    if (!_agreementLogoButton) {
        _agreementLogoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agreementLogoButton setImage:[UIImage imageNamed:@"recycle_order_cancel_normal"] forState:UIControlStateNormal];
        [_agreementLogoButton setImage:[UIImage imageNamed:@"recycle_order_cancel_selected"] forState:UIControlStateSelected];
        [_agreementLogoButton addTarget:self action:@selector(didAgreementButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreementLogoButton;
}
- (UIButton *)agreementButton {
    if (!_agreementButton) {
        _agreementButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_agreementButton setTitle:@"《产品所有权确认及处置委托书》" forState:UIControlStateNormal];
        [_agreementButton setTitleColor:HEXCOLOR(0x408ffe) forState:UIControlStateNormal];
        _agreementButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        [_agreementButton addTarget:self action:@selector(didAgreementWebButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _agreementButton;
}
- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:15];
        [_cancelButton jh_borderWithColor:HEXCOLOR(0xbdbfc2) borderWidth:0.5];
        [_cancelButton jh_cornerRadius:ButtonHeight / 2];
        [_cancelButton addTarget:self action:@selector(didClickCancelAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_confirmButton setTitle:@"确认销毁" forState:UIControlStateNormal];
        [_confirmButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        _confirmButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:15];
        [_confirmButton jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xfed73a), HEXCOLOR(0xfecb33)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
        [_confirmButton jh_cornerRadius:ButtonHeight / 2];
        [_confirmButton addTarget:self action:@selector(didClickConfirmAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _confirmButton;
}
- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.cancelButton, self.confirmButton]];
        _stackView.spacing = 10.f;
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.alignment = UIStackViewAlignmentFill;
        _stackView.distribution = UIStackViewDistributionFillEqually;
    }
    return _stackView;
}
@end
