//
//  JHGoodManagerListBusiness.h
//  TTjianbao
//
//  Created by user on 2021/8/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHGoodManagerListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHGoodManagerListBusiness : NSObject
/// 总接口
+ (void)getGoodManagerList:(JHGoodManagerListRequestModel *)model
                Completion:(void(^)(NSError *_Nullable error, JHGoodManagerListAllDataModel *_Nullable dataModel))completion;


/// tab 单独接口
+ (void)getGoodManagerListTabOnly:(JHGoodManagerListRequestModel *)model
                Completion:(void(^)(NSError *_Nullable error, NSArray<JHGoodManagerListTabChooseModel *> *_Nullable array))completion;

/// 商品列表
+ (void)getGoodManagerListGoodOnly:(JHGoodManagerListRequestModel *)model
                Completion:(void(^)(NSError *_Nullable error, NSArray<JHGoodManagerListModel *> *_Nullable array))completion;

/// 更新单条商品数据
+ (void)updateOnlyGoodManagerListItem:(NSString *)productId
                          productType:(NSInteger)productType
                            imageType:(NSString *)imageType
                Completion:(void(^)(NSError *_Nullable error, JHGoodManagerListModel *_Nullable itemModel))completion;

/// 上架
+ (void)putOnGood:(JHGoodManagerListItemPutOnRequestModel *)model
       Completion:(void(^)(NSError *_Nullable error))completion;

/// 下架
+ (void)goodOffTheShelf:(NSString *)productId
                Completion:(void(^)(NSError *_Nullable error))completion;


/// 删除
+ (void)deleteGood:(NSString *)productId
        Completion:(void(^)(NSError *_Nullable error))completion;


@end

NS_ASSUME_NONNULL_END
