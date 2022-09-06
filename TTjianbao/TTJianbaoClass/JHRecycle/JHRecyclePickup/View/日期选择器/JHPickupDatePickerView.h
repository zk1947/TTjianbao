//
//  JHPickupDatePickerView.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/30.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHPickupDatePickerView : UIView

- (instancetype)initWithDatePickerViewCompleteBlock:(void(^)(NSString *startTimeStr, NSString *endTimeStr, NSString *showDateStr))completeBlock;

- (void)show;

@end

NS_ASSUME_NONNULL_END
