//
//  JHNewStoreClassListBusiness.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHNewStoreClassListBusiness : NSObject
///商品分类/搜索（408版本以前）
+ (void)requestProductClassResultWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;
///查询分类列表
+ (void)requestClassListWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;
@end

NS_ASSUME_NONNULL_END
