//
//  JHStoneSendGoodsTimerView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/5/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHStoneSendGoodsTimerView.h"
#import "BYTimer.h"
@interface JHStoneSendGoodsTimerView ()
@property (nonatomic, strong) UILabel *hourLabel;
@property (nonatomic, strong) UILabel *minuteLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UIView *timeBackView;
@property (nonatomic, strong) BYTimer *timer;
@end

@implementation JHStoneSendGoodsTimerView

-(void)setSubViews{
    
      UILabel  *title=[[UILabel alloc]init];
      title.text=@"剩余时间";
      title.font=[UIFont fontWithName:kFontMedium size:15];
      title.backgroundColor=[UIColor clearColor];
      title.textColor=kColor333;
      title.numberOfLines = 1;
      title.textAlignment = UIControlContentHorizontalAlignmentCenter;
      title.lineBreakMode = NSLineBreakByWordWrapping;
      [self addSubview:title];
      [title mas_makeConstraints:^(MASConstraintMaker *make) {
          make.left.equalTo(self).offset(15);
          make.centerY.equalTo(self);
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
    _hourLabel.textColor = HEXCOLOR(0xFC4200);
    _hourLabel.backgroundColor = HEXCOLOR(0xFFEDE7);
    _hourLabel.textAlignment = NSTextAlignmentCenter;
    _hourLabel.font = [UIFont fontWithName:kFontNormal size:11];
    _hourLabel.layer.cornerRadius = 4.f;
    _hourLabel.layer.masksToBounds = YES;
    [self.timeBackView addSubview:_hourLabel];
    
    
    
    _minuteLabel = [[UILabel alloc] init];
    _minuteLabel.text = @"00";
    _minuteLabel.textColor = HEXCOLOR(0xFC4200);
    _minuteLabel.backgroundColor = HEXCOLOR(0xFFEDE7);
    _minuteLabel.textAlignment = NSTextAlignmentCenter;
    _minuteLabel.font = [UIFont fontWithName:kFontNormal size:11];
    _minuteLabel.layer.cornerRadius = 4.f;
    _minuteLabel.layer.masksToBounds = YES;
    [self.timeBackView addSubview:_minuteLabel];
    
    
    _secondLabel = [[UILabel alloc] init];
    _secondLabel.text = @"00";
    _secondLabel.textColor =  HEXCOLOR(0xFC4200);
    _secondLabel.backgroundColor = HEXCOLOR(0xFFEDE7);
    _secondLabel.textAlignment = NSTextAlignmentCenter;
    _secondLabel.font = [UIFont fontWithName:kFontNormal size:11];
    _secondLabel.layer.cornerRadius = 4.f;
    _secondLabel.layer.masksToBounds = YES;
    [self.timeBackView addSubview:_secondLabel];
    
    
    UILabel *colon1 = [[UILabel alloc] init];
    colon1.text = @":";
     colon1.textColor =  HEXCOLOR(0xFC4200);
    colon1.font = [UIFont fontWithName:kFontNormal size:11];
    [self.timeBackView addSubview:colon1];
    
    UILabel *colon2 = [[UILabel alloc] init];
    colon2.text = @":";
    colon2.textColor =  HEXCOLOR(0xFC4200);
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
    
}
-(void)setPayDeadline:(NSString *)payDeadline{
    
    _payDeadline=payDeadline;
    [_timer stopGCDTimer];
    _timer=nil;
    [self updateTime];
    [self addTimer];
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
    NSString *endTime = [CommHelp timeChange:self.payDeadline];
    if ([CommHelp dateRemaining:endTime]>0) {
        NSInteger second=[CommHelp dateRemaining:endTime];
        NSInteger hh = second/60/60;
        NSInteger mm = second/60%60;
        NSInteger ss = second%60;
        self.hourLabel.text=[NSString stringWithFormat:@"%02zd",hh];
        self.minuteLabel.text=[NSString stringWithFormat:@"%02zd",mm];
        self.secondLabel.text=[NSString stringWithFormat:@"%02zd",ss];
    }
    else{

        [_timer stopGCDTimer];
    }
}
- (void)dealloc
{
    [_timer stopGCDTimer];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
