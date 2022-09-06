//
//  JHAppraiseRedPacketResultView.m
//  TTjianbao
//
//  Created by Jesse on 2020/7/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "JHAppraiseRedPacketResultView.h"
#import "JHAppraiseRedPacketModel.h"
#import "JHGrowingIO.h"
#import "UIImageView+JHWebImage.h"
@interface JHAppraiseRedPacketResultView ()

@property (nonatomic, strong) UIImageView* bgview;
@property (nonatomic, strong) UIImageView* couponview;
@property (nonatomic, strong) UIButton* closeView;
@property (nonatomic, strong) UILabel* descLabel;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIButton* getButton;
@property (nonatomic, strong) UIImageView* arvtarView;
@property (nonatomic, strong) JHAppraiseRedPacketTakeModel* dataModel;
@end

@implementation JHAppraiseRedPacketResultView

- (void)dealloc
{
    NSLog(@">>>AppraiseRedPacket<<<");
}

- (instancetype)init
{
    if(self = [super init])
    {
        self.backgroundColor = HEXCOLORA(0x0, 0.2);
        self.tag = kAppraiseRedPacketResultTag;
    }
    return self;
}

- (void)showWithData:(JHAppraiseRedPacketTakeModel*)model
{
    self.dataModel = model;
    [JHKeyWindow  addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(JHKeyWindow);
    }];
    if([self.dataModel.mCode integerValue] == 1)
        [self drawSuccessSubviews];
    else
        [self drawFailSubviews];
}

- (void)drawSuccessSubviews
{
    [self addSubview:self.bgview];
    [self.bgview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(333, 357));
    }];
    
    [self addSubview:self.closeView];
    [self.closeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bgview.mas_top).offset(-13);
        make.right.equalTo(self.bgview).offset(-20);
        make.size.mas_equalTo(24);
    }];
    
    [self.couponview jhSetImageWithURL:[NSURL URLWithString:self.dataModel.tips2 ? : @""]];
    [self.bgview addSubview:self.couponview];
    [self.couponview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bgview).offset(93);
        make.centerX.equalTo(self.bgview);
        make.size.mas_equalTo(CGSizeMake(223, 70));
    }];
    
    self.descLabel.text = self.dataModel.tips1 ? : @"奖品可在个人中心查看，可在直播间购物使用";
    [self.bgview addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bgview).offset(-24);
        make.centerX.equalTo(self.bgview);
        make.height.mas_equalTo(18);
    }];
    
    [self.bgview addSubview:self.getButton];
    [self.getButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgview);
        make.bottom.mas_equalTo(self.descLabel.mas_top).offset(-20);
        make.size.mas_equalTo(CGSizeMake(182, 53));
    }];
}

- (void)drawFailSubviews
{
    [self.bgview setImage:[UIImage imageNamed:@"appraise_redPacket_open_bg"]];
    [self addSubview:self.bgview];
    [self.bgview mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(280, 370));
    }];
    
    [self addSubview:self.closeView];
    [self.closeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.bgview.mas_top).offset(-15);
        make.right.equalTo(self.bgview).offset(8);
        make.size.mas_equalTo(24);
    }];

    [self.arvtarView jhSetImageWithURL:[NSURL URLWithString:self.dataModel.sendCustomerImg ? : @""]];
    [self.bgview addSubview:self.arvtarView];
    [self.arvtarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgview).offset(30);
        make.centerX.equalTo(self.bgview);
        make.size.mas_equalTo(35);
    }];
    
    self.descLabel.textColor = HEXCOLOR(0xFCDEB3);
    self.descLabel.text = self.dataModel.sendCustomerName ? : @" "; 
    [self.bgview addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.arvtarView.mas_bottom).offset(5);
        make.centerX.equalTo(self.bgview);
        make.height.mas_equalTo(18);
    }];

    self.titleLabel.text = self.dataModel.tips1 ? : @"手速慢，红包被抢完了";
    [self.bgview addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.descLabel.mas_bottom).offset(29);
        make.centerX.equalTo(self.bgview);
        make.height.mas_equalTo(30);
    }];
    
    UIImageView* lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"red_packet_alert_light_line"]];
    [self.bgview addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgview).offset(-77.f);
        make.centerX.equalTo(self.bgview);
        make.size.mas_equalTo(CGSizeMake(290.f, 63.f));
    }];
}

- (void)dismiss
{
    [self removeFromSuperview];
}

#pragma mark - subviews
- (UIImageView *)bgview
{
    if(!_bgview)
    {
        _bgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appraise_redPacket_got_bg"]];
        _bgview.userInteractionEnabled = YES;
        _bgview.layer.cornerRadius = 8;
        _bgview.layer.masksToBounds = YES;
    }
    return _bgview;
}

- (UIImageView *)couponview
{
    if(!_couponview)
    {
        _couponview = [UIImageView new];
    }
    return _couponview;
}

- (UIButton *)closeView
{
    if(!_closeView)
    {
        _closeView = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeView setImage:[UIImage imageNamed:@"appraise_redPacket_close"] forState:UIControlStateNormal];
        [_closeView addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeView;
}

- (UIImageView *)arvtarView
{
    if(!_arvtarView)
    {
        _arvtarView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_avatar_yellow"]];
        [_arvtarView jh_cornerRadius:17.5 borderColor:RGB(255, 240, 219) borderWidth:1];
    }
    return _arvtarView;
}

- (UILabel *)descLabel
{
    if(!_descLabel)
    {
        _descLabel = [UILabel new];
        _descLabel.font = JHFont(12);
        _descLabel.textColor = HEXCOLOR(0xFFFFFF);
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.text = @"奖品可在个人中心查看，可在直播间购物使用";
    }
    return _descLabel;
}

- (UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = JHBoldFont(22);
        _titleLabel.textColor = HEXCOLOR(0xFCDEB3);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text =  @"恭喜发财，大吉大利";
    }
    return _titleLabel;
}

- (UIButton *)getButton
{
    if(!_getButton)
    {
        _getButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_getButton setImage:[UIImage imageNamed:(self.dataModel.landingType == 0 ? @"appraise_redPacket_got" : @"appraise_redPacket_used")] forState:UIControlStateNormal];
        //添加动画
        CABasicAnimation *anima = [CABasicAnimation animation];
        anima.keyPath = @"transform.scale";
        anima.repeatCount = MAXFLOAT;
        anima.duration = 0.5f;
        anima.autoreverses = YES;
        anima.removedOnCompletion = NO;
        anima.fromValue = [NSNumber numberWithFloat:0.9]; // 开始时的倍率
        anima.toValue = [NSNumber numberWithFloat:1.1]; // 结束时的倍率
        [_getButton.layer addAnimation:anima forKey:nil];
        [_getButton addTarget:self action:@selector(getAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getButton;
}

- (void)getAction
{
    switch (self.dataModel.landingType) {
        case 1:
        {
            [JHRootController EnterLiveRoom:self.dataModel.channelLocalId fromString:@"JHAppraiseRedPacketResultView"];
        }
            break;
        
        case 2:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameGotoUsedAppraiseRedPacket object:nil];
            
        }
            break;
        default:
            break;
    }
    [self dismiss];
    [JHGrowingIO trackPublicEventId:JHReceivedAppraiserSendGiftClick paramDict:@{@"roomId":self.dataModel.channelId ? : @"", @"appraiserId":self.dataModel.sendCustomerId ? : @"", @"is_received" : @"1"}];
}

- (void)closeAction
{
    [self dismiss];
    [JHGrowingIO trackPublicEventId:JHReceivedAppraiserSendGiftClick paramDict:@{@"roomId":self.dataModel.channelId ? : @"", @"appraiserId":self.dataModel.sendCustomerId ? : @"", @"is_received" : @"0"}];
}

@end
