//
//  JHSeckillPageTitleView.m
//  TTjianbao
//
//  Created by jiang on 2020/3/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSeckillPageTitleView.h"
#import "JHUIFactory.h"
#import "UIButton+ImageTitleSpacing.h"
#import "CommHelp.h"
#import "BYTimer.h"
@interface JHSeckillPageTitleView ()
@property (nonatomic, strong) UIView *buttonBack;
@property (nonatomic, strong) UIView *timeBackView;
@property (nonatomic, strong) UILabel *hourLabel;
@property (nonatomic, strong) UILabel *minuteLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) BYTimer *timer;

@end
@implementation JHSeckillPageTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor=[CommHelp  toUIColorByStr:@"#ffffff"];
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = NO;
        [self initTitleView];

    }
    
    return self;
}
- (void)initTitleView
{
    self.buttonBack=[UIView new];
    [self addSubview:self.buttonBack];
    [self.buttonBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(5);
        make.top.bottom.equalTo(self);
    }];
    
    NSArray *images=@[@"seckill_header_location",@"seckill_header_search",@"seckill_header_time"];
    NSArray *titles=@[@"源头批发",@"鉴定把关",@"限时低价"];
    UIButton * lastView;
    for (int i=0; i<[titles count]; i++) {
        UIButton * button = [[UIButton alloc]init];
        [button setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:[images objectAtIndex:i]] forState:UIControlStateNormal];
        button.titleLabel.font= [UIFont fontWithName:kFontNormal size:12];
        [button setTitleColor:kColor666 forState:UIControlStateNormal];
        [button setTitleColor:kColorMainRed forState:UIControlStateSelected];
        [self.buttonBack addSubview:button];
        button.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.buttonBack);
            make.height.offset(35);
            make.width.offset(70);
            if (i==0) {
                make.left.equalTo(self.buttonBack).offset(0);
            }
            else{
                make.left.equalTo(lastView.mas_right).offset(5);
            }
            if (i==titles.count-1) {
                make.right.equalTo(self.buttonBack.mas_right).offset(0);
            }
        }];
        [button layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleLeft
                                imageTitleSpace:5];
        lastView=button;
    }
    
    UIView * line=[[UIView alloc]init];
    line.backgroundColor=[CommHelp toUIColorByStr:@"#999999"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.buttonBack.mas_right).offset(10);
        make.top.equalTo(self).offset(15);
        make.bottom.equalTo(self).offset(-15);
        make.width.offset(1);
    }];
    
    self.timeBackView=[[UIView alloc]init];
    [self addSubview:self.timeBackView];
    [self.timeBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-10);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    
    _hourLabel = [[UILabel alloc] init];
    _hourLabel.text = @"00";
    _hourLabel.textColor = HEXCOLOR(0xffffff);
    _hourLabel.backgroundColor = HEXCOLOR(0x333333);
    _hourLabel.textAlignment = NSTextAlignmentCenter;
    _hourLabel.font = [UIFont fontWithName:kFontNormal size:11];
    _hourLabel.layer.cornerRadius = 4.f;
    _hourLabel.layer.masksToBounds = YES;
    [self.timeBackView addSubview:_hourLabel];
    
    
    
    _minuteLabel = [[UILabel alloc] init];
    _minuteLabel.text = @"00";
    _minuteLabel.textColor = HEXCOLOR(0xffffff);
    _minuteLabel.backgroundColor = HEXCOLOR(0x333333);
    _minuteLabel.textAlignment = NSTextAlignmentCenter;
    _minuteLabel.font = [UIFont fontWithName:kFontNormal size:11];
    _minuteLabel.layer.cornerRadius = 4.f;
    _minuteLabel.layer.masksToBounds = YES;
    [self.timeBackView addSubview:_minuteLabel];
    
    
    _secondLabel = [[UILabel alloc] init];
    _secondLabel.text = @"00";
    _secondLabel.textColor = HEXCOLOR(0xffffff);
    _secondLabel.backgroundColor = HEXCOLOR(0x333333);
    _secondLabel.textAlignment = NSTextAlignmentCenter;
    _secondLabel.font = [UIFont fontWithName:kFontNormal size:11];
    _secondLabel.layer.cornerRadius = 4.f;
    _secondLabel.layer.masksToBounds = YES;
    [self.timeBackView addSubview:_secondLabel];
    
    
    UILabel *colon1 = [[UILabel alloc] init];
    colon1.text = @":";
    colon1.font = [UIFont fontWithName:kFontNormal size:11];
    [self.timeBackView addSubview:colon1];
    
    UILabel *colon2 = [[UILabel alloc] init];
    colon2.text = @":";
    colon2.font = [UIFont fontWithName:kFontNormal size:11];
    [self.timeBackView addSubview:colon2];
    
    [_secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.timeBackView.mas_right).offset(0);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.equalTo(self.timeBackView);
    }];
    
    [_minuteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.secondLabel.mas_left).offset(-7);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.equalTo(self.timeBackView);
    }];
    
    [_hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.minuteLabel.mas_left).offset(-7);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.equalTo(self.timeBackView);
        make.left.equalTo(self.timeBackView);
    }];
    
    [colon1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hourLabel.mas_right).offset(2);
        make.centerY.equalTo(self.timeBackView);
    }];
    
    [colon2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minuteLabel.mas_right).offset(2);
        make.centerY.equalTo(self.timeBackView);
    }];
    
    _descLabel = [[UILabel alloc] init];
    _descLabel.text = @"距结束";
    _descLabel.textColor = HEXCOLOR(0x666666);
    _descLabel.textAlignment=NSTextAlignmentCenter;
    _descLabel.font = [UIFont fontWithName:kFontNormal size:12];
    [self addSubview:_descLabel];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.timeBackView.mas_left).offset(-5);
        make.centerY.equalTo(self);
    }];
    
}
//-(void)setSelectedIndex:(NSUInteger)selectedIndex{
//
//    _selectedIndex=selectedIndex;
//    if (_selectedIndex==0) {
//
//        self.timeBackView.hidden=NO;
//        self.descLabel.text = @"距结束";
//        [_descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//               make.right.equalTo(self.timeBackView.mas_left).offset(-5);
//               make.centerY.equalTo(self);
//           }];
//    }
//   else if (_selectedIndex==1) {
//
//         self.timeBackView.hidden=YES;
//         self.descLabel.text = @"12点准时开抢";
//         [_descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
//              make.right.equalTo(self).offset(-5);
//              make.left.equalTo(self.buttonBack.mas_right).offset(5);
//              make.centerY.equalTo(self);
//          }];
//    }
//}
-(void)setTitleMode:(JHSecKillTitleMode *)titleMode{
    
    _titleMode=titleMode;
    
    [_timer stopGCDTimer];
    
    NSTimeInterval nowTime=[[CommHelp getNowTimetampBySyncServeTime] doubleValue]/1000;
    
    if (nowTime<titleMode.online_at ) {
        [self countDown];
        self.timeBackView.hidden=YES;
        NSLog(@"mm==%@",[CommHelp timestampSwitchTime:titleMode.online_at andFormatter:@"mm"]);
        if ([[CommHelp timestampSwitchTime:titleMode.online_at andFormatter:@"mm"] integerValue]==0) {
            self.descLabel.text = [NSString stringWithFormat:@"%@点准时开抢",[CommHelp timestampSwitchTime:titleMode.online_at andFormatter:@"HH"]];
        }
        else{
            self.descLabel.text = [NSString stringWithFormat:@"%@点准时开抢",[CommHelp timestampSwitchTime:titleMode.online_at andFormatter:@"HH:mm"]];
        }
        [_descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-5);
            make.left.equalTo(self.buttonBack.mas_right).offset(5);
            make.centerY.equalTo(self);
        }];

    }
    if (nowTime>=titleMode.online_at&&nowTime<titleMode.offline_at ) {
        
        self.timeBackView.hidden=NO;
        self.descLabel.text = JHLocalizedString(@"distanceForEnd");
        [self updateTime];
        [self addTimer];
        [_descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.timeBackView.mas_left).offset(-5);
            make.centerY.equalTo(self);
        }];
    }
    
    if (nowTime>=titleMode.offline_at ) {
           self.timeBackView.hidden=YES;
           self.descLabel.text = JHLocalizedString(@"finished");
           [_descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
               make.right.equalTo(self).offset(-5);
               make.left.equalTo(self.buttonBack.mas_right).offset(5);
               make.centerY.equalTo(self);
           }];
       }
    
}
-(void)countDown{
    
    if (_timer) {
        [_timer stopGCDTimer];
    }
    _timer=[[BYTimer alloc]init];
    JH_WEAK(self)
    [_timer startGCDTimerOnMainQueueWithInterval:1 Blcok:^{
        JH_STRONG(self)
        NSTimeInterval nowTime=[[CommHelp getNowTimetampBySyncServeTime] doubleValue]/1000;
        if (nowTime>self.titleMode.online_at ) {
            [self.timer stopGCDTimer];
            if (self.beginBlock) {
                self.beginBlock();
            }
        }
        
    }];
}
-(void)addTimer
{
    JH_WEAK(self)
    if (_timer) {
        [_timer stopGCDTimer];
    }
     _timer=[[BYTimer alloc]init];
    [_timer startGCDTimerOnMainQueueWithInterval:1 Blcok:^{
        JH_STRONG(self)
        [self updateTime];
    }];
    
}
-(void)updateTime
{
    if ([CommHelp dateRemaining:self.titleMode.ft_offline_at]>0) {
        NSInteger second=[CommHelp dateRemaining:self.titleMode.ft_offline_at];
        NSInteger hh = second/60/60;
        NSInteger mm = second/60%60;
        NSInteger ss = second%60;
        self.hourLabel.text=[NSString stringWithFormat:@"%02zd",hh];
        self.minuteLabel.text=[NSString stringWithFormat:@"%02zd",mm];
        self.secondLabel.text=[NSString stringWithFormat:@"%02zd",ss];
    }
    else{
        
        [_timer stopGCDTimer];
        self.timeBackView.hidden=YES;
        self.descLabel.text = JHLocalizedString(@"finished");
        [_descLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-5);
            make.left.equalTo(self.buttonBack.mas_right).offset(5);
            make.centerY.equalTo(self);
        }];
        if (self.timeEndBlock) {
            self.timeEndBlock();
        }
    }
}
- (void)dealloc
{
    [_timer stopGCDTimer];
}
@end
