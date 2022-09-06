//
//  JHStoreDetailTagViewModel.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 商品标签区

#import "JHStoreDetailCellBaseViewModel.h"
#import "JHStoreDetailTagItemViewModel.h"

static const CGFloat TagTopSpace = 5;
static const CGFloat TagItemSpace = 5;
NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailTagViewModel : JHStoreDetailCellBaseViewModel
@property (nonatomic, strong) NSMutableArray<JHStoreDetailTagItemViewModel *> *itemList;
@end

NS_ASSUME_NONNULL_END
