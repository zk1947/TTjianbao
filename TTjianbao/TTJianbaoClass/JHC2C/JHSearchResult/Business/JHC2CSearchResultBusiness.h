//
//  JHC2CSearchResultBusiness.h
//  TTjianbao
//
//  Created by hao on 2021/5/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHNewStoreTypeTableCellViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHC2CSearchResultBusiness : NSObject
///搜索商品列表
+ (void)requestSearchResultWithParams:(NSDictionary *)params Completion:(void(^)(RequestModel *respondObject, NSError *_Nullable error))completion;
///分类列表
+ (void)requestSearchCateListWithParams:(NSDictionary *)params Completion:(void (^)(NSError * _Nullable, NSArray<JHNewStoreTypeTableCellViewModel*> * _Nullable))completion;

///分类id查询子类列表
+ (void)requestSearchChildrenCateListWithParams:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable, NSArray<JHNewStoreTypeTableCellViewModel*> * _Nullable))completion;

@end

NS_ASSUME_NONNULL_END
