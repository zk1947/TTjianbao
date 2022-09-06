//
//  JHZeroAuctionBusiness.h
//  TTjianbao
//
//  Created by zk on 2021/11/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHZeroAuctionModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHZeroAuctionBusiness : NSObject

///0元起拍列表数据查询
+ (void)loadStealTowerListData:(NSDictionary *)param completion:(void(^)(NSError *_Nullable error, JHZeroAuctionModel *model))completion;

///单条刷新
+ (void)loadCellData:(NSDictionary *)param completion:(void(^)(NSError *_Nullable error, JHNewStoreHomeGoodsProductListModel *model))completion;

@end

NS_ASSUME_NONNULL_END
