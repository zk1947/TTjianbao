//
//  JHCustomerCerDatePickerView.h
//  TTjianbao
//
//  Created by user on 2020/11/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STPickerView.h"

NS_ASSUME_NONNULL_BEGIN

@class JHCustomerCerDatePickerView;
@protocol JHDatePickerViewDelegate<NSObject>
- (void)pickerDate:(JHCustomerCerDatePickerView *)pickerDate year:(NSInteger)year month:(NSInteger)month;
@end

@interface JHCustomerCerDatePickerView : STPickerView
/**
 * 1.最小的年份，default is 1900
 */
@property (nonatomic, assign) NSInteger yearLeast;
/**
 * 2.显示年份数量，default is 200
 */
@property (nonatomic, assign) NSInteger yearSum;
/**
 * 3.中间选择框的高度，default is 28
 */
@property (nonatomic, assign) CGFloat   heightPickerComponent;
@property (nonatomic,   weak) id <JHDatePickerViewDelegate>delegate  ;

@end

NS_ASSUME_NONNULL_END
