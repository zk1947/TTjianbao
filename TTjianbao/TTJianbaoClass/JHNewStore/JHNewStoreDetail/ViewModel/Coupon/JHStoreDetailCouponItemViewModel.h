//
//  JHStoreDetailCouponItemViewModel.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/4.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 优惠券 item

#import "JHStoreDetailCellBaseViewModel.h"

static const CGFloat TitleTextFontSize = 10.0f;
static const CGFloat TitleLeftSpace = 8.0f;
NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailCouponItemViewModel : JHStoreDetailCellBaseViewModel
/// 优惠券名
@property (nonatomic, copy) NSString *titleText;
@end

NS_ASSUME_NONNULL_END
