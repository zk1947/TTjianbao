//
//  JHOrderViewMode.m
//  TTjianbao
//
//  Created by jiang on 2019/8/9.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHOrderViewModel.h"
#import "TTjianbaoHeader.h"
#import "JHAntiFraud.h"

@implementation JHOrderViewModel
+ (void)OrderPayCheckWithOrderId:(NSString *)order_id
                      completion:(JHOrderPayCheckoutHandler)completion{
    [HttpRequestTool getWithURL:[FILE_BASE_STRING(@"/order/auth/comparativeTest?orderId=") stringByAppendingString:OBJ_TO_STRING(order_id)] Parameters:nil successBlock:^(RequestModel *respondObject) {
        NSError *error=nil;
        completion(respondObject,error);
        
    } failureBlock:^(RequestModel *respondObject) {
        
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        completion(respondObject,error);
    }];
}

+ (void)OrderPayCheckTest2WithOrderId:(NSString *)order_id
                      completion:(JHOrderPayCheckoutHandler)completion{
    [HttpRequestTool getWithURL:[FILE_BASE_STRING(@"/order/auth/comparativeTest2?orderId=") stringByAppendingString:OBJ_TO_STRING(order_id)] Parameters:nil successBlock:^(RequestModel *respondObject) {
        NSError *error=nil;
        completion(respondObject,error);
        
    } failureBlock:^(RequestModel *respondObject) {
        
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        completion(respondObject,error);
    }];
}


+ (void)getOrderExportInfoByStartTime:(NSString *)startTime endTime:(NSString*)endTime
                           completion:(JHApiRequestHandler)completion{
    NSString *beginTimeSp = [NSString stringWithFormat:@"%ld",(long)[CommHelp timeSwitchTimestamp:startTime]*1000];
    NSString *endTimeSp = [NSString stringWithFormat:@"%ld",(long)[CommHelp timeSwitchTimestamp:endTime]*1000];
    NSDictionary *dic=@{@"startTime":beginTimeSp,@"endTime":endTimeSp};
    NSString *url =FILE_BASE_STRING(@"/order/auth/export");
    [HttpRequestTool postWithURL:url   Parameters:dic   requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        NSError *error=nil;
        if (completion) {
            completion(respondObject,error);
        }
    } failureBlock:^(RequestModel *respondObject) {
        
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(respondObject,error);
        }
    }];
}

+ (void)alterOrderAddressByOrderId:(NSString *)orderId andAddressId:(NSString*)addresId
                        completion:(JHApiRequestHandler)completion{
    
    NSDictionary *dic=@{@"orderId":orderId,@"addressId":addresId};
    NSString *url =FILE_BASE_STRING(@"/order/auth/changeAddress");
    [HttpRequestTool postWithURL:url   Parameters:dic   requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        NSError *error=nil;
        if (completion) {
            completion(respondObject,error);
        }
    } failureBlock:^(RequestModel *respondObject) {
        
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(respondObject,error);
        }
    }];
    
}
+ (void)checkOrderAddress:( AdressMode*)address completion:(JHApiRequestHandler)completion{
    NSMutableDictionary *dic=[address mj_keyValues];
    NSString *url =FILE_BASE_STRING(@"/auth/address/validReceiverName");
    [HttpRequestTool postWithURL:url   Parameters:dic   requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        NSError *error=nil;
        if (completion) {
            completion(respondObject,error);
        }
    } failureBlock:^(RequestModel *respondObject) {
        
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(respondObject,error);
        }
    }];
    
}
+ (void)requestOrderIntentionByOrderId:(JHIntentionReqModel *)reqMode completion:(JHApiRequestHandler)completion{
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/stone-restore/find-order-confirm-info") Parameters:[reqMode mj_keyValues] requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error=nil;
        if (completion) {
            completion(respondObject,error);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(respondObject,error);
        }
    }];
    
    
}
+ (void)requestOrderDetail:(NSString *)orderId isSeller:(BOOL)isSeller completion:(JHApiRequestHandler)completion{
    User *user = [UserInfoRequestManager sharedInstance].user;
    NSString * type;
    if (isSeller) {
        if (user.blRole_restoreAnchor) {
            type=@"3";
        }
        else if (user.blRole_restoreAssistant) {
            type=@"4";
        }
        else if (user.blRole_customize) {
            type=@"9";
        }
        else if (user.blRole_customizeAssistant) {
            type=@"10";
        }
        else{
            type=user.isAssistant?@"2":@"1";
        }
    }
    else{
        type=@"0";
    }
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/order/auth/detail?orderId=%@&userType=%@"),orderId,type];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        NSError *error=nil;
        if (completion) {
            completion(respondObject,error);
        }
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(respondObject,error);
        }
    }];
}

+ (void)requestStoneOrderDetail:(NSString *)orderId isSeller:(BOOL)isSeller stoneId:(NSString *)stoneId completion:(JHApiRequestHandler)completion{
    NSString * type;
    if (isSeller) {
        type=@"1";
    }
    else{
        type=@"0";
    }
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/stone-restore/find-order-details") Parameters:@{@"orderId":orderId,@"userType":type,@"stoneRestoreId":stoneId?:@""} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error=nil;
        if (completion) {
            completion(respondObject,error);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(respondObject,error);
        }
    }];
    
}
+ (void)requestOrderConfirmDetail:(NSString *)orderId  completion:(JHApiRequestHandler)completion{
    NSString * sm_deviceId = [JHAntiFraud deviceId];
    NSDictionary * parameters=@{
                                @"sm_deviceId":sm_deviceId
                                };
    [HttpRequestTool getWithURL:[FILE_BASE_STRING(@"/order/auth/confirming?orderId=") stringByAppendingString:OBJ_TO_STRING(orderId)] Parameters:parameters successBlock:^(RequestModel *respondObject) {
        NSError *error=nil;
        if (completion) {
            completion(respondObject,error);
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(respondObject,error);
        }
    }];
    
    
}
+ (void)ConfirmOrder:(JHOrderConfirmReqModel *)reqMode  completion:(JHApiRequestHandler)completion{
    NSMutableDictionary* parameters = [reqMode mj_keyValues];
    NSString * sm_deviceId = [JHAntiFraud deviceId];
    [parameters setObject:(sm_deviceId ? : @"") forKey:@"sm_deviceId"];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/auth/confirming") Parameters:parameters requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
      NSError *error=nil;
             if (completion) {
                 completion(respondObject,error);
             }
        
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(respondObject,error);
        }
    }];
    
    
}
+ (void)requestGoodsConfirmDetail:(JHGoodsOrderDetailReqModel *)reqMode  completion:(JHApiRequestHandler)completion{
    
    NSMutableDictionary *dic = [reqMode mj_keyValues];
    NSString * sm_deviceId = [JHAntiFraud deviceId];
    [dic setObject:(sm_deviceId ? : @"") forKey:@"sm_deviceId"];
    
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/charge-order/authoptional/getGoodsDetailForOrder") Parameters:dic successBlock:^(RequestModel *respondObject) {
        NSError *error=nil;
        if (completion) {
            completion(respondObject,error);
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(respondObject,error);
        }
    }];
}

+ (void)ConfirmGoodsOrder:(JHOrderConfirmReqModel *)reqMode  completion:(JHApiRequestHandler)completion{
    NSMutableDictionary *dic = [reqMode mj_keyValues];
    NSString * sm_deviceId = [JHAntiFraud deviceId];
    [dic setObject:(sm_deviceId ? : @"") forKey:@"sm_deviceId"];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/charge-order/auth/confirmOrder") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
         NSError *error=nil;
                if (completion) {
                    completion(respondObject,error);
                }
           
       } failureBlock:^(RequestModel *respondObject) {
           NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                code:respondObject.code
                                            userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
           if (completion) {
               completion(respondObject,error);
           }
       }];
    
}
+ (void)remindOrderSend:(NSString *)orderId  completion:(JHApiRequestHandler)completion{
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/auth/remindSelleSent") Parameters:@{@"orderId":orderId} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
            NSError *error=nil;
                   if (completion) {
                       completion(respondObject,error);
                   }
              
          } failureBlock:^(RequestModel *respondObject) {
              NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                   code:respondObject.code
                                               userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
              if (completion) {
                  completion(respondObject,error);
              }
          }];
}


+ (void)requestNewStoreConfirmDetail:(JHNewStoreOrderDetailReqModel *)reqMode  completion:(JHApiRequestHandler)completion{
    
    NSMutableDictionary *dic = [reqMode mj_keyValues];
    NSString * sm_deviceId = [JHAntiFraud deviceId];
    [dic setObject:(sm_deviceId ? : @"") forKey:@"sm_deviceId"];
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/order/buildOrder") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        NSError *error=nil;
        if (completion) {
            completion(respondObject,error);
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(respondObject,error);
        }
    }];
}

+ (void)requestNewStoreConfirmDetailC2C:(JHNewStoreOrderDetailReqModel *)reqMode  completion:(JHApiRequestHandler)completion {
    
    NSMutableDictionary *dic = [reqMode mj_keyValues];
    NSString * sm_deviceId = [JHAntiFraud deviceId];
    [dic setObject:(sm_deviceId ? : @"") forKey:@"sm_deviceId"];
    [dic setObject:@(1) forKey:@"productCount"];
    [dic setObject:@(11) forKey:@"orderType"];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/order/buildOrderC2c") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        NSError *error=nil;
        if (completion) {
            completion(respondObject,error);
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(respondObject,error);
        }
    }];
}

+ (void)ConfirmNewStoreOrder:(JHOrderConfirmReqModel *)reqMode  completion:(JHApiRequestHandler)completion{
    NSMutableDictionary *dic = [reqMode mj_keyValues];
    NSString * sm_deviceId = [JHAntiFraud deviceId];
    [dic setObject:(sm_deviceId ? : @"") forKey:@"sm_deviceId"];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/auth/mall/order/createOrder") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
         NSError *error=nil;
                if (completion) {
                    completion(respondObject,error);
                }
           
       } failureBlock:^(RequestModel *respondObject) {
           NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                code:respondObject.code
                                            userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
           if (completion) {
               completion(respondObject,error);
           }
       }];
    
}

+ (void)buildOrderC2cOrder:(JHOrderConfirmReqModel *)reqMode  completion:(JHApiRequestHandler)completion {
    NSMutableDictionary *dic = [reqMode mj_keyValues];
    NSString * sm_deviceId = [JHAntiFraud deviceId];
    [dic setObject:(sm_deviceId ? : @"") forKey:@"sm_deviceId"];
    [dic setObject:@(1) forKey:@"productCount"];
    [dic setObject:@(11) forKey:@"orderType"];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/auth/mall/order/buyoutPrice") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
         NSError *error=nil;
                if (completion) {
                    completion(respondObject,error);
                }
           
       } failureBlock:^(RequestModel *respondObject) {
           NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                code:respondObject.code
                                            userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
           if (completion) {
               completion(respondObject,error);
           }
       }];
    
}

/// C2C 确认订单的接口
+ (void)mekeOrderC2cOrder:(NSDictionary *)dict  completion:(JHApiRequestHandler)completion {
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary: dict];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/marketOrder/auth/confirm") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
         NSError *error=nil;
                if (completion) {
                    completion(respondObject,error);
                }
           
       } failureBlock:^(RequestModel *respondObject) {
           NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                code:respondObject.code
                                            userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
           if (completion) {
               completion(respondObject,error);
           }
       }];
    
}
@end
