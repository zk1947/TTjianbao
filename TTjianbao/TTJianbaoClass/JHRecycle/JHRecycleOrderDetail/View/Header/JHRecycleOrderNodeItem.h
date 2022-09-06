//
//  JHRecycleOrderNodeItem.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderDetailBaseItem.h"
#import "JHRecycleOrderNodeItemViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderNodeItem : JHRecycleOrderDetailBaseItem
@property (nonatomic, strong) JHRecycleOrderNodeItemViewModel *viewModel;
@end

NS_ASSUME_NONNULL_END
