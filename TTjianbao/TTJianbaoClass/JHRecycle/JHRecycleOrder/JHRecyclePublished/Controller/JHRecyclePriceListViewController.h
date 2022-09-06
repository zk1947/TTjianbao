//
//  JHRecyclePriceListViewController.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecyclePriceListViewController : JHBaseViewController
/** 选完报价之后的回调*/
@property (nonatomic, copy) void(^completePriceBlock)(void);
/** 报价商品id*/
@property (nonatomic, copy) NSString *productId;
/** 来源,记录来源页面是否还能再现*/
@property (nonatomic, assign) BOOL fromPageIsDismiss;
@end

NS_ASSUME_NONNULL_END
