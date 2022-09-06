//
//  JHLotteryDetailInfoView.m
//  TTjianbao
//
//  Created by wangjianios on 2020/7/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLotteryDetailInfoView.h"
#import "JHLotteryStatusView.h"
#import "JHLotteryHitDetailView.h"
#import "JHLine.h"

@interface JHLotteryDetailInfoView ()

@property (nonatomic, weak) JHLotteryStatusView *headerView;

@property (nonatomic, weak) UILabel *timeLabel;

///剩余时间 秒
@property (nonatomic, assign) long timeNum;

/// 2-未中奖  3-未参与   4-中奖未填写地址  5-中奖有写地址  6-中奖有写物流信息
@property (nonatomic, assign) NSInteger type;
///展示中奖状态的label
@property (nonatomic, strong) UILabel *hitStatusLabel;
@property (nonatomic, strong) UIButton *wechatButton;




@end

@implementation JHLotteryDetailInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self addSelfSubViews];
    }
    return self;
}

- (void)addSelfSubViews
{
    _headerView = [JHLotteryStatusView jh_viewWithColor:UIColor.whiteColor addToSuperview:self];
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
//        make.height.mas_equalTo(80);
    }];
}

///  2-未中奖  3-未参与   4-中奖未填写地址  5-中奖有写地址  6-中奖有写物流信息
- (void)setModel:(JHLotteryActivityDetailModel *)model
{
    if (!model) {
        return;
    }
    _model = model;
    [self getSelfType];
    
    for(UIView *view in self.subviews)
    {
        if(![view isKindOfClass:[JHLotteryStatusView class]])
        {
            [view removeFromSuperview];
        }
    }
    [_headerView setTitle:self.model.prizeName price:self.model.price origPrice:self.model.prizePrice];
    
    UIView *senderview = _headerView;
    {
        UILabel *label = [UILabel jh_labelWithFont:14 textColor:RGB153153153 addToSuperView:self];
        label.text = [NSString stringWithFormat:@"%@期",_model.activityDate];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(senderview.mas_bottom).offset(20);
            make.centerX.equalTo(self);
        }];
        senderview = label;
    }
    
    {
        /// 1-未开奖（提醒）   2-未中奖  3-未参与   4-中奖未填写地址  5-中奖有写地址  6-中奖有写物流信息
        UILabel *label = [UILabel jh_labelWithBoldFont:18 textColor:RGB515151 addToSuperView:self];
        label.text = self.model.hitTxt;
        _hitStatusLabel = label;
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(senderview.mas_bottom).offset(15);
            make.centerX.equalTo(self);
        }];
        senderview = label;
    }
    
    if(self.model.hitCode)
    {
        UILabel *label = [UILabel jh_labelWithBoldFont:12 textColor:RGB515151 addToSuperView:self];
        label.text = [NSString stringWithFormat:@"中奖号码：%@",self.model.hitCode];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(senderview.mas_bottom).offset(10);
            make.centerX.equalTo(self).offset(10);
        }];
        
        UIImageView *avatarView = [UIImageView jh_imageViewAddToSuperview:self];
        [avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(label.mas_left).offset(-5);
            make.height.width.mas_equalTo(15);
            make.centerY.equalTo(label);
        }];
        [avatarView jh_cornerRadius:7.5];
        [avatarView jh_setImageWithUrl:self.model.hitUserImg];
        senderview = label;
    }
    
    ///下面都是依赖于显示中奖状态的view的
    if(_type == 4)
    {
        if (!_wechatButton) {
            
            JHGradientView *line = [JHGradientView new];
            [line setGradientColor:@[(__bridge id)RGB(254, 225, 0).CGColor,(__bridge id)RGB(255, 194, 66).CGColor] orientation:JHGradientOrientationHorizontal];
            [self addSubview:line];
            [line jh_cornerRadius:22];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self).offset(-15);
                make.left.equalTo(self).offset(15);
                make.height.mas_equalTo(44);
                make.top.equalTo(senderview.mas_bottom).offset(30);
            }];
            
            UIButton *wechatButton = [UIButton jh_buttonWithTarget:self action:@selector(clickMethod) addToSuperView:self];
            wechatButton.jh_titleColor(UIColor.blackColor).jh_title(@"填写收货地址").jh_font([UIFont boldSystemFontOfSize:13]);
            wechatButton.backgroundColor = RGB(255,194,66);
            [wechatButton jh_cornerRadius:19];
            _wechatButton = wechatButton;
            [wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(line);
            }];
            
            UILabel *label = [UILabel jh_labelWithBoldFont:12 textColor:RGB515151 addToSuperView:self];
            label.text = @"00:00:00.1";
            label.text = self.model.receiveEndTimeTxt;
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(wechatButton.mas_bottom).offset(10);
                make.centerX.equalTo(self);
            }];
            
            senderview = label;
        }
    }
    else
    if (_type == 5 || _type == 6)
    {
        {
            JHLotteryHitDetailView *address = [[JHLotteryHitDetailView alloc] init];
            NSString *detail = [NSString stringWithFormat:@"%@ %@",self.model.address.name, self.model.address.phone];
            NSString *desc = [NSString stringWithFormat:@"%@%@",self.model.address.region, self.model.address.address];
            [address setIcon:@"lottery_address" Title:@"收货地址" Detail:detail Desc:desc];
            [self addSubview:address];
            [address mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(15);
                make.right.equalTo(self).offset(-15);
                make.top.equalTo(senderview.mas_bottom).offset(25);
            }];
            
            senderview = address;
        }
        
        if(_type == 6)
        {
            JHLotteryHitDetailView *orderView = [[JHLotteryHitDetailView alloc] init];
            NSString *detail = [NSString stringWithFormat:@"物流公司：%@",self.model.logistics.company];
            NSString *desc = [NSString stringWithFormat:@"运单号：%@",self.model.logistics.expressNo];
            [orderView setIcon:@"lottery_address" Title:self.model.logistics.status?:@"未知状态" Detail:detail Desc:desc];
            [self addSubview:orderView];
            [orderView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset(15);
                make.right.equalTo(self).offset(-15);
                make.top.equalTo(senderview.mas_bottom).offset(25);
            }];
            
            senderview = orderView;
        }
    }
    
    [senderview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-20);
    }];
}

- (void)clickMethod
{
    if(_addAddressBlock)
    {
        _addAddressBlock();
    }
}

/// 2-未中奖  3-未参与   4-中奖未填写地址  5-中奖有写地址  6-中奖有写物流信息 1-其他
-(void)getSelfType
{
    if(self.model.hit == 2)
    {
        self.type = 2;
    }
    else if(self.model.hit == 0)
    {
        self.type = 3;
    }
    else if(!self.model.address)
    {
        self.type = 4;
    }
    else if(!self.model.logistics)
    {
        self.type = 5;
    }
    else if(self.model.logistics && self.model.address)
    {
        self.type = 6;
    }
    else
    {
        self.type = 1;
    }
}

@end
