//
//  JHNewStoreSpecialBussinew.h
//  TTjianbao
//
//  Created by liuhai on 2021/2/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHNewStoreSpecialBussinew : NSObject
/// 获取专场详情信息
///showId:专场id
+ (void)getStoreSpecialInfoWithSpecialId : (NSString *)showId
                            successBlock:(succeedBlock) success
                             failureBlock:(failureBlock)failure;
///获取专场商品列表
+ (void)requestSpecialProductListWithParams:(NSDictionary *)params
                               successBlock:(succeedBlock) success
                               failureBlock:(failureBlock)failure;

///获取pv用户数据
+ (void)requestSpecialUserList:(NSString *)showId
                  successBlock:(succeedBlock) success
                  failureBlock:(failureBlock)failure;

//开售提醒
+(void)requestSalesReminderWithParams:(NSDictionary *)params
                         successBlock:(succeedBlock) success
                         failureBlock:(failureBlock)failure;

//专场曝光埋点
+ (void)sa_enterSpecialDetailWithName:(NSString *)zc_name
                              zc_type:(NSString *)zc_type
                                zc_id:(NSString *)zc_id
                           store_from:(NSString *)store_from
                              zc_time:(NSString *)zc_time
                            show_type:(NSString *)show_type;
@end

NS_ASSUME_NONNULL_END
