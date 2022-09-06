//
//  JHCustomizeAnchorBottomBar.m
//  TTjianbao
//
//  Created by apple on 2020/9/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeAnchorBottomBar.h"
#import "JHLiveStoreView.h"

@interface JHCustomizeAnchorBottomBar ()

@property (nonatomic,strong)UIButton *sayWhatBtn;/// 助理增加输入框
@property (nonatomic,strong)UIButton *sceneBtn;//镜头button
@property (nonatomic,strong)UIButton *soundBtn;//声音button

@property (nonatomic,strong)UIButton *orderBtn;//订单button
@property (nonatomic,strong)UIButton *queueBtn;//队列button

@property (nonatomic,strong)UIButton *noticeBtn;//公告button

@property (nonatomic,strong)UIButton *moreBtn;//更多button

@property(nonatomic, strong) UIButton * shanGouBtn;

@property(nonatomic, assign) BOOL  hasShanGou;
@end

@implementation JHCustomizeAnchorBottomBar
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)initWithType:(NSInteger)type{
    self = [super init];
    if (self) {
        if (type == 2) {
            [self creatUI_Helper];
        }else{
            self.hasShanGou = type == NSIntegerMax;
            [self creatUI];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOrderNumber) name:@"NotificationNameUpdateOrderNumber" object:nil];
    }
    return self;;
}
//助理
- (void)creatUI_Helper{
    [self shopwindowButton];
    
    _sayWhatBtn = [UIButton jh_buttonWithTarget:self action:@selector(sayWhatBtnDidClicked:) addToSuperView:self];
    [_sayWhatBtn setTitle:@"跟大家伙聊点啥" forState:UIControlStateNormal];
    _sayWhatBtn.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    _sayWhatBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:13.f];
    _sayWhatBtn.layer.cornerRadius = 21.f;
    _sayWhatBtn.layer.masksToBounds = YES;
    [_sayWhatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopwindowButton.mas_right).offset(10);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(120, 42));
    }];
    
    _orderBtn = [UIButton jh_buttonWithImage:@"icon_custom_order" target:self action:@selector(orderListAction:) addToSuperView:self];
    [_orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.left.mas_equalTo(self.sayWhatBtn.mas_right).offset(10);
    }];
    _orderdoteLabel = [[JHDoteNumberLabel alloc] init];
    _orderdoteLabel.text = @"0";
    [self addSubview:_orderdoteLabel];
    [_orderdoteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_orderBtn.mas_top);
        make.size.mas_equalTo(CGSizeMake(16, 14));
        make.right.equalTo(_orderBtn.mas_right).offset(5);
    }];
    
    _noticeBtn = [UIButton jh_buttonWithImage:@"icon_custom_notice" target:self action:@selector(noticeAction:) addToSuperView:self];
    [_noticeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.left.equalTo(_orderBtn.mas_right).offset(10);
    }];
    
    _moreBtn = [UIButton jh_buttonWithImage:@"live_room_more" target:self action:@selector(moreMethod:) addToSuperView:self];
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.left.equalTo(_noticeBtn.mas_right).offset(10);
    }];
}

//主播
- (void)creatUI{
    [self shopwindowButton];
    
    UIButton *lastBtn = self.shopwindowButton;
    if (self.hasShanGou) {
        [self addSubview:self.shanGouBtn];
        [self.shanGouBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(36, 36));
            make.left.mas_equalTo(lastBtn.mas_right).offset(10);
        }];
        lastBtn = self.shanGouBtn;
    }
    
    _sceneBtn = [UIButton jh_buttonWithImage:@"icon_custom_scene" target:self action:@selector(sceneBtnAction:) addToSuperView:self];
    [_sceneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.left.mas_equalTo(lastBtn.mas_right).offset(10);
    }];
    
     //icon_custom_mute  icon_custom_nomute
    _soundBtn = [UIButton jh_buttonWithImage:@"icon_custom_nomute" target:self action:@selector(soundAction:) addToSuperView:self];
    [_soundBtn setImage:[UIImage imageNamed:@"icon_custom_mute"] forState:UIControlStateSelected];
    [_soundBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.left.equalTo(_sceneBtn.mas_right).offset(10);
    }];
   
    //    icon_pause_appraise icon_open_appraise
     _pauseBtn = [UIButton jh_buttonWithImage:@"icon_pause_appraise" target:self action:@selector(playOrPauseAction:) addToSuperView:self];
    [_pauseBtn setImage:[UIImage imageNamed:@"icon_open_appraise"] forState:UIControlStateSelected];
    [_pauseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.left.equalTo(_soundBtn.mas_right).offset(10);
    }];
    lastBtn = _pauseBtn;
    if (!self.hasShanGou) {
        _orderBtn = [UIButton jh_buttonWithImage:@"icon_custom_order" target:self action:@selector(orderListAction:) addToSuperView:self];
        [_orderBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(36, 36));
            make.left.equalTo(_pauseBtn.mas_right).offset(10);
        }];
        _orderdoteLabel = [[JHDoteNumberLabel alloc] init];
        _orderdoteLabel.text = @"0";
        [self addSubview:_orderdoteLabel];
        [_orderdoteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_orderBtn.mas_top);
            make.size.mas_equalTo(CGSizeMake(16, 14));
            make.right.equalTo(_orderBtn.mas_right).offset(5);
        }];
        lastBtn = _orderBtn;
    }
    
    _queueBtn = [UIButton jh_buttonWithImage:@"icon_custom_queue" target:self action:@selector(queueListAction:) addToSuperView:self];
    [_queueBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.left.equalTo(lastBtn.mas_right).offset(10);
    }];
//
    _doteLabel = [[JHDoteNumberLabel alloc] init];
    _doteLabel.text = @"0";
    [self addSubview:_doteLabel];
    [_doteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_queueBtn.mas_top);
        make.size.mas_equalTo(CGSizeMake(16, 14));
        make.right.equalTo(_queueBtn.mas_right).offset(5);
    }];
    
    _noticeBtn = [UIButton jh_buttonWithImage:@"icon_custom_notice" target:self action:@selector(noticeAction:) addToSuperView:self];
    [_noticeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.left.equalTo(_queueBtn.mas_right).offset(10);
    }];
    
    _moreBtn = [UIButton jh_buttonWithImage:@"live_room_more" target:self action:@selector(moreMethod:) addToSuperView:self];
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(36, 36));
        make.left.equalTo(_noticeBtn.mas_right).offset(10);
    }];
}

- (void)sayWhatBtnDidClicked:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(sayWhatBtnAction:)]) {
        [self.delegate sayWhatBtnAction:sender];
    }
}

- (void)updateOrderNumber{
    NSInteger num = [self.orderdoteLabel.text integerValue];
    num++;
    self.orderdoteLabel.text = @(num).stringValue;
}

- (void)sceneBtnAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(sceneAction:)]) {
        [self.delegate sceneAction:sender];
    }
}

- (void)soundAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(soundAction:)]) {
        [self.delegate soundAction:sender];
    }
}

- (void)playOrPauseAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(playOrPauseAction:)]) {
        [self.delegate playOrPauseAction:sender];
    }
}

- (void)orderListAction:(UIButton *)sender{
    self.orderdoteLabel.text = @"0";
    if (self.delegate && [self.delegate respondsToSelector:@selector(customorderListAction:)]) {
        [self.delegate customorderListAction:sender];
    }
}

- (void)queueListAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(queueListAction:)]) {
        [self.delegate queueListAction:sender];
    }
}

- (void)noticeAction:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(noticeAction:)]) {
        [self.delegate noticeAction:sender];
    }
}

- (void)moreMethod:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(customclickListBtnAction:Trailing:)]) {
        [self.delegate customclickListBtnAction:sender Trailing:sender.centerX];
    }
}
- (void)shanGouBtnActionWithSender:(UIButton *)sender{
    if([self.delegate respondsToSelector:@selector(onShanGouBtnAction)]) {
        [self.delegate onShanGouBtnAction];
    }
}

- (UIButton *)shopwindowButton {
    if(!_shopwindowButton) {
        _shopwindowButton = [UIButton jh_buttonWithBackgroundimage:@"live_room_shopwindow_enter" target:self action:@selector(enterShopwindowAction) addToSuperView:self];
//        _shopwindowButton.hidden = YES;
        [_shopwindowButton setAttributedTitle:[self getShadowWithText:@"购"] forState:UIControlStateNormal];
        _shopwindowButton.titleEdgeInsets = UIEdgeInsetsMake(10, 0, 0, 0);
        _shopwindowButton.jh_font([UIFont boldSystemFontOfSize:14]);
        [_shopwindowButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
            make.size.mas_equalTo(CGSizeMake(34, 42));
        }];
    }
    return _shopwindowButton;
}

- (void)enterShopwindowAction {
    JHLiveStoreViewType type = JHLiveStoreViewTypeSaler;
    JHLiveStoreView *storeView = [[JHLiveStoreView alloc] initWithType:type channel:self.channel];
    [JHRootController.currentViewController.view addSubview:storeView];
    
}

- (NSAttributedString *)getShadowWithText:(NSString *)text {
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowBlurRadius = 4;
    shadow.shadowColor = [UIColor colorWithRed:227/255.0 green:125/255.0 blue:0/255.0 alpha:1.0];
    shadow.shadowOffset =CGSizeMake(0,1);
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:text attributes: @{NSFontAttributeName: [UIFont boldSystemFontOfSize:14],NSForegroundColorAttributeName: [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0], NSShadowAttributeName: shadow}];
    return string;
}

- (UIButton *)shanGouBtn{
    if (!_shanGouBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"shangou_send"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(shanGouBtnActionWithSender:) forControlEvents:UIControlEventTouchUpInside];
        _shanGouBtn = btn;
    }
    return _shanGouBtn;
}

@end

