//
//  JHStoreDetailCouponViewModel.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 商品优惠券ViewModel

#import <Foundation/Foundation.h>
#import "JHStoreDetailCellBaseViewModel.h"
#import "JHStoreDetailCouponItemViewModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailCouponViewModel : JHStoreDetailCellBaseViewModel
/// 优惠券 item 集合
@property (nonatomic, strong) NSMutableArray<JHStoreDetailCouponItemViewModel *> *itemList;


@end

NS_ASSUME_NONNULL_END
