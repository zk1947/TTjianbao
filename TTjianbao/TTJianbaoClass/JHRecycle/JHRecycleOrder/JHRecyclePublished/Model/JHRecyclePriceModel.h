//
//  JHRecyclePriceModel.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHRecyclePriceModel : NSObject
/** 报价id*/
@property (nonatomic, copy) NSString *bidId;
/** 宝贝报价 元*/
@property (nonatomic, copy) NSString *bidPriceYuan;
/** 回收商名称*/
@property (nonatomic, copy) NSString *shopName;
/** 成交率*/
@property (nonatomic, copy) NSString *turnoverRate;
/** 报价时间*/
@property (nonatomic, copy) NSString *bidTime;
/** 商品id*/
@property (nonatomic, copy) NSString *productId;
/** 是否选中*/
@property (nonatomic, assign) BOOL isSelect;
/** 回收商id*/
@property (nonatomic, copy) NSString *businessId;
/** 到期时间*/
@property (nonatomic, copy) NSString *tipInitCountdownTime;
/** 剩余时间*/
@property (nonatomic, assign) NSInteger timeLeft;
@end

NS_ASSUME_NONNULL_END
