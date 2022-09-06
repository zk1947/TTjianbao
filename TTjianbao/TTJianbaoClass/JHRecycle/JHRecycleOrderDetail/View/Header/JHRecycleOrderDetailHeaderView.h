//
//  JHRecycleOrderDetailHeaderView.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 回收订单详情-header

#import <UIKit/UIKit.h>
#import "JHRecycleOrderDetailHeaderViewModel.h"
#import "JHRecycleOrderNodeView.h"
#import "JHRecycleOrderDetail.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderDetailHeaderView : UIView
/// viewModel
@property (nonatomic, strong) JHRecycleOrderDetailHeaderViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END
