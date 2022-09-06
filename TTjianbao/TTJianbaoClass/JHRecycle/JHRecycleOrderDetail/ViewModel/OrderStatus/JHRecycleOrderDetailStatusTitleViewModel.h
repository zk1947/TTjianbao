//
//  JHRecycleOrderDetailStatusTitleViewModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderDetailBaseViewModel.h"



NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleOrderDetailStatusTitleViewModel : JHRecycleOrderDetailBaseViewModel

@property (nonatomic, copy) NSString *iconUrl;
@property (nonatomic, copy) NSString *statusText;
@property (nonatomic, copy) NSAttributedString *priceText;


@property (nonatomic, assign) RecycleOrderStatus orderStatus;

@property (nonatomic, assign) RecycleOrderTitleStatus orderTitleStatus;

- (void)setupPrice : (NSString *)price originalPrice : (NSString *)originalPrice;
@end

NS_ASSUME_NONNULL_END
