//
//  JHStoreHomeSeckillHeader.m
//  TTjianbao
//
//  Created by lihui on 2020/3/10.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHStoreHomeSeckillHeader.h"
#import "JHStoreHomeCardModel.h"
///定时器相关
#import "YDCountDown.h"
#import "TTjianbao.h"
#import "YDCountDownManager.h"
#import "CommHelp.h"

NSString *const GoodsSeckillTimerSource = @"GoodsSeckillTimerSource";
NSString *const GoodsSeckillDelayTimerSource = @"GoodsSeckillDelayTimerSource";

@interface JHStoreHomeSeckillHeader ()

@property (nonatomic, strong) UIImageView *clockImageView;
@property (nonatomic, strong) UIImageView *seckillImageView;
@property (nonatomic, strong) UILabel *hourLabel;
@property (nonatomic, strong) UILabel *minuteLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UILabel *descLabel;

@property (nonatomic, strong) YDCountDown *countDown;
@property (nonatomic, strong) RACSignal *signal;

@end

@implementation JHStoreHomeSeckillHeader

+ (CGFloat)headerHeight {
    return 43;
}

- (void)setShowcaseModel:(JHStoreHomeShowcaseModel *)showcaseModel {
    if (!showcaseModel) {
        return;
    }
    _showcaseModel = showcaseModel;
    _descLabel.text = _showcaseModel.desc?:@"";
    ///定时器相关
    [self handleCountdownEvent];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        if (!_countDown) {
            _countDown = [[YDCountDown alloc] init];
        }
        [self initViews];
    }
    return self;
}

- (void)initViews {
    
    if (!_clockImageView) {
        _clockImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_store_home_clock"]];
        _clockImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_clockImageView];
    }
    
    if (!_seckillImageView) {
        _seckillImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_store_home_seckill"]];
        _seckillImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_seckillImageView];
    }
    
    if (!_hourLabel) {
        _hourLabel = [[UILabel alloc] init];
        _hourLabel.text = @"--";
        _hourLabel.textColor = HEXCOLOR(0xffffff);
        _hourLabel.backgroundColor = HEXCOLOR(0x333333);
        _hourLabel.textAlignment = NSTextAlignmentCenter;
        _hourLabel.font = [UIFont fontWithName:kFontNormal size:11];
        _hourLabel.layer.cornerRadius = 4.f;
        _hourLabel.layer.masksToBounds = YES;
        [self addSubview:_hourLabel];
    }
    
    if (!_minuteLabel) {
        _minuteLabel = [[UILabel alloc] init];
        _minuteLabel.text = @"--";
        _minuteLabel.textColor = HEXCOLOR(0xffffff);
        _minuteLabel.backgroundColor = HEXCOLOR(0x333333);
        _minuteLabel.textAlignment = NSTextAlignmentCenter;
        _minuteLabel.font = [UIFont fontWithName:kFontNormal size:11];
        _minuteLabel.layer.cornerRadius = 4.f;
        _minuteLabel.layer.masksToBounds = YES;
        [self addSubview:_minuteLabel];
    }
    
    if (!_secondLabel) {
        _secondLabel = [[UILabel alloc] init];
        _secondLabel.text = @"--";
        _secondLabel.textColor = HEXCOLOR(0xffffff);
        _secondLabel.backgroundColor = HEXCOLOR(0x333333);
        _secondLabel.textAlignment = NSTextAlignmentCenter;
        _secondLabel.font = [UIFont fontWithName:kFontNormal size:11];
        _secondLabel.layer.cornerRadius = 4.f;
        _secondLabel.layer.masksToBounds = YES;
        [self addSubview:_secondLabel];
    }
        
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.text = @"";
        _descLabel.textColor = HEXCOLOR(0x666666);
        _descLabel.font = [UIFont fontWithName:kFontNormal size:12];
        [self addSubview:_descLabel];
    }
    
    UILabel *colon1 = [[UILabel alloc] init];
    colon1.text = @":";
    colon1.font = [UIFont fontWithName:kFontNormal size:11];
    [self addSubview:colon1];

    UILabel *colon2 = [[UILabel alloc] init];
    colon2.text = @":";
    colon2.font = [UIFont fontWithName:kFontNormal size:11];
    [self addSubview:colon2];
    
    ///布局
    [_clockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.size.mas_equalTo(CGSizeMake(15, 15));
        make.centerY.equalTo(self);
    }];
    
    [_seckillImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.clockImageView.mas_right).offset(7);
        make.size.mas_equalTo(CGSizeMake(70, 18));
        make.centerY.equalTo(self);
    }];
    
    [_hourLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.seckillImageView.mas_right).offset(6);
        make.height.mas_equalTo(16);
        make.centerY.equalTo(self);
        make.width.greaterThanOrEqualTo(@(16));
    }];
    [_hourLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [_hourLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    [_minuteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hourLabel.mas_right).offset(7);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.equalTo(self);
    }];
    
    [_secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minuteLabel.mas_right).offset(7);
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.equalTo(self);
    }];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.secondLabel.mas_right).offset(5);
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-10);
    }];
    
    [colon1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.hourLabel.mas_right).offset(2);
        make.centerY.equalTo(self);
    }];

    [colon2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.minuteLabel.mas_right).offset(2);
        make.centerY.equalTo(self);
    }];
}

#pragma mark -
#pragma mark - 倒计时相关 - 添加通知

- (void)handleCountdownEvent {
      
    NSInteger beginTime = _showcaseModel.server_at.integerValue;
    
    NSInteger endTime = _showcaseModel.isEndCurrentSeckill ? _showcaseModel.next_offline_at.integerValue : _showcaseModel.offline_at.integerValue;
    if (![self isLegal:beginTime endTime:endTime]) {
        ///服务器时间大于结束时间
        [self showEndStyle];
        return;
    }
    ///修改开始时间和结束时间后 应该销毁定时器 然后重新开始
    [_countDown destoryTimer];

    NSString *endTimeString = [CommHelp stringWithTimeInterval:@(endTime*1000).stringValue formatter:@"yyyy-MM-dd HH:mm:ss"];
    int second = [CommHelp dateRemaining:endTimeString];
    if (second > 0) {
        @weakify(self);
        [_countDown startWithFinishTimeStamp:second completeBlock:^(NSInteger day, NSInteger hour, NSInteger minute, NSInteger second) {
            @strongify(self);
            NSInteger newHour = day*24+hour;
            [self setupTimeWithHour:newHour minute:minute second:second];
        }];
    }
    else{
        [self showEndStyle];
    }
}

///设置秒杀定时器UI数据
- (void)setupTimeWithHour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second {
    self.hourLabel.text = [NSString stringWithFormat:@"%02ld", (long)hour];
    self.minuteLabel.text = [NSString stringWithFormat:@"%02ld", (long)minute];
    self.secondLabel.text = [NSString stringWithFormat:@"%02ld", (long)second];
    if (hour == 0 && minute == 0 && second == 0) {
        if (self.showcaseModel.isEndCurrentSeckill) {  ///结束了当前场次
            [self showEndStyle];
            self.showcaseModel.isEndCurrentSeckill = NO;
            ///停止定时器
            [self.countDown destoryTimer];
        }
        else {
            self.showcaseModel.isEndCurrentSeckill = YES;
            ///通知cell更新数据
            [JHNotificationCenter postNotificationName:UpdateSeckillGoodsNotification object:nil];
            [self handleCountdownEvent];
        }
    }
    [self layoutIfNeeded];
}

- (void)showEndStyle {
    self.hourLabel.text = @"--";
    self.minuteLabel.text = @"--";
    self.secondLabel.text = @"--";
}

#pragma mark -
#pragma mark - private Methods
///判断结束时间是否大于开始时间
- (BOOL)isLegal:(long long)startTime endTime:(long long)endTime {
    if (endTime - startTime > 0) {
        return YES;
    }
    return NO;
}

- (void)dealloc {
    NSLog(@"首页秒杀列表header被释放！！！！！");
    ///退出界面需要销毁定时器
    [self.countDown destoryTimer];
    
}


@end
