//
//  JHPickupDatePickerView.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/30.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
#define PickerHeight    335
#define PickerHeaderHeight   50
#define PickerDateHeight   225
#define OneDayTime   24*60*60

typedef void(^DateChooseBlock)(NSString *startTime, NSString *endTime, NSString *showDate);
#import "JHPickupDatePickerView.h"
#import "UIImage+JHColor.h"

@interface JHPickupDatePickerView ()<UIGestureRecognizerDelegate>
{
    NSInteger currentMonth;
    NSInteger currentDay;
    NSInteger currentHour;
}
@property (nonatomic, copy) DateChooseBlock chooseBlock;
@property (nonatomic, strong) UIView *buttomView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *dateView;
@property (nonatomic, strong) UIButton *chooseButton;

@property (nonatomic, strong) UIButton *currentDaySelectedBtn;
@property (nonatomic, strong) UIButton *currentTimeSelectedBtn;

@property (nonatomic, strong) UIView *timeView ;
@property (nonatomic, strong) UIImageView *selectImg;

@property (nonatomic, strong) NSArray *dayTextArray;
@property (nonatomic, strong) NSArray *yearArray;//年月日
@property (nonatomic, copy) NSString *selectDayStr;//选择的日期
@property (nonatomic, copy) NSString *selectYearStr;//选择的年

@property (nonatomic, strong) NSArray *timeArray;//时间段
@property (nonatomic, copy) NSString *selectTimeStr;//选择的时间段

@property (nonatomic, assign) int useableIndex;

@end

@implementation JHPickupDatePickerView

- (instancetype)initWithDatePickerViewCompleteBlock:(void (^)(NSString * _Nonnull, NSString * _Nonnull, NSString * _Nonnull))completeBlock{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
        self.backgroundColor = [UIColor clearColor];
        [self setupUI];
        [self setupDateDayViewUI];
        if (completeBlock) {
//            self.chooseBlock = ^(NSString *selectDate) {
//                completeBlock(selectDate);
//            };
            self.chooseBlock = ^(NSString *startTime, NSString *endTime, NSString *showDate) {
                completeBlock(startTime, endTime, showDate);
            };
        }
    }
    return self;
}

- (void)setupUI{
    //获取当前时间
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comps  = [calendar components:unitFlags fromDate:[NSDate date]];
    currentMonth = [comps month];
    currentDay = [comps day];
    currentHour = [comps hour];

    [self addSubview:self.buttomView];
    [self.buttomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).offset(0);
        make.left.right.equalTo(self);
        make.height.mas_equalTo(PickerHeight+UI.bottomSafeAreaHeight);
    }];
    [self layoutIfNeeded];
    [self.buttomView jh_cornerRadius:8.0 rectCorner:UIRectCornerTopLeft|UIRectCornerTopRight bounds:self.buttomView.bounds];

    //点击背景是否隐藏
    UIView *tapView = [[UIView alloc] init];
    tapView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-PickerHeight-UI.bottomSafeAreaHeight);
    [self addSubview:tapView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [tapView addGestureRecognizer:tap];

    //标题
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, PickerHeaderHeight)];
    headerView.backgroundColor = UIColor.whiteColor;
    [self.buttomView addSubview:headerView];
    [headerView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(headerView);
    }];
    //取消
    [headerView addSubview:self.cancelButton];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headerView).offset(-8);
        make.centerY.equalTo(headerView);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];

    //时间选择
    [self.buttomView addSubview:self.dateView];
    [self.dateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.left.right.equalTo(headerView);
        make.height.mas_equalTo(PickerDateHeight);
    }];
    
    //确定
    [self.buttomView addSubview:self.chooseButton];
    [self.chooseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateView.mas_bottom).offset(8);
        make.left.equalTo(self.dateView).offset(38);
        make.right.equalTo(headerView).offset(-38);
        make.height.mas_equalTo(44);
    }];


}

- (void)setupDateDayViewUI{
    UIView *dayView = [[UIView alloc] init];
    dayView.frame = CGRectMake(0, 0, 140, 152);
    dayView.backgroundColor = UIColor.whiteColor;
    [self.dateView addSubview:dayView];

    //年月日
    NSString *todayTimeStr = [self getTimeStrWithString:[self currentDateStr]];
    //今天
    NSString *today = [[self currentDateStr] substringFromIndex:5];
    NSString *prefixToday = [today substringToIndex:1];
    if ([prefixToday isEqualToString:@"0"]) {
        today = [today substringFromIndex:1];
    }
    //明天
    long timeNum1 = [todayTimeStr longValue] + OneDayTime;
    NSString *tomorrow = [[self getDateStringWithTimeStr:[NSString stringWithFormat:@"%ld",timeNum1]] substringFromIndex:5];
    NSString *prefixTomorrow = [tomorrow substringToIndex:1];
    if ([prefixTomorrow isEqualToString:@"0"]) {
        tomorrow = [tomorrow substringFromIndex:1];
    }
    //后天
    long timeNum2 = [todayTimeStr longValue] + 2*OneDayTime;
    NSString *acquired = [[self getDateStringWithTimeStr:[NSString stringWithFormat:@"%ld",timeNum2]] substringFromIndex:5];
    NSString *prefixAcquired= [acquired substringToIndex:1];
    if ([prefixAcquired isEqualToString:@"0"]) {
        acquired = [acquired substringFromIndex:1];
    }
    
    self.yearArray = @[[self currentDateStr],[self getDateStringWithTimeStr:[NSString stringWithFormat:@"%ld",timeNum1]], [self getDateStringWithTimeStr:[NSString stringWithFormat:@"%ld",timeNum2]]];
                                              
    self.dayTextArray = @[@"今天",@"明天",@"后天"];
    NSArray *dayArray = @[today,tomorrow,acquired];
    if (!_currentDaySelectedBtn) {
        _currentDaySelectedBtn = [[UIButton alloc] init];
    }
    for (int i = 0; i < self.dayTextArray.count; ++i) {
        UIButton *dayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [dayBtn setTitle:self.dayTextArray[i] forState:UIControlStateNormal];
        [dayBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        dayBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:14];
        [dayBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xFFFFFF)] forState:UIControlStateSelected];
        [dayBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xF2F2F2)] forState:UIControlStateNormal];
        [dayBtn setBackgroundImage:[UIImage imageWithColor:HEXCOLOR(0xFFFFFF)] forState:UIControlStateHighlighted];
        dayBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        dayBtn.contentEdgeInsets = UIEdgeInsetsMake(6, 0, 0, 0);
        dayBtn.tag = 1100 + i;
        [dayBtn addTarget:self action:@selector(clickDayBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [dayView addSubview:dayBtn];
        dayBtn.frame = CGRectMake(0, (50+1)*i, 140, 50);

        //默认第一个标签选中，且不可点击
        if (i == 0) {
            dayBtn.selected = YES;
            dayBtn.userInteractionEnabled = NO;
            self.currentDaySelectedBtn = dayBtn;
        }else{
            dayBtn.selected = NO;
        }
        
        for (int i = 0; i < self.dayTextArray.count; ++i) {
            UILabel *dayLabel = [[UILabel alloc] init];
            dayLabel.textAlignment = NSTextAlignmentCenter;
            dayLabel.text = dayArray[i];
            dayLabel.textColor = HEXCOLOR(0x999999);
            dayLabel.font = [UIFont fontWithName:kFontNormal size:12];
            [dayView addSubview:dayLabel];
            dayLabel.frame = CGRectMake(0, 28+(50+1)*i, 140, 17);
            dayLabel.backgroundColor = UIColor.clearColor;
        }
        
    }
    self.selectDayStr = self.dayTextArray[0];//默认日期第一行
    self.selectYearStr = self.yearArray[0];
    [self setupDateTimeViewUI];

}

- (void)setupDateTimeViewUI{
    [self.dateView addSubview:self.timeView];
    [self.timeView removeAllSubviews];
    self.useableIndex = 0;

    NSArray *timeNumArr = @[@"11",@"13",@"15",@"17"];
    self.timeArray = @[@"09:00-11:00",@"11:00-13:00",@"13:00-15:00",@"15:00-17:00"];
    if (!_currentTimeSelectedBtn) {
        _currentTimeSelectedBtn = [[UIButton alloc] init];
    }
    for (int i = 0; i < self.timeArray.count; ++i) {
        UIButton *timeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [timeBtn setTitle:self.timeArray[i] forState:UIControlStateNormal];
//        [timeBtn setTitleColor:HEXCOLOR(0xFF4200) forState:UIControlStateSelected];
        timeBtn.titleLabel.font = [UIFont fontWithName:kFontNormal size:14];
        timeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        timeBtn.tag = 1100 + i;
        [timeBtn addTarget:self action:@selector(clickTimeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.timeView addSubview:timeBtn];
        timeBtn.frame = CGRectMake(20, (50+1)*i, kScreenWidth-140-90, 50);

        
        
        //只有是“今天”时才会判断是否过时
        if ([self.dayTextArray[0] isEqualToString:self.selectDayStr]) {
            //当前时间是否过时
            if ([timeNumArr[i] intValue] <= (long)currentHour) {//已过时
                [timeBtn setTitleColor:HEXCOLOR(0x999999) forState:UIControlStateNormal];
                timeBtn.selected = NO;
                timeBtn.userInteractionEnabled = NO;
                //显示“时段已过”
                UILabel *outdateLabel = [[UILabel alloc] init];
                outdateLabel.textAlignment = NSTextAlignmentRight;
                outdateLabel.text = @"时段已过";
                outdateLabel.textColor = HEXCOLOR(0x999999);
                outdateLabel.font = [UIFont fontWithName:kFontNormal size:12];
                [self.timeView addSubview:outdateLabel];
                outdateLabel.frame = CGRectMake(kScreenWidth-140-48-15, 17+i*51, 48, 17);
                self.useableIndex ++;
            }else{//未过时：按钮可点
                [timeBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
                if (i == self.useableIndex) {
                    timeBtn.selected = YES;
                    timeBtn.userInteractionEnabled = NO;
                    self.currentTimeSelectedBtn = timeBtn;
                    
                    [self.timeView addSubview:self.selectImg];
                    [self.selectImg mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.timeView).offset(17+i*51);
                        make.right.equalTo(self.timeView).offset(-28);
                        make.size.mas_equalTo(CGSizeMake(16, 16));
                    }];
                }else{
                    timeBtn.selected = NO;
                }
                self.selectTimeStr = self.timeArray[self.useableIndex];//默认时间段第一行
                
            }
        }else{
            [timeBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
            //默认第一个标签选中，且不可点击
            if (i == 0) {
                timeBtn.selected = YES;
                timeBtn.userInteractionEnabled = NO;
                self.currentTimeSelectedBtn = timeBtn;
                [self.timeView addSubview:self.selectImg];
                [self.selectImg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.timeView).offset(17+i*51);
                    make.right.equalTo(self.timeView).offset(-28);
                    make.size.mas_equalTo(CGSizeMake(16, 16));
                }];
            }else{
                timeBtn.selected = NO;
            }
            
            self.selectTimeStr = self.timeArray[0];//默认时间段第一行

        }
       
    }
    
}


#pragma mark - Action
///日
- (void)clickDayBtnAction:(UIButton *)sender{
    self.currentDaySelectedBtn.selected = NO;
    self.currentDaySelectedBtn.userInteractionEnabled = YES;
    sender.selected = YES;
    sender.userInteractionEnabled = NO;
    self.currentDaySelectedBtn = sender;
    
    NSInteger index = sender.tag - 1100;
    //选择的日期
    self.selectDayStr = self.dayTextArray[index];
    self.selectYearStr = self.yearArray[index];
    
    //时间清空
    self.selectTimeStr = @"";
        
    [self setupDateTimeViewUI];
   
}
///时
- (void)clickTimeBtnAction:(UIButton *)sender{
    self.currentTimeSelectedBtn.selected = NO;
    self.currentTimeSelectedBtn.userInteractionEnabled = YES;
    sender.selected = YES;
    sender.userInteractionEnabled = NO;
    self.currentTimeSelectedBtn = sender;
    
    NSInteger index = sender.tag - 1100;
    [self.selectImg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeView).offset(17 + index*51);
    }];
    //选择的时间段
    self.selectTimeStr = self.timeArray[index];
       
}

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.3 animations:^{
        [self.buttomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom).offset(-(PickerHeight+UI.bottomSafeAreaHeight));
        }];
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
    }];
}
- (void)dismiss {
    [UIView animateWithDuration:0.3 animations:^{
        [self.buttomView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom).offset(0);
        }];
        self.backgroundColor = RGBA(0, 0, 0, 0);
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}
- (void)clicikCancelButtonAction{
    [self dismiss];
}
     
- (void)clicikChooseButtonAction{
    if (self.chooseBlock) {
        if (self.selectDayStr.length > 0 && self.selectTimeStr.length > 0) {
            NSArray *timeArray = [self.selectTimeStr componentsSeparatedByString:@"-"];
            NSString *newYearStr = [self convertNewDateWithOtherDateString:self.selectYearStr];
            NSString *startStr = [NSString stringWithFormat:@"%@ %@",newYearStr, timeArray[0]];
            NSString *endStr = [NSString stringWithFormat:@"%@ %@",newYearStr, timeArray[1]];
            
            self.chooseBlock(startStr, endStr, [NSString stringWithFormat:@"%@ %@",self.selectDayStr, self.selectTimeStr]);

            [self dismiss];
        }else{
            JHTOAST(@"请选择合适的时间");
        }
    }
   
}
     
     
#pragma mark - Lazy
- (UIView *)buttomView{
    if (!_buttomView) {
        _buttomView = [[UIView alloc] init];
        _buttomView.backgroundColor = UIColor.whiteColor;
    }
    return _buttomView;
}
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = @"预约上门时间";
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.font = [UIFont fontWithName:kFontNormal size:17];
    }
    return _titleLabel;
}
- (UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setImage:JHImageNamed(@"recycle_pickup_close_icon") forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(clicikCancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _cancelButton.contentEdgeInsets = UIEdgeInsetsMake(8, 8, 8, 8);
    }
    return _cancelButton;
}
- (UIView *)dateView{
    if (!_dateView) {
        _dateView = [[UIView alloc] init];
        _dateView.backgroundColor =  HEXCOLOR(0xF2F2F2);
    }
    return _dateView;
}
- (UIButton *)chooseButton{
    if (!_chooseButton) {
        _chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *colorImg = [UIImage gradientThemeImageSize:CGSizeMake(kScreenWidth-76, 44) radius:22];
        [_chooseButton setBackgroundImage:colorImg forState:UIControlStateNormal];
        [_chooseButton setTitle:@"确定" forState:UIControlStateNormal];
        [_chooseButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        _chooseButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
        [_chooseButton addTarget:self action:@selector(clicikChooseButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseButton;
}

- (UIImageView *)selectImg{
    if (!_selectImg) {
        _selectImg = [[UIImageView alloc] init];
        _selectImg.image = JHImageNamed(@"recycle_pickup_selected_icon");
    }
    return _selectImg;
}
    
- (UIView *)timeView{
    if (!_timeView) {
        _timeView = [[UIView alloc] init];
        _timeView.frame = CGRectMake(140, 0, kScreenWidth-140, PickerDateHeight);
        _timeView.backgroundColor =  UIColor.whiteColor;
    }
    return _timeView;
}

//获取当前时间
- (NSString *)currentDateStr{
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];//将时间转化成字符串
    return dateString;
}
//时间戳转时间
- (NSString *)getDateStringWithTimeStr:(NSString *)str{
    NSTimeInterval time = [str doubleValue];
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}
//字符串转时间戳
- (NSString *)getTimeStrWithString:(NSString *)str{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSDate *tempDate = [dateFormatter dateFromString:str];
    NSString *timeStr = [NSString stringWithFormat:@"%ld", (long)[tempDate timeIntervalSince1970]];//字符串转成时间戳
    return timeStr;
}
//yyyy年MM月dd日 -> yyyy-MM-dd
- (NSString *)convertNewDateWithOtherDateString:(NSString *)str {
    NSString *timeStr = [self getTimeStrWithString:str];//字符串转成时间戳
    NSTimeInterval time = [timeStr doubleValue];
    NSDate *detailDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDateStr = [dateFormatter stringFromDate: detailDate];
    return currentDateStr;
}
@end
