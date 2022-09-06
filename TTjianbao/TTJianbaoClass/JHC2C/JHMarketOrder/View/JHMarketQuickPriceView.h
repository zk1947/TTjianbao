//
//  JHMarketQuickPriceView.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/6/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMarketQuickPriceView : BaseView
/** 改价成功回调*/
@property (nonatomic, copy) void(^completeBlock)(void);
@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *oriPrice;
@end

NS_ASSUME_NONNULL_END
