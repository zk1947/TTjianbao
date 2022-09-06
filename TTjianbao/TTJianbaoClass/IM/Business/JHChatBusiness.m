//
//  JHChatBusiness.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatBusiness.h"

@implementation JHChatBusiness

#pragma mark - 获取订单详情信息
+ (void)getOrderInfoWithAccount : (NSString *)account
                 receiveAccount : (NSString *)receiveAccount
                         pageNo : (NSInteger)pageNo
                    successBlock:(orderInfoBlock) success
                    failureBlock:(failureBlock)failure
{
    NSMutableDictionary *par = [[NSMutableDictionary alloc] init];
    [par setValue:account forKey:@"wyAccId"];
    [par setValue:receiveAccount forKey:@"businessAccId"];
    [par setValue:@(pageNo) forKey:@"pageNo"];
    [par setValue:@(PageSize) forKey:@"pageSize"];
    
    NSString *url = FILE_BASE_STRING(@"/app/chat/chat-session/customerOrderList");
    
    [HttpRequestTool getWithURL:url Parameters:par successBlock:^(RequestModel * _Nullable respondObject) {
        NSDictionary *dic = respondObject.data;
        JHChatOrderInfoListModel *model = [JHChatOrderInfoListModel mj_objectWithKeyValues:dic];
       
        if (success == nil) return;
        success(model);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (failure == nil) return;
        failure(respondObject);
    }];
}

#pragma mark - 获取用户信息
+ (void)getUserInfoWithId : (NSString *)userId
              successBlock:(userInfoBlock) success
              failureBlock:(failureBlock)failure
{
    NSDictionary *par = @{@"wyAccId" : userId};
    NSString *url = FILE_BASE_STRING(@"/app/chat/chat-session/customerInfo");
    [HttpRequestTool getWithURL:url Parameters:par successBlock:^(RequestModel * _Nullable respondObject) {
        NSDictionary *dic = respondObject.data;
        JHChatUserInfo *model = [JHChatUserInfo mj_objectWithKeyValues:dic];
        if (success == nil) return;
        success(model);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (failure == nil) return;
        failure(respondObject);
    }];
}
#pragma mark - 拉黑or取消拉黑
+ (void)blackWithBlackAccount : (NSString *)blackAccount
                      isBlack : (BOOL)isBlack
                  successBlock:(succeedBlock) success
                  failureBlock:(failureBlock)failure
{
    NSString *type = isBlack ? @"1" : @"2";
    NSDictionary *par = @{
        @"blockId" : blackAccount,
        @"operatorType" : type,
    };
    
    NSString *url = FILE_BASE_STRING(@"/app/chat/black/addOrCancel");
    
    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (success == nil) return;
        success(respondObject);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        failure(respondObject);
    }];
}
#pragma mark - 开始会话
+ (void)startSessionWithAccount : (NSString *)account
                 receiveAccount : (NSString *)receiveAccount
                           type : (NSString *)type
{
    NSDictionary *par = @{
        @"sponsorAccId" : account,
        @"receiverAccId" : receiveAccount,
        @"sponsorType" : type,
    };
    
    NSString *url = FILE_BASE_STRING(@"/app/chat/chat-session/newSession");
    
    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];
}
/// 获取Accid
/// userId : 用户id
+ (void)getReceiveAccountWithUserId : (NSString *)userId
                        successBlock:(AccInfoBlock) success
                        failureBlock:(failureBlock)failure{
    
    NSDictionary *par = @{@"customerId" : userId};
    NSString *url = FILE_BASE_STRING(@"/app/customer/findByIdWithOutPhone");
    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        NSDictionary *dic = respondObject.data;
        JHChatAccInfo *model = [JHChatAccInfo mj_objectWithKeyValues:dic];
        
        if (success == nil) return;
        success(model);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        failure(respondObject);
    }];
}

/// 获取快捷回复信息
+ (void)getQuickInfoWithUserId :(NSString *)userId
                   successBlock:(QuickInfoBlock) success
                   failureBlock:(failureBlock)failure {
    
    NSDictionary *par = @{@"anchorId" : userId};
    NSString *url = FILE_BASE_STRING(@"/app/chat/quickReplyAudit/quickInfo");
    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        NSArray *list = [JHIMQuickModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        
        if (success == nil) return;
        success(list);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        failure(respondObject);
    }];
}

/// 获取优惠券列表
+ (void)getCouponInfoSuccessBlock:(CouponInfoBlock) success
                     failureBlock:(failureBlock)failure {
    
    NSString *url = FILE_BASE_STRING(@"/discount/capi/coupon_query/business_send_coupon/auth");
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        NSArray *list = [JHChatCouponInfoModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        
        if (success == nil) return;
        success(list);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        failure(respondObject);
    }];
}

/// 发放优惠券
+ (void)sendCouponWithUserId : (NSString *)userId
                   couponIds : (NSArray<NSString *> *) couponIds
                 successBlock:(CouponSendInfoBlock) success
                 failureBlock:(failureBlock)failure {
    
    NSDictionary *par = @{@"customerId" : userId,
                          @"couponIds" : couponIds,};
    
    NSString *url = FILE_BASE_STRING(@"/discount/capi/coupon/user/grant_coupon/auth");
    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        JHChatCouponSendModel *model = [JHChatCouponSendModel mj_objectWithKeyValues:respondObject.data];
        
        if (success == nil) return;
        success(model);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        failure(respondObject);
    }];
}
/// 评价
/// userId ：本人ID
/// evaluatorId : 对方ID （受评人）
/// satisfaction : 满意度
+ (void)evaluationWithUserId : (NSString *)userId
                 evaluatorId : (NSString *)evaluatorId
                satisfaction : (NSString *)satisfaction
                 successBlock:(succeedBlock) success
                 failureBlock:(failureBlock)failure {
    
    NSDictionary *par = @{@"evaluatorId" : userId, @"toEvaluatedId" : evaluatorId, @"satisfaction" : satisfaction, };

    NSString *url = FILE_BASE_STRING(@"/app/chat/chat-session/service/evaluation");

    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
    
        if (success == nil) return;
        success(respondObject);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        failure(respondObject);
    }];
}
/// 校验是否可以评价
/// userId ：本人ID
/// evaluatorId : 对方ID （受评人）
/// satisfaction : 满意度
+ (void)evaluationCheckWithUserId : (NSString *)userId
                 evaluatorId : (NSString *)evaluatorId
                satisfaction : (NSString *)satisfaction
                 successBlock:(succeedBlock) success
                 failureBlock:(failureBlock)failure {
    
    NSDictionary *par = @{@"evaluatorId" : userId, @"toEvaluatedId" : evaluatorId, @"satisfaction" : satisfaction, };

    NSString *url = FILE_BASE_STRING(@"/app/chat/chat-session/check-evaluation-qualification");

    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
    
        if (success == nil) return;
        success(respondObject);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        failure(respondObject);
    }];
}
/// 黑名单列表
/// @param accId 用户ID
/// @param completion <#completion description#>
+ (void)getBlackUserListData:(NSString *)accId completion:(void(^)(NSError *_Nullable error, NSArray *resultArray))completion{
    NSString *url = FILE_BASE_STRING(@"/app/chat/black/list");
    NSDictionary *par = @{@"accId" : accId};
    [HttpRequestTool getWithURL:url Parameters:par successBlock:^(RequestModel * _Nullable respondObject) {
        NSArray *resultArray = [NSArray modelArrayWithClass:[JHChatBlackUserModel class] json:respondObject.data];
        if (!resultArray || resultArray.count < 1) {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
            return;
        }
        if (completion) {
            completion(nil,resultArray);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(error,nil);
        }
    }];
}
/// 删除黑名单
/// @param param 入参
/// @param completion <#completion description#>
+ (void)deleteBlackUser:(NSDictionary *)param completion:(void(^)(NSError *_Nullable error, BOOL isSuccess))completion;{
    NSString *url = FILE_BASE_STRING(@"/app/chat/black/addOrCancel");
    [HttpRequestTool postWithURL:url Parameters:param requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        BOOL isSuccess = respondObject.data;
        if (completion) {
            completion(nil,isSuccess);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(error,nil);
        }
    }];
}
/// 查询商户所有客服平台
+ (void)getServeceWithUserId : (NSString *)userId
                 successBlock:(succeedBlock) success
                 failureBlock:(failureBlock)failure {
    
    NSDictionary *par = @{@"customerId" : userId};
    NSString *url = FILE_BASE_STRING(@"/app/shop-business-lines/findServiceTypeById");
    [HttpRequestTool getWithURL:url Parameters:par successBlock:^(RequestModel * _Nullable respondObject) {
        if (success == nil) return;
        success(respondObject);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        failure(respondObject);
    }];
}
/// 查询商户所有客服平台
+ (void)getServeceWithUserId : (NSString *)userId
                 successBlock:(succeedBlock) success {
    
    NSDictionary *par = @{@"customerId" : userId};
    NSString *url = FILE_BASE_STRING(@"/app/shop-business-lines/findServiceTypeById");
    [HttpRequestTool getWithURL:url Parameters:par successBlock:^(RequestModel * _Nullable respondObject) {
        if (success == nil) return;
        success(respondObject);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];
}

/// 查询用户是否支持发送消息
+ (void)checkAppVersionWithUserId : (NSString *)userId
                      successBlock:(succeedBlock) success
                      failureBlock:(failureBlock)failure {
    
    NSDictionary *par = @{@"customerId" : userId};
    NSString *url = FILE_BASE_STRING(@"/app/shop-business-lines/findServiceTypeById");
    [HttpRequestTool getWithURL:url Parameters:par successBlock:^(RequestModel * _Nullable respondObject) {
        if (success == nil) return;
        success(respondObject);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];
}
@end
