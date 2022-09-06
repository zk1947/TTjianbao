//
//  JHRecycleOrderDetailSectionViewModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 回收订单详情-分区 ViewModel

#import "JHRecycleOrderDetailBaseViewModel.h"
#import "JHRecycleOrderDetailBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderDetailSectionViewModel : JHRecycleOrderDetailBaseViewModel
/// cells
@property (nonatomic, strong) NSMutableArray<JHRecycleOrderDetailBaseViewModel *> *cellViewModelList;
@end

NS_ASSUME_NONNULL_END
