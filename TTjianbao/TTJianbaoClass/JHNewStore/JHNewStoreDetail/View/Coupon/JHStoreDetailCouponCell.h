//
//  JHStoreDetailCouponCell.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 商品优惠券区

#import <UIKit/UIKit.h>
#import "JHStoreDetailBaseCell.h"
#import "JHStoreDetailCouponViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailCouponCell : JHStoreDetailBaseCell
@property (nonatomic, strong) JHStoreDetailCouponViewModel *viewModel;
@end

NS_ASSUME_NONNULL_END
