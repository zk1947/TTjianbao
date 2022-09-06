//
//  JHRecycleHomeGoodsBusiness.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleHomeGoodsBusiness : NSObject
///商品列表
+ (void)requestRecycleHomeGoodsListWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;
///商品分类
+ (void)requestRecycleHomeGoodsCateWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;
@end

NS_ASSUME_NONNULL_END
