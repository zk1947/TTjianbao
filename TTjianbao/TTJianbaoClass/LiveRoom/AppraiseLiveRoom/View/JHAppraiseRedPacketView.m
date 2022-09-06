//
//  JHAppraiseRedPacketView.m
//  TTjianbao
//
//  Created by Jesse on 2020/7/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAppraiseRedPacketView.h"
#import "JHAppraiseRedPacketResultView.h"
#import "SVProgressHUD.h"
#import "JHGrowingIO.h"
#import "UIImageView+JHWebImage.h"

@interface JHAppraiseRedPacketView ()

@property (nonatomic, strong) UIImageView* bgview;
@property (nonatomic, strong) UIButton* closeView;
@property (nonatomic, strong) UIImageView* arvtarView;
@property (nonatomic, strong) UILabel* descLabel;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIButton* openButton;
@property (nonatomic, strong) JHAppraiseRedPacketListModel* dataModel;
@property (nonatomic, copy) JHActionBlock activeOpenEvent;
@end

@implementation JHAppraiseRedPacketView

- (void)dealloc
{
    NSLog(@">>>AppraiseRedPacket<<<");
}

- (instancetype)init
{
    if(self = [super init])
    {
        self.backgroundColor = HEXCOLORA(0x0, 0.2);
        self.tag = kAppraiseRedPacketResultTag + 1;
    }
    return self;
}

- (void)showAppraiserData:(JHAppraiseRedPacketListModel*)model action:(JHActionBlock)action
{
    self.dataModel = model;
    self.activeOpenEvent = action;
    [JHKeyWindow  addSubview:self];
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(JHKeyWindow);
    }];
    [self drawRedPacketSubview];
    [self.arvtarView jhSetImageWithURL:[NSURL URLWithString:model.sendCustomerImg ? : @""]];
    self.descLabel.text = model.sendCustomerName ? : @" ";
    self.titleLabel.text =   model.wishes ? : @"恭喜发财，大吉大利";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:self.dataModel.trackingParams];
    [params setValue:self.dataModel.appraiseRpId forKey:@"red_envelope_id"];
    [params setValue:self.dataModel.wishes forKey:@"red_envelope_name"];
    [params setValue:@"1" forKey:@"anchor_role"];
    [JHAllStatistics jh_allStatisticsWithEventId:@"zbjhdRedEncelopeExposure" params:params type:JHStatisticsTypeSensors];
}

- (void)sa_openMethod {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:self.dataModel.trackingParams];
    [params setValue:self.dataModel.appraiseRpId forKey:@"red_envelope_id"];
    [params setValue:self.dataModel.wishes forKey:@"red_envelope_name"];
    [params setValue:@"1" forKey:@"anchor_role"];
    [JHAllStatistics jh_allStatisticsWithEventId:@"zbjhdRedEncelopeReceive" params:params type:JHStatisticsTypeSensors];
}

- (void)drawRedPacketSubview
{
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
    
    [self.bgview addSubview:self.arvtarView];
    [self.arvtarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgview).offset(30);
        make.centerX.equalTo(self.bgview);
        make.size.mas_equalTo(35);
    }];
    
    [self.bgview addSubview:self.descLabel];
    [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.arvtarView.mas_bottom).offset(5);
        make.centerX.equalTo(self.bgview);
        make.height.mas_equalTo(18);
    }];
    
    [self.bgview addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.descLabel.mas_bottom).offset(29);
        make.centerX.equalTo(self.bgview);
        make.height.mas_equalTo(30);
    }];
    
    UIImageView* lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"red_packet_alert_line"]];
    [self.bgview addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgview).offset(-77.f);
        make.centerX.equalTo(self.bgview);
        make.size.mas_equalTo(CGSizeMake(290.f, 63.f));
    }];
    
    [self.bgview addSubview:self.openButton];
    [self.openButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgview);
        make.bottom.equalTo(self.bgview).offset(-50);
        make.size.mas_equalTo(CGSizeMake(96, 96));
    }];
}

- (void)dismiss
{
    [self removeFromSuperview];
}

+ (void)dismissAllAppraiserRedPackeView
{
    for (UIView* view in JHKeyWindow.subviews)
    {
        if(view.tag == kAppraiseRedPacketResultTag || view.tag == kAppraiseRedPacketResultTag+1)
        {
            [view removeFromSuperview];
        }
    }
}

#pragma mark - subviews
- (UIImageView *)bgview
{
    if(!_bgview)
    {
        _bgview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"appraise_redPacket_open_bg"]];
        _bgview.userInteractionEnabled = YES;
        _bgview.layer.cornerRadius = 8;
        _bgview.layer.masksToBounds = YES;
    }
    return _bgview;
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
        _arvtarView.layer.masksToBounds = YES;
    }
    return _arvtarView;
}

- (UILabel *)descLabel
{
    if(!_descLabel)
    {
        _descLabel = [UILabel new];
        _descLabel.font = JHFont(13);
        _descLabel.textColor = HEXCOLOR(0xFCDEB3);
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.text = @"鉴定师 伟伟的红包";
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

- (UIButton *)openButton
{
    if(!_openButton)
    {
        _openButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_openButton setImage:[UIImage imageNamed:@"appraise_redPacket_open"] forState:UIControlStateNormal];
        [_openButton addTarget:self action:@selector(openAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _openButton;
}

#pragma mark - event
- (void)openAction
{
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVC];
        return;
    }
    JH_WEAK(self)
    [JHAppraiseRedPacketModel asynReqTakeRedpacketId:self.dataModel.redPacketId channelId:self.dataModel.channelId Resp:^(NSString* msg, JHAppraiseRedPacketTakeModel* data) {
        JH_STRONG(self)
        if(data)
        {
            data.channelId = self.dataModel.channelId;
            data.sendCustomerId = self.dataModel.sendCustomerId;
            [[JHAppraiseRedPacketResultView new] showWithData:data];
        }
        else if(msg)
            [SVProgressHUD showErrorWithStatus:msg];
    }];
    [self dismiss];
    if(self.activeOpenEvent)
        self.activeOpenEvent(@"");
    
    [JHGrowingIO trackPublicEventId:JHOpenAppraiserSendGiftClick paramDict:@{@"roomId":self.dataModel.channelId ? : @"", @"appraiserId":self.dataModel.sendCustomerId ? : @""}];
    
    [self sa_openMethod];
}

- (void)closeAction
{
    [self dismiss];
}

@end
