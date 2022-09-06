//
//  JHStoreRankListViewModel.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/2/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHStoreRankTagModel.h"
#import "JHStoreRankListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHStoreRankListViewModel : NSObject

///获取tag标签
+ (void)getRankTagList:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, JHStoreRankTagModel * _Nullable model))completion;

///获取排行榜列表数据
+ (void)getRankStoreList:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, NSArray<JHStoreRankListModel *> *_Nullable array))completion;

//关注/取消店铺
+ (void)followStoreRequest:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, NSDictionary *_Nullable data))completion;
@end

NS_ASSUME_NONNULL_END
