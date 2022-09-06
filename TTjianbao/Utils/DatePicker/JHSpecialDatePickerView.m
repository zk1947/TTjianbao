//
//  JHSpecialDatePickerView.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/1/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#define PickerHeight    200
#define PickerRowHeight   40
#define PickerHeaderHeight   44
#define PickerTextFont   15.0
#define UIColorFromRGB(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "JHSpecialDatePickerView.h"

typedef void(^doneBlock)(NSString *date);

@interface JHSpecialDatePickerView()<UIGestureRecognizerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{
    NSInteger yearRange;
    NSInteger dayRange;
    NSInteger startYear;
    NSInteger selectedYear;
    NSInteger selectedMonth;
    NSInteger selectedDay;
    NSInteger selectedHour;
    NSInteger selectedMinute;
    NSInteger selectedSecond;
    //左边退出按钮
    UIButton *cancelButton;
    //右边的确定按钮
    UIButton *chooseButton;
}
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSString *dateString;
@property (nonatomic, copy) doneBlock doneBlock;
@property (nonatomic, assign) JHDatePickerViewDateType pickerViewMode;

@end

@implementation JHSpecialDatePickerView

- (instancetype)initWithDateStyle:(JHDatePickerViewDateType)datePickerStyle completeBlock:(void(^)(NSString *dateString))completeBlock{
    if (self = [super init]) {
        self.pickerViewMode = datePickerStyle;

        [self setupUI];
        if (completeBlock) {
            self.doneBlock = ^(NSString *selectDate) {
                completeBlock(selectDate);
            };
        }

    }
    return self;
}
- (void)setupUI{
        
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    self.backgroundColor = [UIColor clearColor];
   
    self.buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, PickerHeight+PickerHeaderHeight)];
    self.buttomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.buttomView];
                       
    //点击背景是否影藏
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismiss)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];

    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self];


    //盛放按钮的View
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, PickerHeaderHeight)];
    headerView.backgroundColor = RGBA(0, 0, 0, 0.1);
    [self.buttomView addSubview:headerView];

//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - 70 * 2, PickerHeaderHeight)];
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    titleLabel.center = headerView.center;
//    titleLabel.text = @"请选择日期";
//    titleLabel.font = [UIFont systemFontOfSize:15];
//    titleLabel.textColor = UIColor.blackColor;
//    [headerView addSubview:titleLabel];
    
    //左边的取消按钮
    cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(12, 0, 40, PickerHeaderHeight);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor clearColor];
    cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelButton setTitleColor:UIColorFromRGB(0x0d8bf5) forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:cancelButton];

    //右边的确定按钮
    chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    chooseButton.frame = CGRectMake(kScreenWidth - 52, 0, 40, PickerHeaderHeight);
    [chooseButton setTitle:@"确定" forState:UIControlStateNormal];
    chooseButton.backgroundColor = [UIColor clearColor];
    chooseButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [chooseButton setTitleColor:UIColorFromRGB(0x0d8bf5) forState:UIControlStateNormal];
    [chooseButton addTarget:self action:@selector(configButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:chooseButton];
    

    self.pickerView = [[UIPickerView alloc]init];
    self.pickerView.frame = CGRectMake(0, PickerHeaderHeight, kScreenWidth, PickerHeight);
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    [self.buttomView addSubview:self.pickerView];
    


    NSCalendar *calendar0 = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comps  = [calendar0 components:unitFlags fromDate:[NSDate date]];
    NSInteger year = [comps year];

    startYear = year-1;
    yearRange = 10;
    [self setCurrentDate:[NSDate date]];
}
#pragma mark - Action
- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat buttomViewHeight = PickerHeight + PickerHeaderHeight;
        self.buttomView.frame = CGRectMake(0, kScreenHeight - buttomViewHeight, kScreenWidth, buttomViewHeight);
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
        [self layoutIfNeeded];
    }];
}
- (void)dismiss {
    [UIView animateWithDuration:0.25 animations:^{
        CGFloat buttomViewHeight = PickerHeight + PickerHeaderHeight;
        self.buttomView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, buttomViewHeight);
        self.backgroundColor = RGBA(0, 0, 0, 0);
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self removeFromSuperview];
    }];
}


- (void)cancelButtonClick{
    
    [self dismiss];
}

- (void)configButtonClick{
    if (self.doneBlock) {
        self.doneBlock(_dateString);
    }
    [self dismiss];
    
}

//默认时间的处理
-(void)setCurrentDate:(NSDate *)currentDate
{
    //获取当前时间
    NSCalendar *calendar0 = [NSCalendar currentCalendar];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comps  = [calendar0 components:unitFlags fromDate:[NSDate date]];
    
    NSInteger year = [comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    NSInteger hour = [comps hour];
    NSInteger minute = [comps minute];
    NSInteger second = [comps second];
    
    selectedYear = year;
    selectedMonth = month;
    selectedDay = day;
    selectedHour = hour;
    selectedMinute = minute;
    selectedSecond  = second;
    
    dayRange = [self isAllDay:year andMonth:month];
    

    [self.pickerView selectRow:year-startYear inComponent:0 animated:NO];
    [self.pickerView selectRow:month-1 inComponent:1 animated:NO];
    [self.pickerView selectRow:day-1 inComponent:2 animated:NO];
    [self.pickerView selectRow:hour inComponent:3 animated:NO];
    
    [self pickerView:self.pickerView didSelectRow:year-startYear inComponent:0];
    [self pickerView:self.pickerView didSelectRow:month-1 inComponent:1];
    [self pickerView:self.pickerView didSelectRow:day-1 inComponent:2];
    [self pickerView:self.pickerView didSelectRow:hour inComponent:3];
     
    [self.pickerView reloadAllComponents];
}

#pragma mark - 选择对应月份的天数
-(NSInteger)isAllDay:(NSInteger)year andMonth:(NSInteger)month
{
    int day = 0;
    switch(month)
    {
        case 1:
        case 3:
        case 5:
        case 7:
        case 8:
        case 10:
        case 12:
            day = 31;
            break;
        case 4:
        case 6:
        case 9:
        case 11:
            day = 30;
            break;
        case 2:
        {
            if(((year%4==0)&&(year%100!=0))||(year%400==0))
            {
                day = 29;
                break;
            }
            else
            {
                day = 28;
                break;
            }
        }
        default:
            break;
    }
    return day;
}

#pragma mark -- UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (self.pickerViewMode == JHDatePickerViewDateTypeYearMonthDayHourMinuteMode) {
        return 5;
    }else if (self.pickerViewMode == JHDatePickerViewDateTypeYearMonthDayHourMinuteSecondMode){
        return 6;
    }
    else if (self.pickerViewMode == JHDatePickerViewDateTypeYearMonthDayHourMode){
        return 4;
    }
    else if (self.pickerViewMode == JHDatePickerViewDateTypeYearMonthDayMode){
        return 3;
    }
    else if (self.pickerViewMode == JHDatePickerViewDateTypeYearMonthMode){
        return 2;
    }
    else if (self.pickerViewMode == JHDatePickerViewDateTypeYearMode){
        return 1;
    }
    return 0;
}

//确定每一列返回的东西
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.pickerViewMode == JHDatePickerViewDateTypeYearMonthDayHourMinuteMode) {
        switch (component) {
            case 0:
            {
                return yearRange;
            }
                break;
            case 1:
            {
                return 12;
            }
                break;
            case 2:
            {
                return dayRange;
            }
                break;
            case 3:
            {
                return 24;
            }
                break;
            case 4:
            {
                return 60;
            }
                break;
                
            default:
                break;
        }
    }else if (self.pickerViewMode == JHDatePickerViewDateTypeYearMonthDayHourMinuteSecondMode){
        switch (component) {
            case 0:
            {
                return yearRange;
            }
                break;
            case 1:
            {
                return 12;
            }
                break;
            case 2:
            {
                return dayRange;
            }
                break;
            case 3:
            {
                return 24;
            }
                break;
            case 4:
            {
                return 60;
            }
                break;
                
            case 5:
            {
                return 60;
            }
                break;
                
            default:
                break;
        }
    }
    else if (self.pickerViewMode == JHDatePickerViewDateTypeYearMonthDayHourMode){
        switch (component) {
            case 0:
            {
                return yearRange;
            }
                break;
            case 1:
            {
                return 12;
            }
                break;
            case 2:
            {
                return dayRange;
            }
                break;
            case 3:
            {
                return 24;
            }
                break;
            default:
                break;
        }
    }
    else if (self.pickerViewMode == JHDatePickerViewDateTypeYearMonthDayMode){
        switch (component) {
            case 0:
            {
                return yearRange;
            }
                break;
            case 1:
            {
                return 12;
            }
                break;
            case 2:
            {
                return dayRange;
            }
                break;
            default:
                break;
        }
    }
    else if (self.pickerViewMode == JHDatePickerViewDateTypeYearMonthMode){
        switch (component) {
            case 0:
            {
                return yearRange;
            }
                break;
            case 1:
            {
                return 12;
            }
                break;
       
            default:
                break;
        }
    }
    else if (self.pickerViewMode == JHDatePickerViewDateTypeYearMode){
        switch (component) {
            case 0:
            {
                return yearRange;
            }
                break;
                
            default:
                break;
        }
    }
    return 0;
}

#pragma mark -- UIPickerViewDelegate

-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel*label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:PickerTextFont];
    label.textAlignment = NSTextAlignmentCenter;
   
    if (self.pickerViewMode == JHDatePickerViewDateTypeYearMonthDayHourMinuteMode) {
        switch (component) {
            case 0:
            {
                label.text = [NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
            }
                break;
            case 1:
            {
                label.text = [NSString stringWithFormat:@"%ld月",(long)row+1];
            }
                break;
            case 2:
            {
                
                label.text = [NSString stringWithFormat:@"%ld日",(long)row+1];
            }
                break;
            case 3:
            {
                label.text = [NSString stringWithFormat:@"%ld时",(long)row];
            }
                break;
            case 4:
            {
                label.text = [NSString stringWithFormat:@"%ld分",(long)row];
            }
                break;
        
            default:
                break;
        }
    }else if (self.pickerViewMode == JHDatePickerViewDateTypeYearMonthDayHourMinuteSecondMode){
        
        switch (component) {
            case 0:
            {
                label.text = [NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
            }
                break;
            case 1:
            {
                label.text = [NSString stringWithFormat:@"%ld月",(long)row+1];
            }
                break;
            case 2:
            {
                
                label.text = [NSString stringWithFormat:@"%ld日",(long)row+1];
            }
                break;
            case 3:
            {
                label.text = [NSString stringWithFormat:@"%ld时",(long)row];
            }
                break;
            case 4:
            {
                label.text = [NSString stringWithFormat:@"%ld分",(long)row];
            }
                break;
            case 5:
            {
                label.text = [NSString stringWithFormat:@"%ld秒",(long)row];
            }
                break;
                
            default:
                break;
        }
    }
    else if (self.pickerViewMode == JHDatePickerViewDateTypeYearMonthDayHourMode){
        
        switch (component) {
            case 0:
            {
                label.text = [NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
            }
                break;
            case 1:
            {
                label.text = [NSString stringWithFormat:@"%ld月",(long)row+1];
            }
                break;
            case 2:
            {
                
                label.text = [NSString stringWithFormat:@"%ld日",(long)row+1];
            }
                break;
            case 3:
            {
                label.text = [NSString stringWithFormat:@"%ld时",(long)row];
            }
                break;
            default:
                break;
        }
    }
    else if (self.pickerViewMode == JHDatePickerViewDateTypeYearMonthDayMode){
        
        switch (component) {
            case 0:
            {
                label.text = [NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
            }
                break;
            case 1:
            {
                label.text = [NSString stringWithFormat:@"%ld月",(long)row+1];
            }
                break;
            case 2:
            {
                
                label.text = [NSString stringWithFormat:@"%ld日",(long)row+1];
            }
                break;

            default:
                break;
        }
    }
    else if (self.pickerViewMode == JHDatePickerViewDateTypeYearMonthMode){
        
        switch (component) {
            case 0:
            {
                label.text = [NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
            }
                break;
            case 1:
            {
                label.text = [NSString stringWithFormat:@"%ld月",(long)row+1];
            }
                break;
            default:
                break;
        }
    }
    else if (self.pickerViewMode == JHDatePickerViewDateTypeYearMode){
        
        switch (component) {
            case 0:
            {
                label.text = [NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
            }
                break;
            case 1:
            {
                label.text = [NSString stringWithFormat:@"%ld月",(long)row+1];
            }
                break;
            default:
                break;
        }
    }
    return label;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    if (self.pickerViewMode == JHDatePickerViewDateTypeYearMonthDayHourMinuteMode) {
        
       return (kScreenWidth-40)/5;
        
    }else if (self.pickerViewMode == JHDatePickerViewDateTypeYearMonthDayHourMinuteSecondMode){
      return (kScreenWidth-40)/6;
    }
    else if (self.pickerViewMode == JHDatePickerViewDateTypeYearMonthDayHourMode){
      return (kScreenWidth-40)/4;
    }
    else if (self.pickerViewMode == JHDatePickerViewDateTypeYearMonthDayMode){
       return (kScreenWidth-40)/3;
    }
    else if (self.pickerViewMode == JHDatePickerViewDateTypeYearMonthMode){
      return (kScreenWidth-40)/2;
    }
    else if (self.pickerViewMode == JHDatePickerViewDateTypeYearMode){
        return (kScreenWidth-40)/1;
    }
   
    return 0;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return PickerRowHeight;
}
// 监听picker的滑动
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    if (self.pickerViewMode == JHDatePickerViewDateTypeYearMonthDayHourMinuteMode) {
        switch (component) {
            case 0:
            {
                selectedYear = startYear + row;
                dayRange = [self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 1:
            {
                selectedMonth = row+1;
                dayRange = [self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 2:
            {
                selectedDay = row+1;
            }
                break;
            case 3:
            {
                selectedHour = row;
            }
                break;
            case 4:
            {
                selectedMinute = row;
            }
                break;
                
            default:
                break;
        }
        
        _dateString  = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld",(long)selectedYear,(long)selectedMonth,(long)selectedDay,(long)selectedHour,(long)selectedMinute];
    }else if (self.pickerViewMode == JHDatePickerViewDateTypeYearMonthDayHourMinuteSecondMode){
        switch (component) {
            case 0:
            {
                selectedYear = startYear + row;
                dayRange = [self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 1:
            {
                selectedMonth = row+1;
                dayRange = [self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 2:
            {
                selectedDay = row+1;
            }
                break;
            case 3:
            {
                selectedHour = row;
            }
                break;
            case 4:
            {
                selectedMinute = row;
            }
                break;
            case 5:
            {
                selectedSecond = row;
            }
                break;
            default:
                break;
        }
        
        _dateString  = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld:%.2ld",(long)selectedYear,(long)selectedMonth,(long)selectedDay,(long)selectedHour,(long)selectedMinute,(long)selectedSecond];
    }
    else if (self.pickerViewMode == JHDatePickerViewDateTypeYearMonthDayHourMode){
        switch (component) {
            case 0:
            {
                selectedYear = startYear + row;
                dayRange = [self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 1:
            {
                selectedMonth = row+1;
                dayRange = [self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 2:
            {
                selectedDay = row+1;
            }
                break;
            case 3:
            {
                selectedHour = row;
            }
                break;
          
            default:
                break;
        }
        
        _dateString = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:00",(long)selectedYear,(long)selectedMonth,(long)selectedDay,(long)selectedHour];
    }
    else if (self.pickerViewMode == JHDatePickerViewDateTypeYearMonthDayMode){
        switch (component) {
            case 0:
            {
                selectedYear = startYear + row;
                dayRange = [self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 1:
            {
                selectedMonth = row+1;
                dayRange = [self isAllDay:selectedYear andMonth:selectedMonth];
                [self.pickerView reloadComponent:2];
            }
                break;
            case 2:
            {
                selectedDay = row+1;
            }
                break;
          
            default:
                break;
        }
        
        _dateString = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld",(long)selectedYear,(long)selectedMonth,(long)selectedDay];
    }
    else if (self.pickerViewMode == JHDatePickerViewDateTypeYearMonthMode){
        switch (component) {
            case 0:
            {
                selectedYear = startYear + row;
              
            }
                break;
            case 1:
            {
                selectedMonth = row+1;
              
            }
                break;
          
            default:
                break;
        }
        
        _dateString = [NSString stringWithFormat:@"%ld-%.2ld",(long)selectedYear,(long)selectedMonth];
    }
    else if (self.pickerViewMode == JHDatePickerViewDateTypeYearMode){
        switch (component) {
            case 0:
            {
                selectedYear = startYear + row;
                
            }
                break;
           
            default:
                break;
        }
        
        _dateString  = [NSString stringWithFormat:@"%ld",(long)selectedYear];
    }
}

- (void)updateYearRange:(NSInteger)range beforeYear:(NSInteger)beforeYear{
    yearRange = range;
    startYear = startYear + 1 - beforeYear;
    [self.pickerView reloadComponent:0];
}
@end
