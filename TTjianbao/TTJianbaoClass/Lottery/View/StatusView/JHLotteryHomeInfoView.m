//
//  JHLotteryHomeInfoView.m
//  TTjianbao
//
//  Created by wangjianios on 2020/7/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLotteryHomeInfoView.h"
#import "JHLotteryStatusView.h"
#import "NSTimer+Help.h"
#import "JHLotteryModel.h"
#import "JHLine.h"

@interface JHLotteryHomeInfoView ()

@property (nonatomic, weak) JHLotteryStatusView *headerView;

@property (nonatomic, weak) UILabel *timeLabel;

@property (nonatomic, strong) NSTimer *timer;

///剩余时间 秒
@property (nonatomic, assign) NSInteger timeNum;

@property (nonatomic, copy) void (^ timeBlock) (long timeNum);

@end

@implementation JHLotteryHomeInfoView

-(void)dealloc
{
    [_timer invalidate];
}

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
    }];
}

/// 0-未参与  1-参与未分享  2-分享未助力 3-分享满 4-提醒(开启，关闭)
-(void)setModel:(JHLotteryActivityData *)model
{
    _model = model;

    _timeNum = _model.timeTotalNum / 100;
    
    for(UIView *view in self.subviews)
    {
        if(![view isKindOfClass:[JHLotteryStatusView class]])
        {
            [view removeFromSuperview];
        }
    }
    
    if(_type != 3)
    {
        JHGradientView *line = [JHGradientView new];
        [line setGradientColor:@[(__bridge id)RGB(254, 225, 0).CGColor,(__bridge id)RGB(255, 194, 66).CGColor] orientation:JHGradientOrientationHorizontal];
        [self addSubview:line];
        [line jh_cornerRadius:22];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-15);
            make.left.equalTo(self).offset(15);
            make.height.mas_equalTo(44);
            make.top.equalTo(self.headerView.mas_bottom).offset(self.type == 2 ? 10 : 20);
        }];
        
        UIButton *wechatButton = [UIButton jh_buttonWithTarget:self action:@selector(shareMethod) addToSuperView:self];
        [wechatButton jh_cornerRadius:19];
        wechatButton.jh_font([UIFont boldSystemFontOfSize:15]);
        wechatButton.backgroundColor = UIColor.clearColor;
        [wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(line);
        }];
        
        NSString *buttonTitle = _model.buttonTxt;
        if(_type == 1 || _type == 2)
        {
            buttonTitle = [NSString stringWithFormat:@"  %@",_model.buttonTxt];
            [wechatButton setImage:JHImageNamed(@"lottery_wechat") forState:UIControlStateNormal];
        }
        else if(_type == 4)
        {
            buttonTitle = [NSString stringWithFormat:@"  %@",_model.buttonTxt];
            [wechatButton setImage:JHImageNamed(@"lottery_timer") forState:UIControlStateNormal];
        }
        wechatButton.jh_title(buttonTitle).jh_titleColor(UIColor.blackColor);
        
        UILabel *tipLabel = nil;
        if(_type == 2)
        {
            tipLabel = [UILabel jh_labelWithFont:12 textColor:RGB153153153 addToSuperView:self];
            tipLabel.text = _model.subtitle;
            [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(wechatButton.mas_bottom).offset(8);
                make.centerX.equalTo(self);
//                make.bottom.equalTo(self).offset(-15);
            }];
        }
        
        _timeLabel = [UILabel jh_labelWithFont:12 textColor:RGB153153153 addToSuperView:self];
        _timeLabel.font = JHDINBoldFont(12);
        _timeLabel.text = @" "; ///这行代码不能删 谁删揍谁~😁 -- lihui
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self).offset(self.type == 2 ? - 15 : -30);
            make.centerX.equalTo(self);
            if (tipLabel == nil) {
                make.top.equalTo(wechatButton.mas_bottom).offset(8);
            }
            else {
                make.top.equalTo(tipLabel.mas_bottom).offset(8);
            }
        }];
    }
    else
    {
        _timeLabel = [UILabel jh_labelWithFont:20 textColor:RGB153153153 addToSuperView:self];
        _timeLabel.font = JHDINBoldFont(20);
        _timeLabel.text = @"开奖中，请稍后查看";
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView.mas_bottom).offset(20);
            make.bottom.equalTo(self).offset(-50);
            make.centerX.equalTo(self);
        }];
    }
    
    [self.headerView setTitle:_model.prizeName price:_model.price origPrice:_model.prizePrice];
    if(_timeNum > 0)
    {
        [self.timer jh_star];
    }
}

- (void)shareMethod
{
    if(_buttonClickBlock)
    {
        _buttonClickBlock(self.type);
    }
}

- (NSTimer *)timer
{
    if(!_timer)
    {
        @weakify(self);
        _timer = [NSTimer jh_scheduledTimerWithTimeInterval:0.1 repeats:YES block:^{
            @strongify(self);
            self.timeNum --;
            self.timeLabel.text = [self getString];
        }];
    }
    return _timer;
}

- (NSString *)getString
{
    if(_timeBlock)
    {
        _timeBlock(_timeNum);
    }
    long num = (long)_timeNum/10;
    long num_ms = _timeNum%10;
    if(num == 0)
    {
        if(self.finshBlock)
        {
            self.finshBlock();
        }
        [_timer jh_stop];
        return @"开奖中，请稍后查看";
    }

    if(num < 60)
    {
        return [NSString stringWithFormat:@"%.2ld.%ld %@", num,num_ms,_model.surplusTxt];
    }
    else if(num < 60 * 60)
    {
        return [NSString stringWithFormat:@"%.2ld:%.2ld.%ld %@", num/60, num%60,num_ms,_model.surplusTxt];
    }
    else
    {
        return [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld.%ld %@",num/3600,(num % 3600)/60, num%60,num_ms,_model.surplusTxt];
    }
}

+ (CGSize)viewSize
{
    return CGSizeMake(ScreenW, 204);
}

@end
