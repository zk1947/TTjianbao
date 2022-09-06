//
//  JHRecycleOrderDetailServiceCell.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 回收订单详情-客服

#import "JHRecycleOrderDetailBaseCell.h"
#import "JHRecycleOrderDetailServiceViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderDetailServiceCell : JHRecycleOrderDetailBaseCell
@property (nonatomic, strong) JHRecycleOrderDetailServiceViewModel *viewModel;
@end

NS_ASSUME_NONNULL_END
