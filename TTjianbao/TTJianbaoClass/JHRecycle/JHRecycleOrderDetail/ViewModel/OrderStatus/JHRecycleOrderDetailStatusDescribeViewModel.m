//
//  JHRecycleOrderDetailStatusDescribeViewModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderDetailStatusDescribeViewModel.h"
#import "JHRecycleOrderDetailStatusManager.h"

@interface JHRecycleOrderDetailStatusDescribeViewModel()
@property (nonatomic, assign) BOOL isStartCountDown;
/// 订单状态
@property (nonatomic, strong) JHRecycleOrderDetailStatusManager *statusManager;

@end
@implementation JHRecycleOrderDetailStatusDescribeViewModel
#pragma mark - Life Cycle Functions
- (instancetype)init{
    self = [super init];
    if (self) {
        [self setupData];
    }
    return self;
}
- (void)dealloc {
    NSLog(@"回收订单详情-%@ 释放", [self class]);
}

#pragma mark - Public Functions
- (void)setupDataWithDesc : (NSString *) desc time : (NSInteger) time {
    self.describeText = desc;
    if (time > 0) {
        self.countdownTime = time;
        [self setupCountDownTime:self.countdownTime];
    }else {
        [self setupHeight];
    }
}
#pragma mark - Private Functions
- (void)setupData {
    self.cellType = RecycleOrderDetailStatusDescribeCell;
}

/// 开始倒计时
- (void)startCountdown {
    if (self.countdownTime < 0) { return; }
    self.isStartCountDown = true;
    RACSignal *timerSignal = [RACSignal interval:1.0f onScheduler:[RACScheduler mainThreadScheduler]];
    //定时器总时间3秒
    timerSignal = [timerSignal take:self.countdownTime];
    @weakify(self)
    [timerSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.countdownTime--;
        [self setupCountDownTime:self.countdownTime];
    } completed:^{
        @strongify(self)
        self.describeText = @"";
        [self.reloadData sendNext:nil];
    }];
}
///设置倒计时时间，timeValue是未经转换的总秒数
- (void)setupCountDownTime:(NSInteger)timeValue {
    NSInteger hh = (timeValue/3600)%24;
    NSInteger mm = (timeValue%3600)/60;
    NSInteger ss = timeValue%60;
    NSInteger dd = (timeValue/3600)/24;
    [self setDD:dd hh:hh mm:mm ss:ss];
}
///单独设置倒计时的时分秒
- (void)setDD:(NSInteger)ddValue hh:(NSInteger)hhValue mm:(NSInteger)mmValue ss:(NSInteger)ssValue {
    NSMutableAttributedString *hours = [self getAttTextWithTime:hhValue format:@"时"];
    NSAttributedString *minutes = [self getAttTextWithTime:mmValue format:@"分"];
    NSAttributedString *seconds = [self getAttTextWithTime:ssValue format:@"秒"];
    
    NSDictionary *dict = @{NSForegroundColorAttributeName : HEXCOLOR(0x666666),
                           NSFontAttributeName : [UIFont fontWithName:kFontNormal size:12]};
    
    NSAttributedString *att = [[NSAttributedString alloc]
                               initWithString:self.describeText
                               attributes:dict];
    
    [hours appendAttributedString:minutes];
    [hours appendAttributedString:seconds];
    [hours appendAttributedString:att];

    self.attDescribeText = hours;
    [self setupAttHeight];
}
- (NSMutableAttributedString *)getAttTextWithTime : (NSInteger)time format : (NSString *)format{
    NSString *newTime = [NSString stringWithFormat:@"%02ld", (long)time];
    
    NSDictionary *timeDict = @{NSForegroundColorAttributeName : HEXCOLOR(0xf8461f),
                               NSFontAttributeName : [UIFont fontWithName:kFontNormal size:12]};
    NSDictionary *formatDict = @{NSForegroundColorAttributeName : HEXCOLOR(0x666666),
                                 NSFontAttributeName : [UIFont fontWithName:kFontNormal size:12]};
    
    NSMutableAttributedString *attTime = [[NSMutableAttributedString alloc]
                                          initWithString:newTime
                                          attributes: timeDict];
    NSAttributedString *attFormat = [[NSAttributedString alloc]
                                     initWithString:format
                                     attributes:formatDict];
    
    [attTime appendAttributedString:attFormat];
    return attTime;
}

// 设置高度 - 倒计时
- (void)setupAttHeight {
    if (self.height > 0) { return; }
    [self setupAttTextHeight];
}
- (void)setupAttTextHeight {
    CGFloat height = [self getAttTextHeightWithAtt:self.attDescribeText];
    self.height = height + 38 - 18;
}
- (CGFloat)getAttTextHeightWithAtt : (NSAttributedString *)text {
    CGFloat width = ScreenW - LeftSpace * 2 - ContentLeftSpace * 2;
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:CGSizeMake(width, MAXFLOAT) text: text];
    return layout.textBoundingSize.height;
}
// 设置高度 - 一般文本
- (void)setupHeight {
    if (self.describeText == nil) {
        self.height = 38;
        return;
    }
    CGFloat width = ScreenW - LeftSpace * 2 - ContentLeftSpace * 2;
    CGFloat height = [self.describeText heightForFont:[UIFont fontWithName:kFontNormal size:RecycleOrderDescribeFontSize] width:width];
    self.height = height + 38 - 15;
}
#pragma mark - Lazy
- (void)setDescribeText:(NSString *)describeText {
    _describeText = describeText;
}
- (void)setAttDescribeText:(NSAttributedString *)attDescribeText {
    if (attDescribeText != nil) {
        _attDescribeText = attDescribeText;
    }
}

- (void)setCountdownTime:(NSInteger)countdownTime {
    _countdownTime = countdownTime;
    if (countdownTime <= 0) return;
    if (self.isStartCountDown == true) { return; }
    [self startCountdown];
}
- (JHRecycleOrderDetailStatusManager *)statusManager {
    if (!_statusManager) {
        _statusManager = [[JHRecycleOrderDetailStatusManager alloc] init];
    }
    return _statusManager;
}
@end
