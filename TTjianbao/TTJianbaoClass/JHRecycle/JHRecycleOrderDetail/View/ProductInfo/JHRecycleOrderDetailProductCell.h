//
//  JHRecycleOrderDetailProductCell.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 回收订单详情-商品信息

#import "JHRecycleOrderDetailBaseCell.h"
#import "JHRecycleOrderDetailProductViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderDetailProductCell : JHRecycleOrderDetailBaseCell
@property (nonatomic ,strong) JHRecycleOrderDetailProductViewModel *viewModel;
@end

NS_ASSUME_NONNULL_END
