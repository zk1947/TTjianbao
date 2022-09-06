//
//  JHRecycleOrderDetailBusiness.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/3/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleOrderDetailBusiness.h"

@implementation JHRecycleOrderDetailBusiness

/// 获取订单详情
/// orderId : 订单ID
+ (void)getOrderInfoWithOrderId : (NSString *)orderId
                    successBlock:(detailInfoBlock) success
                    failureBlock:(failureBlock)failure {
    
    NSDictionary *par = @{@"orderId" : orderId};
    NSString *url = FILE_BASE_STRING(@"/order/capi/recycleOrderToC/auth/detailByCustomer");
    
    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        NSDictionary *dic = respondObject.data;
        JHRecycleOrderDetailModel *model = [JHRecycleOrderDetailModel mj_objectWithKeyValues:dic];
        success(model);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        failure(respondObject);
    }];
}

/// 用户关闭订单
/// orderId : 订单ID
/// msg : 关闭原因
+ (void)orderCloseWithOrderId : (NSString *)orderId
                          msg : (NSString *)msg
                  successBlock:(succeedBlock) success
                  failureBlock:(failureBlock)failure{
    
    NSDictionary *par = @{
        @"orderId" : orderId,
        @"cancelReason" : msg != nil ? msg : @"",
    };
    NSString *url = FILE_BASE_STRING(@"/order/capi/recycleOrderToC/auth/closeDeal");
    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        success(respondObject);
    
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        failure(respondObject);
    }];
}

/// 用户取消订单
/// msg : 取消原因
+ (void)orderCancelWithOrderId : (NSString *)orderId
                           msg : (NSString *)msg
                   successBlock:(succeedBlock) success
                   failureBlock:(failureBlock)failure{
    NSDictionary *par = @{
        @"orderId" : orderId,
        @"cancelReason" : msg != nil ? msg : @"",
    };
    NSString *url = FILE_BASE_STRING(@"/order/capi/recycleOrderToC/auth/cancelOrder");
    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        success(respondObject);
    
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        failure(respondObject);
    }];
}

/// 用户确认交易
/// orderId : 订单ID
+ (void)orderAcceptWithOrderId : (NSString *)orderId
                   successBlock:(succeedBlock) success
                   failureBlock:(failureBlock)failure{
    
    NSDictionary *par = @{
        @"orderId" : orderId,
    };
    NSString *url = FILE_BASE_STRING(@"/order/capi/recycleOrderToC/auth/accept");
    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        success(respondObject);
    
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        failure(respondObject);
    }];
}

/// 用户确认收货
/// orderId : 订单ID
+ (void)orderReceivedWithOrderId : (NSString *)orderId
                   successBlock:(succeedBlock) success
                     failureBlock:(failureBlock)failure{
    
    NSDictionary *par = @{
        @"orderId" : orderId,
    };
    NSString *url = FILE_BASE_STRING(@"/order/capi/recycleOrderToC/auth/confirmReceipt");
    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        success(respondObject);
    
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        failure(respondObject);
    }];
}

/// 用户删除订单
/// orderId : 订单ID
+ (void)orderDeleteWithOrderId : (NSString *)orderId
                   successBlock:(succeedBlock) success
                   failureBlock:(failureBlock)failure{
    
    NSDictionary *par = @{
        @"orderId" : orderId,
    };
    NSString *url = FILE_BASE_STRING(@"/order/capi/recycleOrderToB/auth/delete");
    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        success(respondObject);
    
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        failure(respondObject);
    }];
}

/// 用户确认销毁
/// orderId : 订单ID
+ (void)orderDestoryWithOrderId : (NSString *)orderId
                    successBlock:(succeedBlock) success
                    failureBlock:(failureBlock)failure{
    
    NSDictionary *par = @{
        @"orderId" : orderId,
    };
    NSString *url = FILE_BASE_STRING(@"/order/capi/recycleOrderToC/auth/sureDestroy");
    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        success(respondObject);
    
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        failure(respondObject);
    }];
}

/// 用户申请寄回
/// orderId : 订单ID
+ (void)orderReturnWithOrderId : (NSString *)orderId
                   successBlock:(succeedBlock) success
                   failureBlock:(failureBlock)failure{
    
    NSDictionary *par = @{
        @"orderId" : orderId,
    };
    NSString *url = FILE_BASE_STRING(@"/order/capi/recycleOrderToC/auth/applyReturn");
    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        success(respondObject);
    
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        failure(respondObject);
    }];
}
/// 取消理由
/// orderId : 订单ID
+ (void)getOrderCancelListSuccessBlock:(cancelInfoBlock) success
                          failureBlock:(failureBlock)failure {
    
    NSDictionary *par = @{};
    NSString *url = FILE_BASE_STRING(@"/order/capi/recycleOrderToC/auth/cancelReasons");
    
    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        NSDictionary *dic = respondObject.data;
        NSArray *list = [JHRecycleCancelModel mj_objectArrayWithKeyValuesArray:dic];
        success(list);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        failure(respondObject);
    }];
}

+ (void)getOrderCancelListWithRequestType:(NSInteger)requestType SuccessBlock:(cancelInfoBlock)success failureBlock:(failureBlock)failure {
    NSDictionary *par = @{};
    NSString *url = FILE_BASE_STRING(@"/order/marketOrder/auth/cancelReason");
    
    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        NSDictionary *dic = [NSDictionary dictionary];
        if (requestType == 1) {
            dic = respondObject.data[@"buyerCancelReasons"];
        } else if (requestType == 2) {
            dic = respondObject.data[@"sellerCancelReasons"];
        }
        NSArray *list = [JHRecycleCancelModel mj_objectArrayWithKeyValuesArray:dic];
        success(list);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        failure(respondObject);
    }];
}

+ (void)getAppraisalOrderCancelListWithRequestSuccessBlock:(cancelInfoBlock)success failureBlock:(failureBlock)failure {
    NSDictionary *par = @{};
    NSString *url = FILE_BASE_STRING(@"/order/appraisalOrder/auth/cancelReasons");
    
    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        NSDictionary *dic = respondObject.data;
        NSArray *list = [JHRecycleCancelModel mj_objectArrayWithKeyValuesArray:dic];
        success(list);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        failure(respondObject);
    }];
}

+ (void)getrefuseReasonListWithRequestSuccessBlock:(cancelInfoBlock)success failureBlock:(failureBlock)failure {
    NSDictionary *par = @{};
    NSString *url = FILE_BASE_STRING(@"/order/marketOrder/auth/refuseReasonList");
    
    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        NSDictionary *dic = respondObject.data;
        NSArray *list = [JHRecycleCancelModel mj_objectArrayWithKeyValuesArray:dic];
        success(list);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        failure(respondObject);
    }];
}



@end
