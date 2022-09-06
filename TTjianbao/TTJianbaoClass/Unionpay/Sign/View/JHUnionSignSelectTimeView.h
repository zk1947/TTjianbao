//
//  JHUnionSignSelectTimeView.h
//  TTjianbao
//
//  Created by wangjianios on 2021/3/1.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHSpecialDatePickerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHUnionSignSelectTimeView : JHSpecialDatePickerView

- (instancetype)initWithDateStyle:(JHDatePickerViewDateType)datePickerStyle completeBlock:(void(^)(NSString *dateString))completeBlock longDateBlock:(void(^)(NSString *timeString))longDateBlock;

@end

NS_ASSUME_NONNULL_END
