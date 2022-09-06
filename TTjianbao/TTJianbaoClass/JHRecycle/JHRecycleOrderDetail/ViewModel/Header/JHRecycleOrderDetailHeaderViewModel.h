//
//  JHRecycleOrderDetailHeaderViewModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 回收订单详情-HeaderViewModel

#import <Foundation/Foundation.h>
#import "JHRecycleOrderNodeViewModel.h"
#import "JHRecycleOrderDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderDetailHeaderViewModel : NSObject
@property (nonatomic, strong) JHRecycleOrderNodeViewModel *nodeViewModel;

- (void)setupDataWithNodeInfo : (JHRecycleOrderNodeInfo *)model;
@end

NS_ASSUME_NONNULL_END
