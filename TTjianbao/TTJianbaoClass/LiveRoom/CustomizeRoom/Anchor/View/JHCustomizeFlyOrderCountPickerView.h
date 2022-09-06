//
//  JHCustomizeFlyOrderCountPickerView.h
//  TTjianbao
//
//  Created by lihang on 2020/11/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "STPickerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeFlyOrderCountPickerView : STPickerView

@property (nonatomic,copy)void(^sureClickBlock)(NSInteger selectedIndex_0,NSInteger selectedIndex_1);


/** 设置字符串数据数组 */
@property (nonatomic, strong)NSArray<NSString *> *arrayData_0;
@property (nonatomic, strong)NSArray<NSString *> *arrayData_1;
/** 选择框的高度，default is 44*/
@property (nonatomic, assign)CGFloat heightPickerComponent;

@end

NS_ASSUME_NONNULL_END
