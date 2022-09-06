//
//  JHRecycleOrderNodeLineItem.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderDetailBaseItem.h"
#import "JHRecycleOrderNodeLineItemViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderNodeLineItem : JHRecycleOrderDetailBaseItem

@property (nonatomic, strong) JHRecycleOrderNodeLineItemViewModel *viewModel;

@end

NS_ASSUME_NONNULL_END
