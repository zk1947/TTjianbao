//
//  JHVoucherApiManager.h
//  TTjianbao
//
//  Created by wuyd on 2020/3/3.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHVoucherListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHVoucherApiManager : NSObject

///直播间卖家可以发放给个人的代金券列表
+ (void)getValidDataList:(JHVoucherListModel *)model block:(HTTPCompleteBlock)block;

///发放代金券
+ (void)sendVoucherToUserId:(NSString *)userId
                   sellerId:(NSString *)sellerId
                 voucherIds:(NSArray *)voucherIds
                      block:(HTTPCompleteBlock)block;

///创建代金券
+ (void)createVoucherWithParams:(NSDictionary *)params block:(HTTPCompleteBlock)block;

@end

NS_ASSUME_NONNULL_END
