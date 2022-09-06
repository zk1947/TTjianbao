//
//  JHMarketPriceAlert.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/31.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMarketPriceAlert : BaseView
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *oriPrice;
@property (nonatomic, copy) NSString *frePrice;
@property (nonatomic, copy) void (^successCompleteBlock)(void);
@end

NS_ASSUME_NONNULL_END
