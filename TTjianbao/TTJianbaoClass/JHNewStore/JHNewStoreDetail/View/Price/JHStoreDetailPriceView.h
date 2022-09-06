//
//  JHStoreDetailPriceView.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHStoreDetail.h"
#import "JHStoreDetailConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailPriceView : UIView
/// 销售价、折扣价
@property (nonatomic, strong) UILabel *salePriceLabel;
/// 价格、原价
@property (nonatomic, strong) UILabel *priceLabel;
/// 折扣
@property (nonatomic, strong) UILabel *saleLabel;
@property (nonatomic, assign) StoreDetailType type;

@end

NS_ASSUME_NONNULL_END
