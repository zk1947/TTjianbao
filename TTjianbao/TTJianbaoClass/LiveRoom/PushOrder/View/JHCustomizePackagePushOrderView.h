//
//  JHCustomizePackagePushOrderView.h
//  TTjianbao
//
//  Created by user on 2021/1/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "BaseView.h"
#import "OrderMode.h"

NS_ASSUME_NONNULL_BEGIN

/// 用户端，定制套餐飞单
@interface JHCustomizePackagePushOrderView : BaseView
@property (nonatomic, assign) BOOL       isShow;
@property (nonatomic, strong) OrderMode *model;
@end

NS_ASSUME_NONNULL_END
