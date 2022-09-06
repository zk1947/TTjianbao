//
//  JHRecycleOrderBusinessSectionViewModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderBusinessBaseViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderBusinessSectionViewModel : NSObject

/// cells
@property (nonatomic, strong) NSMutableArray<JHRecycleOrderBusinessBaseViewModel *> *cellViewModelList;
@end

NS_ASSUME_NONNULL_END
