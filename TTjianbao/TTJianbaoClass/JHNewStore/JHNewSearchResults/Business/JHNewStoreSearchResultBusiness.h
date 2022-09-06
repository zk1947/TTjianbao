//
//  JHNewStoreSearchResultBusiness.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHNewStoreSearchResultBusiness : NSObject
///直播/商品搜索
+ (void)requestProductSearchWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;

///推荐标签
+ (void)requestRecommendTagsListWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;
@end

NS_ASSUME_NONNULL_END
