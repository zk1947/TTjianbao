//
//  JHRecycleGoodDetailInfoBusiness.h
//  TTjianbao
//
//  Created by user on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class JHRecycleGoodsInfoViewModel;
@interface JHRecycleGoodDetailInfoBusiness : NSObject
/// 获取回收商品详情信息
+ (void)getRecycleGoodsDetailInfoRequest:(NSString *)productId
                              Completion:(void(^)(NSError *_Nullable error, JHRecycleGoodsInfoViewModel *_Nullable viewModel))completion;
@end

NS_ASSUME_NONNULL_END
