//
//  JHSpecialDatePickerView.h
//  TTjianbao
//
//  特殊日期选择器，例如显示：年月日 时分秒；年月日 时分等
//
//  Created by haozhipeng on 2021/1/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,JHDatePickerViewDateType) {
    JHDatePickerViewDateTypeYearMonthDayHourMinuteSecondMode = 0,//年月日,时分秒
    JHDatePickerViewDateTypeYearMonthDayHourMinuteMode,//年月日,时分
    JHDatePickerViewDateTypeYearMonthDayHourMode,//年月日,时
    JHDatePickerViewDateTypeYearMonthDayMode,//年月日
    JHDatePickerViewDateTypeYearMonthMode,//年月
    JHDatePickerViewDateTypeYearMode,//年
    
};

@interface JHSpecialDatePickerView : UIView

///底部View
@property (nonatomic, strong) UIView *buttomView;

- (instancetype)initWithDateStyle:(JHDatePickerViewDateType)datePickerStyle completeBlock:(void(^)(NSString *dateString))completeBlock;
- (void)show;

- (void)updateYearRange:(NSInteger)range beforeYear:(NSInteger)beforeYear;
@end

