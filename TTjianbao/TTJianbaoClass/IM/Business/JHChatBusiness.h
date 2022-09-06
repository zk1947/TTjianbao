//
//  JHChatBusiness.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHChatOrderInfoModel.h"
#import "JHIMHeader.h"
#import "JHChatUserInfo.h"
#import "JHChatAccInfo.h"
#import "JHIMQuickModel.h"
#import "JHChatCouponInfoModel.h"
#import "JHChatBlackUserModel.h"
NS_ASSUME_NONNULL_BEGIN

typedef void (^orderInfoBlock)(JHChatOrderInfoListModel *respondObject);
typedef void (^userInfoBlock)(JHChatUserInfo *respondObject);
typedef void (^AccInfoBlock)(JHChatAccInfo *respondObject);
typedef void (^QuickInfoBlock)(NSArray <JHIMQuickModel *> *respondObject);
typedef void (^CouponInfoBlock)(NSArray <JHChatCouponInfoModel *> *respondObject);
typedef void (^CouponSendInfoBlock)(JHChatCouponSendModel *respondObject);

@interface JHChatBusiness : NSObject
/// 获取商品详情信息
/// account : 用户accid
/// receiveAccount : 对方 accid
/// pageNo : 页码
+ (void)getOrderInfoWithAccount : (NSString *)account
                 receiveAccount : (NSString *)receiveAccount
                         pageNo : (NSInteger)pageNo
                    successBlock:(orderInfoBlock) success
                    failureBlock:(failureBlock)failure;

/// 获取用户信息
/// userId : 用户accid
+ (void)getUserInfoWithId : (NSString *)userId
              successBlock:(userInfoBlock) success
              failureBlock:(failureBlock)failure;

/// 拉黑or取消拉黑
/// account : 用户customerId
/// blackAccount : 被拉黑customerId
/// isBlack : 拉黑状态
+ (void)blackWithBlackAccount : (NSString *)blackAccount
                      isBlack : (BOOL)isBlack
                  successBlock:(succeedBlock) success
                  failureBlock:(failureBlock)failure;

/// 开始会话
/// account : 用户accid
/// receiveAccount : 对方 accid
/// 用户类型
+ (void)startSessionWithAccount : (NSString *)account
                 receiveAccount : (NSString *)receiveAccount
                           type : (NSString *)type;

/// 获取Accid
/// userId : 用户id
+ (void)getReceiveAccountWithUserId : (NSString *)userId
                        successBlock:(AccInfoBlock) success
                        failureBlock:(failureBlock)failure;

/// 获取快捷回复信息
+ (void)getQuickInfoWithUserId :(NSString *)userId
                   successBlock:(QuickInfoBlock) success
                   failureBlock:(failureBlock)failure;

/// 获取优惠券列表
+ (void)getCouponInfoSuccessBlock:(CouponInfoBlock) success
                     failureBlock:(failureBlock)failure;

/// 发放优惠券
+ (void)sendCouponWithUserId : (NSString *)userId
                   couponIds : (NSArray<NSString *> *) couponIds
                 successBlock:(CouponSendInfoBlock) success
                 failureBlock:(failureBlock)failure;

/// 评价
/// userId ：本人ID
/// evaluatorId : 对方ID （受评人）
/// satisfaction : 满意度
+ (void)evaluationWithUserId : (NSString *)userId
                 evaluatorId : (NSString *)evaluatorId
                satisfaction : (NSString *)satisfaction
                 successBlock:(succeedBlock) success
                 failureBlock:(failureBlock)failure;

/// 校验是否可以评价
/// userId ：本人ID
/// evaluatorId : 对方ID （受评人）
/// satisfaction : 满意度
+ (void)evaluationCheckWithUserId : (NSString *)userId
                      evaluatorId : (NSString *)evaluatorId
                     satisfaction : (NSString *)satisfaction
                      successBlock:(succeedBlock) success
                      failureBlock:(failureBlock)failure;

///查询用户黑名单列表
+ (void)getBlackUserListData:(NSString *)accId
                  completion:(void(^)(NSError *_Nullable error, NSArray *resultArray))completion;
/// 移除黑名单
+ (void)deleteBlackUser:(NSDictionary *)param
             completion:(void(^)(NSError *_Nullable error, BOOL isSuccess))completion;

/// 查询商户所有客服平台
+ (void)getServeceWithUserId : (NSString *)userId
                 successBlock:(succeedBlock) success
                 failureBlock:(failureBlock)failure;
/// 查询商户所有客服平台
+ (void)getServeceWithUserId : (NSString *)userId
                 successBlock:(succeedBlock) success;

/// 查询用户是否支持发送消息
+ (void)checkAppVersionWithUserId : (NSString *)userId
                      successBlock:(succeedBlock) success
                      failureBlock:(failureBlock)failure;
@end

NS_ASSUME_NONNULL_END
