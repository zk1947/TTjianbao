//
//  JHAlertView.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/8/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHAlertView.h"
@interface JHAlertView ()
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *icon;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIButton *completeButton;
@property (nonatomic, strong) UIButton *closeButton;
@end
@implementation JHAlertView
+ (void)showWithTitle : (NSString *)title desc : (NSString *)desc handler : (CompleteHandler)handler{
    [JHAlertView showWithTitle:title desc:desc handler:handler closeHandler:^{
        
    }];
}
+ (void)showWithTitle : (NSString *)title desc : (NSString *)desc handler : (CompleteHandler)handler closeHandler : (CloseHandler)closeHandler{
    dispatch_async(dispatch_get_main_queue(), ^{
        JHAlertView *alert = [[JHAlertView alloc] initWithFrame:CGRectZero];
        alert.titleText = title;
        alert.descText = desc;
        alert.completeHandler = handler;
        alert.closeHandler = closeHandler;
        [alert show];
    });
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    // 曝光埋点
    [self reportOpen];
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self layoutViews];
    }
    return self;
}

#pragma mark - 点击事件
// 完成
- (void)didClickComplete : (UIButton *)sender {
    if (self.completeHandler) {
        self.completeHandler();
        [self reportClickOpen];
    }
}
// 关闭
- (void)didClickClose : (UIButton *)sender {
    if (self.closeHandler) {
        self.closeHandler();
    }
    [self removeFromSuperview];
}

#pragma mark - UI
- (void)setupUI {
    self.backgroundColor = HEXCOLORA(0x000000, 0.5);
    self.frame = CGRectMake(0, 0, ScreenW, ScreenH);
}
- (void)layoutViews {
    
    [self addSubview:self.contentView];
    
    [self.contentView addSubview:self.icon];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.descLabel];
    [self.contentView addSubview:self.closeButton];
    [self.contentView addSubview:self.completeButton];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@260);
        make.center.equalTo(self);
    }];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(65, 65));
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.icon.mas_bottom).offset(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.titleLabel);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(4);
    }];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.size.mas_equalTo(CGSizeMake(21, 21));
    }];
    [self.completeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.descLabel.mas_bottom).offset(20);
        make.bottom.mas_equalTo(-20);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(188, 40));
    }];
}
#pragma mark - LAZY
- (void)setTitleText:(NSString *)titleText {
    _titleText = titleText;
    self.titleLabel.text = titleText;
}
- (void)setDescText:(NSString *)descText {
    _descText = descText;
    self.descLabel.text = descText;
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        [_contentView jh_cornerRadius:8];
        _contentView.backgroundColor = HEXCOLOR(0xffffff);
    }
    return _contentView;
}
- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _icon.image = [UIImage imageNamed:@"alert_icon_notification"];
    }
    return _icon;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:17];
    }
    return _titleLabel;
}
- (UILabel *)descLabel {
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _descLabel.textColor = HEXCOLOR(0x333333);
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.font = [UIFont fontWithName:kFontNormal size:14];
    }
    return _descLabel;
}
- (UIButton *)completeButton {
    if (!_completeButton) {
        _completeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_completeButton jh_cornerRadius:5];
        [_completeButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        _completeButton.backgroundColor = HEXCOLOR(0xffd70f);
        [_completeButton setTitle:@"立即开启" forState:UIControlStateNormal];
        _completeButton.titleLabel.font = [UIFont fontWithName:kFontBoldDIN size:15];
        [_completeButton addTarget:self action:@selector(didClickComplete:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _completeButton;
}
- (UIButton *)closeButton {
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:@"login_close"] forState:UIControlStateNormal ];
        _closeButton.contentMode=UIViewContentModeScaleAspectFit;
        _closeButton.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [_closeButton addTarget:self action:@selector(didClickClose:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeButton;
}

#pragma mark - 埋点
/// 弹框曝光埋点
- (void)reportOpen {
    NSDictionary *par = @{
        @"layer_type" : @"固定引导push开关",
        @"layer_name" : @"定时提醒弹窗",
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"epOpenLayer"
                                          params:par
                                            type:JHStatisticsTypeSensors];
}
/// 点击开启 埋点
- (void)reportClickOpen {
    NSDictionary *par = @{
        @"layer_type" : @"固定引导push开关",
        @"layer_name" : @"定时提醒弹窗",
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickIntoLayer"
                                          params:par
                                            type:JHStatisticsTypeSensors];
}
@end
