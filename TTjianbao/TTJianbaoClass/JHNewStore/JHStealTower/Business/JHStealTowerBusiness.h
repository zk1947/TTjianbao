//
//  JHStealTowerBusiness.h
//  TTjianbao
//
//  Created by zk on 2021/8/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHStealTowerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHStealTowerBusiness : NSObject

///偷塔页列表数据查询
+ (void)loadStealTowerListData:(NSDictionary *)param completion:(void(^)(NSError *_Nullable error, JHStealTowerModel *model))completion;

+(void)logProperty:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
