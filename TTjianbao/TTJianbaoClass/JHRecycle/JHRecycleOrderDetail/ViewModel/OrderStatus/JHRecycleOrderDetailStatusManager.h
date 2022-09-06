//
//  JHRecycleOrderDetailStatusManager.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHRecycleOrderDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderDetailStatusManager : NSObject
@property (nonatomic, copy) NSString *iconUrl;
/// 状态
@property (nonatomic, copy) NSString *statusText;
/// 描述内容
@property (nonatomic, copy) NSString *describeText;

@property (nonatomic, assign) RecycleOrderTitleStatus orderTitleStatus;

- (void)setupOrderStatus : (RecycleOrderStatus) orderStatus;
@end

NS_ASSUME_NONNULL_END
