//
//  JHCustomerCerDatePickerView.m
//  TTjianbao
//
//  Created by user on 2020/11/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerCerDatePickerView.h"
#import "NSCalendar+STPicker.h"

typedef NS_OPTIONS(NSUInteger, STCalendarUnit) {
    STCalendarUnitYear  = (1UL << 0),
    STCalendarUnitMonth = (1UL << 1),
    STCalendarUnitDay   = (1UL << 2),
    STCalendarUnitHour  = (1UL << 3),
    STCalendarUnitMinute= (1UL << 4),
};

@interface JHCustomerCerDatePickerView() <
UIPickerViewDataSource,
UIPickerViewDelegate>
@property (nonatomic, assign) NSInteger year;
@property (nonatomic, assign) NSInteger month;

@end

@implementation JHCustomerCerDatePickerView

- (void)setupUI {
    _yearLeast = 1900;
    _yearSum   = 200;
    _heightPickerComponent = 49.f;
//    self.calendarUnit = STCalendarUnitYear | STCalendarUnitMonth | STCalendarUnitDay;
    _year  = [NSCalendar currentYear];
    _month = [NSCalendar currentMonth];
    [self.pickerView setDelegate:self];
    [self.pickerView setDataSource:self];
}

#pragma mark - --- delegate 视图委托 ---
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return self.yearSum;
    } else {
        return 12;
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return self.heightPickerComponent;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        self.year = row + self.yearLeast;
        [pickerView reloadComponent:2];
    } else {
        self.month = row + 1;
        [pickerView reloadComponent:2];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view {
    
    //设置分割线的颜色
    [pickerView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.frame.size.height <=1) {
            obj.backgroundColor = self.borderButtonColor;
        }
    }];
    
    NSString *text;
    if (component == 0) {
        text =  [NSString stringWithFormat:@"%zd", row + self.yearLeast];
    } else {
        text =  [NSString stringWithFormat:@"%zd", row + 1];
    }
    
    UILabel *label = [[UILabel alloc]init];
    [label setTextAlignment:NSTextAlignmentCenter];
    label.textColor = HEXCOLOR(0x333333);
    [label setFont:[UIFont systemFontOfSize:22.f]];
    [label setText:text];
    return label;
}
#pragma mark - --- event response 事件相应 ---
- (void)selectedOk {
    if ([self.delegate respondsToSelector:@selector(pickerDate:year:month:)]) {
         [self.delegate pickerDate:self year:self.year month:self.month];
    }
    [super selectedOk];
}

#pragma mark - --- private methods 私有方法 ---
#pragma mark - --- setters 属性 ---

- (void)setYearLeast:(NSInteger)yearLeast {
    if (yearLeast <= 0) {
        return;
    }
    _yearLeast = yearLeast;
    [self.pickerView selectRow:(_year - _yearLeast) inComponent:0 animated:NO];
    [self.pickerView selectRow:(_month - 1) inComponent:1 animated:NO];
    [self.pickerView reloadAllComponents];
}

- (void)setYearSum:(NSInteger)yearSum {
    if (yearSum <= 0) {
        return;
    }
    _yearSum = yearSum;
    [self.pickerView reloadAllComponents];
}

#pragma mark - --- getters 属性 ---



@end
