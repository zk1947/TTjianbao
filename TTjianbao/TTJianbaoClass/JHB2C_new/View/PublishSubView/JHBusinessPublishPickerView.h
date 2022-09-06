//
//  JHBusinessPublishPickerView.h
//  TTjianbao
//
//  Created by liuhai on 2021/8/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "STPickerView.h"
#import "JHBusinessPubishNomalModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHBusinessPublishPickerView : STPickerView
@property (nonatomic,copy)void(^sureClickBlock)(NSInteger selectedIndex_0,NSInteger selectedIndex_1,NSInteger selectedIndex_2);

@property (nonatomic,copy)void(^sureClickBlock2)(NSString *showStr,NSString * cateId,NSString * cateId1,NSString * cateId2,NSInteger selectedIndex_0,NSInteger selectedIndex_1,NSInteger selectedIndex_2);
/** 设置字符串数据数组 */
@property (nonatomic, strong)NSArray<NSString *> *arrayData_0;
@property (nonatomic, strong)NSArray<NSString *> *arrayData_1;
@property(nonatomic, strong) JHBusinessPubishNomalModel * normalModel;
/** 选择框的高度，default is 44*/
@property (nonatomic, assign)CGFloat heightPickerComponent;
@property (nonatomic, assign)NSInteger selectedIndex_0;
@property (nonatomic, assign)NSInteger selectedIndex_1;
@property (nonatomic, assign)NSInteger selectedIndex_2;
@end

NS_ASSUME_NONNULL_END
