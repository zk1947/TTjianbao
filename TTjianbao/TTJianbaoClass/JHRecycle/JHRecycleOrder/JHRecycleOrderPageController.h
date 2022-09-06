//
//  JHRecycleOrderPageController.h
//  TTjianbao
//
//  Created by lihui on 2021/5/14.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
/// 回收订单 - tab页面

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderPageController : JHBaseViewController
///默认选中的下标 默认选中0我发布的  1我卖出的
@property (nonatomic, assign) NSInteger selectIndex;
@end

NS_ASSUME_NONNULL_END
