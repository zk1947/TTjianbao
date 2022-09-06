//
//  JHRecycleOrderDetailViewController.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 回收订单详情

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderDetailViewController : JHBaseViewController
@property (nonatomic, copy) NSString *orderId;
/// 该订单是否已删除
@property (nonatomic, assign) BOOL isDeleted;
/// 刷新上层数据
@property (nonatomic, copy) void(^ reloadData)(BOOL isDelete);
@end

NS_ASSUME_NONNULL_END
