//
//  JHRecyclePublishedViewModel.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHRecyclePublishedModel.h"
#import "JHRecyclePriceModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface JHRecyclePublishedViewModel : NSObject

///获取发布列表的接口
+ (void)getPublishedList:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, NSArray<JHRecyclePublishedModel *> *_Nullable array))completion;

///获取报价列表的接口
+ (void)getPriceList:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, NSArray<JHRecyclePriceModel *> *_Nullable array))completion;

///确认报价的接口
+ (void)confirmPrice:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, NSDictionary *_Nullable data))completion;

///删除发布的接口
+ (void)deletePublishedRequest:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, NSDictionary *_Nullable data))completion;

///商品上架/下架的接口
+ (void)onOrOffSalePublishedRequest:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, NSDictionary *_Nullable data))completion;

@end

NS_ASSUME_NONNULL_END
