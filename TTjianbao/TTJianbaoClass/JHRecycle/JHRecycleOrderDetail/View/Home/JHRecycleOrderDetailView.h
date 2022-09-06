//
//  JHRecycleOrderDetailView.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/15.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 回收订单详情-Home

#import <UIKit/UIKit.h>
#import "JHRecycleOrderDetailViewModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderDetailView : UIView
/// 订单ID
@property (nonatomic, copy) NSString *orderId;
/// home viewModel
@property (nonatomic, strong) JHRecycleOrderDetailViewModel *viewModel;


@end

NS_ASSUME_NONNULL_END
