//
//  JHC2CPickView.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "STPickerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CPickView : STPickerView

@property (nonatomic,copy)void(^sureClickBlock)(NSInteger selectedIndex);

/** 设置字符串数据数组 */
@property (nonatomic, strong)NSArray<NSString *> *arrayData_0;
/** 选择框的高度，default is 44*/
@property (nonatomic, assign)CGFloat heightPickerComponent;

- (void)seletedRow:(NSInteger)row;
@end

NS_ASSUME_NONNULL_END
