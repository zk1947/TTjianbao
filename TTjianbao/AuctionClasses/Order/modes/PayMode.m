//
//  PayMode.m
//  TTjianbao
//
//  Created by jiangchao on 2019/2/11.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "PayMode.h"
#import "JHUnionPaySDKManager.h"

@implementation PayWayMode
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"Id" : @"id",
             };
}
@end

@implementation JHOrderConfirmReqModel
@end

@implementation JHGoodsOrderDetailReqModel
- (instancetype)init
{
    if(self = [super init])
    {
        self.goodsCount = 1;
    }
    return self;
}
@end

@implementation JHNewStoreOrderDetailReqModel
@end

@implementation JHPrepayReqModel

- (instancetype)init
{
    if(self = [super init])
    {
        self.portalEnum = @"ios";
    }
    return self;
}

@end
@implementation JHRedPacketPrepayReqModel
- (instancetype)init
{
    if(self = [super init])
    {
        self.portalEnum = @"ios";
    }
    return self;
}
@end
@implementation JHRedPacketPrepayRespModel
@end

@implementation JHIntentionReqModel
@end

@implementation PayMode
+ (void)requestOrderPayWays:(NSString *)orderId  completion:(JHApiRequestHandler)completion{
  [HttpRequestTool getWithURL:[FILE_BASE_STRING(@"/payway/all?orderId=") stringByAppendingString:OBJ_TO_STRING(orderId)] Parameters:nil successBlock:^(RequestModel *respondObject) {
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
+ (void)WXOrderPrepay:(JHPrepayReqModel *)reqMode  completion:(JHApiRequestHandler)completion{
    
    if (JH_UNION_ENABLE) {
        [PayMode unionRequestOrderPrepay:reqMode completion:^(RequestModel *respondObject, NSError *error) {
            if (completion) {
                completion(respondObject, error);
            }
        }];
    }
    else{
        
        [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/pay/auth/order/prepay") Parameters:[reqMode mj_keyValues] isEncryption:YES requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
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
//#ifdef JH_UNION_PAY
//    [PayMode unionRequestOrderPrepay:reqMode completion:^(RequestModel *respondObject, NSError *error) {
//        if (completion) {
//            completion(respondObject, error);
//        }
//    }];
//    return;
//#endif
//
//    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/pay/auth/order/prepay") Parameters:[reqMode mj_keyValues] isEncryption:YES requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
//        NSError *error=nil;
//        if (completion) {
//            completion(respondObject,error);
//        }
//
//    } failureBlock:^(RequestModel *respondObject) {
//        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
//                                                    code:respondObject.code
//                                                userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
//        if (completion) {
//            completion(respondObject,error);
//        }
//
//    }];
}
+ (void)ALiOrderPrepay:(JHPrepayReqModel *)reqMode  completion:(JHApiRequestHandler)completion{
    
    if (JH_UNION_ENABLE) {
        [PayMode unionRequestOrderPrepay:reqMode completion:^(RequestModel *respondObject, NSError *error) {
            if (completion) {
                completion(respondObject, error);
            }
        }];
    }
    else{
        [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/pay/auth/order/aliprepay") Parameters:[reqMode mj_keyValues] isEncryption:YES requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
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
//#ifdef JH_UNION_PAY
//    [PayMode unionRequestOrderPrepay:reqMode completion:^(RequestModel *respondObject, NSError *error) {
//        if (completion) {
//            completion(respondObject, error);
//        }
//    }];
//    return;
//#endif
//
//    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/pay/auth/order/aliprepay") Parameters:[reqMode mj_keyValues] isEncryption:YES requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
//        NSError *error=nil;
//        if (completion) {
//            completion(respondObject,error);
//        }
//
//    } failureBlock:^(RequestModel *respondObject) {
//        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
//                                             code:respondObject.code
//                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
//        if (completion) {
//            completion(respondObject,error);
//        }
//
//    }];
    
    
}

+ (void)WXShopPrepay:(JHPrepayReqModel *)reqMode  completion:(JHApiRequestHandler)completion{
    
        [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/pay/auth/shopFund/prepay") Parameters:[reqMode mj_keyValues] isEncryption:YES requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
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
+ (void)ALiShopPrepay:(JHPrepayReqModel *)reqMode  completion:(JHApiRequestHandler)completion{
    
        [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/pay/auth/shopFund/aliprepay") Parameters:[reqMode mj_keyValues] isEncryption:YES requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
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
+ (void)requestOrderPayStatus:(NSString *)outTradeNo  completion:(JHApiRequestHandler)completion{
    if (JH_UNION_ENABLE) {
        NSDictionary *dic = @{@"outTradeNo":outTradeNo};
        [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/pay/auth/ums/pay_status")  Parameters:dic  requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
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
    else{
        
        [HttpRequestTool postWithURL:[FILE_BASE_STRING(@"/pay/auth/order/status?outTradeNo=") stringByAppendingString:OBJ_TO_STRING(outTradeNo)] Parameters:nil  requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
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
//#ifdef JH_UNION_PAY
//    //    /pay/auth/order/status
//    NSDictionary *dic = @{@"outTradeNo":outTradeNo};
//    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/pay/auth/ums/pay_status")  Parameters:dic  requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
//#else
//    [HttpRequestTool postWithURL:[FILE_BASE_STRING(@"/pay/auth/order/status?outTradeNo=") stringByAppendingString:OBJ_TO_STRING(outTradeNo)] Parameters:nil  requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
//
//#endif
//        NSError *error=nil;
//        if (completion) {
//            completion(respondObject,error);
//        }
//
//    } failureBlock:^(RequestModel *respondObject) {
//        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
//                                             code:respondObject.code
//                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
//        if (completion) {
//            completion(respondObject,error);
//        }
//    }];
    
    
}
+ (void)requestRecycleOrderPayStatus:(NSString *)outTradeNo  completion:(JHApiRequestHandler)completion{
    
    [HttpRequestTool postWithURL:[FILE_BASE_STRING(@"/pay/auth/order/status?outTradeNo=") stringByAppendingString:OBJ_TO_STRING(outTradeNo)] Parameters:nil  requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
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

+(void)WXPay:(WXPayDataMode*)pay{
           
    if (JH_UNION_ENABLE) {
        [PayMode unionPayWithType:JHPayTypeWxPay data:pay.appPayRequest completBlock:^(id obj) {

           }];
    }
    else{
        PayReq *request = [[PayReq alloc] init] ;
          request.partnerId = pay.partnerid;
          request.prepayId= pay.prepayid;
          request.package = pay.package;
          request.nonceStr= pay.noncestr;
          request.timeStamp= pay.timestamp;
          request.sign= pay.sign;
          [WXApi sendReq:request completion:^(BOOL success) {
              
          }];
        
    }
//#ifdef JH_UNION_PAY
//    [PayMode unionPayWithType:JHPayTypeWxPay data:pay.appPayRequest completBlock:^(id obj) {
//
//    }];
//#else
//    PayReq *request = [[PayReq alloc] init] ;
//    request.partnerId = pay.partnerid;
//    request.prepayId= pay.prepayid;
//    request.package = pay.package;
//    request.nonceStr= pay.noncestr;
//    request.timeStamp= pay.timestamp;
//    request.sign= pay.sign;
//    [WXApi sendReq:request completion:^(BOOL success) {
//
//    }];
//#endif
    
}
+(void)AliPay:(NSString*)orderString callback:(JHActionBlock)completionBlock{
    
    if (JH_UNION_ENABLE) {
        [PayMode unionPayWithType:JHPayTypeAliPay data:orderString completBlock:^(id obj) {
            if (completionBlock) {
                completionBlock(obj);
            }
        }];
    }
    else{
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:AlipayScheme callback:^(NSDictionary *resultDic) {
               completionBlock(resultDic);
           }];
        
    }
//#ifdef JH_UNION_PAY
//    [PayMode unionPayWithType:JHPayTypeAliPay data:orderString completBlock:^(id obj) {
//        if (completionBlock) {
//            completionBlock(obj);
//        }
//    }];
//#else
//    [[AlipaySDK defaultService] payOrder:orderString fromScheme:AlipayScheme callback:^(NSDictionary *resultDic) {
//        completionBlock(resultDic);
//    }];
//#endif
}
+(NSArray *)sortbyPay:(NSArray *)array{
    NSArray *sorteArray = [array sortedArrayUsingComparator:^(id obj1, id obj2){
        PayWayMode *mode1 = (PayWayMode *)obj1;
        PayWayMode *mode2 = (PayWayMode *)obj2;
        if (mode1.sort > mode2.sort) {
            return (NSComparisonResult)NSOrderedDescending;
        }else if (mode1.sort < mode2.sort){
            return (NSComparisonResult)NSOrderedAscending;
        }
        else
            return (NSComparisonResult)NSOrderedSame;
        
    }];
    return sorteArray;
}

+ (void)redPacketPrepay:(JHRedPacketPrepayReqModel *)reqMode  completion:(JHApiRequestHandler)completion{

    if (JH_UNION_ENABLE) {
        [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/red-packet/pay_v2") Parameters:[reqMode mj_keyValues] isEncryption:NO requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
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
    else{
        [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/red-packet/pay") Parameters:[reqMode mj_keyValues] isEncryption:NO requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
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
//#ifdef JH_UNION_PAY
////    /app/red-packet/pay
//    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/red-packet/pay_v2") Parameters:[reqMode mj_keyValues] isEncryption:NO requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
//#else
//    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/red-packet/pay") Parameters:[reqMode mj_keyValues] isEncryption:NO requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
//#endif
//           NSError *error=nil;
//           if (completion) {
//               completion(respondObject,error);
//           }
//
//       } failureBlock:^(RequestModel *respondObject) {
//           NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
//                                                code:respondObject.code
//                                            userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
//           if (completion) {
//               completion(respondObject,error);
//           }
//
//       }];
//
    
}
+ (void)requestPacketPayStatus:(NSString *)outTradeNo  completion:(JHApiRequestHandler)completion{
    if (JH_UNION_ENABLE) {
        [self requestOrderPayStatus:outTradeNo completion:completion];
    }
    else{
        [HttpRequestTool postWithURL:[FILE_BASE_STRING(@"/payrecord/auth/status?outTradeNo=") stringByAppendingString:OBJ_TO_STRING(outTradeNo)] Parameters:nil  requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
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
    
//#ifdef JH_UNION_PAY
//    [self requestOrderPayStatus:outTradeNo completion:completion];
//    return;
//#endif
//    [HttpRequestTool postWithURL:[FILE_BASE_STRING(@"/payrecord/auth/status?outTradeNo=") stringByAppendingString:OBJ_TO_STRING(outTradeNo)] Parameters:nil  requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
//        NSError *error=nil;
//        if (completion) {
//            completion(respondObject,error);
//        }
//
//    } failureBlock:^(RequestModel *respondObject) {
//        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
//                                             code:respondObject.code
//                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
//        if (completion) {
//            completion(respondObject,error);
//        }
//    }];
    
  
}

+ (void)unionPayWithType:(JHPayType)type data:(id)data completBlock:(JHActionBlock)block {
    [JHUnionPaySDKManager payWithPayChannelType:type payData:data callbackBlock:^(JHUnionPayResultInfo * _Nonnull result) {
        if (!result.isSuccess) {
            [SVProgressHUD showErrorWithStatus:result.resultMsg];
        }
        if (block) {
            block([result mj_keyValues]);
        }
    }];
}

/// 银联支付 预支付接口
/// @param reqMode reqMode description
/// @param completion completion description
+ (void)unionRequestOrderPrepay:(JHPrepayReqModel *)reqMode  completion:(JHApiRequestHandler)completion {
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/pay/auth/ums/order_prepay") Parameters:[reqMode mj_keyValues] isEncryption:YES requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        NSError *error = nil;
        if (completion) {
            completion(respondObject, error);
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(respondObject, error);
        }
        
    }];
}

@end
