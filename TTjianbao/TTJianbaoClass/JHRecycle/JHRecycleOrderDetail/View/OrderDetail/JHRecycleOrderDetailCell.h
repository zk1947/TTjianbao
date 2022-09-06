//
//  JHRecycleOrderDetailCell.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 回收订单详情-订单信息

#import "JHRecycleOrderDetailBaseCell.h"
#import "JHRecycleOrderDetailInfoViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderDetailCell : JHRecycleOrderDetailBaseCell
@property (nonatomic, strong) JHRecycleOrderDetailInfoViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END
