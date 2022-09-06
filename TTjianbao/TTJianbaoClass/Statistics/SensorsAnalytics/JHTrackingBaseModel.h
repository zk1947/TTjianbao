//
//  JHTrackingBaseModel.h
//  TTjianbao
//
//  Created by apple on 2020/12/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHTrackingEnum.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHTrackingBaseModel : NSObject
// 事件
@property (nonatomic, copy) NSString *event;         // 事件名
//@property (nonatomic, assign) JHTrackEventType eventType;               // 事件类型 展示/点击/关闭、取消/结果:(成功、失败)

// 属性
@property (nonatomic, strong) NSDictionary *properties;        // 属性

//@property (nonatomic, assign) JHTrackingPage source_page;                 // 上一个页面类型

@end

NS_ASSUME_NONNULL_END
