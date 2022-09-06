//
//  JHBusinessPublishContinueTimePicker.h
//  TTjianbao
//
//  Created by liuhai on 2021/8/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "STPickerView.h"
#import "JHBusinessPubishNomalModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHBusinessPublishContinueTimePicker : STPickerView
@property (nonatomic,copy)void(^sureClickBlock2)(NSString *showStr,NSString * timeStr);
/** 设置字符串数据数组 */
@property(nonatomic, strong) JHBusinessPubishNomalModel * normalModel;
/** 选择框的高度，default is 44*/
@property (nonatomic, assign)CGFloat heightPickerComponent;
@end

NS_ASSUME_NONNULL_END
