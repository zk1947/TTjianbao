//
//  JHMarketOrderViewModel.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketOrderViewModel.h"

@implementation JHMarketOrderViewModel
/**---------------------------订单篇--------------------------------*/
+ (void)getOrderList:(NSMutableDictionary *)params isBuyer:(BOOL)isBuyer Completion:(void (^)(NSError * _Nullable, NSArray<JHMarketOrderModel *> * _Nullable))completion {
    NSString *urlString = isBuyer ? FILE_BASE_STRING(@"/order/marketOrder/auth/buyerList") : FILE_BASE_STRING(@"/order/marketOrder/auth/sellerList");
    [HttpRequestTool postWithURL:urlString Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        if (respondObject.code == 1000) {
            NSArray *array = [JHMarketOrderModel mj_objectArrayWithKeyValuesArray:respondObject.data[@"resultList"]];
            if (completion) {
                completion(nil,array);
            }
        }else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
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

+ (void)orderDetail:(NSMutableDictionary *)params isBuyer:(BOOL)isBuyer Completion:(void (^)(NSError * _Nullable, JHMarketOrderModel * _Nullable))completion {
    NSString *urlString = isBuyer ? FILE_BASE_STRING(@"/order/marketOrder/auth/buyerDetail") : FILE_BASE_STRING(@"/order/marketOrder/auth/sellerDetail");
    [HttpRequestTool postWithURL:urlString Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.code == 1000) {
            JHMarketOrderModel *orderModel = [JHMarketOrderModel mj_objectWithKeyValues:respondObject.data];
            if (completion) {
                completion(nil,orderModel);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
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

///取消订单接口
+ (void)cancelOrder:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, NSDictionary *_Nullable data))completion {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/marketOrder/auth/cancelOrder") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.code == 1000) {
            if (completion) {
                completion(nil, respondObject.data);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
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

///修改价格接口
+ (void)updatePrice:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, NSDictionary *_Nullable data))completion {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/marketOrder/auth/updatePrice") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.code == 1000) {
            if (completion) {
                completion(nil, respondObject.data);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
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

///提醒发货
+ (void)remindShip:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, NSDictionary *_Nullable data))completion {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/marketOrder/auth/remindShip") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.code == 1000) {
            if (completion) {
                completion(nil, respondObject.data);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
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

///确认收货
+ (void)signOrder:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, NSDictionary *_Nullable data))completion {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/marketOrder/auth/sign") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.code == 1000) {
            if (completion) {
                completion(nil, respondObject.data);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
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

///删除订单
+ (void)deleteOrder:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, NSDictionary *_Nullable data))completion {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/marketOrder/auth/delete") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.code == 1000) {
            if (completion) {
                completion(nil, respondObject.data);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
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
/// 删除商品-我发布的
+ (void)deletePublishGoods : (NSString *)productId Completion:(void (^)(NSError * _Nullable error, NSDictionary *_Nullable data))completion{
    NSDictionary *params = @{
        @"productId" : productId,
    };
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/product/c2c/delete") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.code == 1000) {
            if (completion) {
                completion(nil, respondObject.data);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
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
///提醒收货
+ (void)remindReceipt:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable error, NSDictionary *_Nullable data))completion {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/marketOrder/auth/remindReceipt") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.code == 1000) {
            if (completion) {
                completion(nil, respondObject.data);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
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

+(void)refundDetailRequest:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable, NSDictionary * _Nullable))completion {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/auth/marketOrder/applyRefundPage") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.code == 1000) {
            if (completion) {
                completion(nil, respondObject.data);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
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

+ (void)refundRequest:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable, NSDictionary * _Nullable))completion {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/marketOrder/auth/applyRefund") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.code == 1000) {
            if (completion) {
                completion(nil, respondObject.data);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
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

+ (void)commentRequest:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable, NSDictionary * _Nullable))completion {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/orderComment/auth/gen") Parameters:params requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.code == 1000) {
            if (completion) {
                completion(nil, respondObject.data);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
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

+ (void)closeOrder:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable, NSDictionary * _Nullable))completion {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/marketOrder/auth/closeDeal") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.code == 1000) {
            if (completion) {
                completion(nil, respondObject.data);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
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

+ (void)getRefundDetailData:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable, NSDictionary * _Nullable))completion {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/marketOrder/auth/applyRefundPage") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.code == 1000) {
            if (completion) {
                completion(nil, respondObject.data);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
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



/**---------------------------发布篇--------------------------------*/
+ (void)getPublishList:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable, NSArray<JHMarketPublishModel *> * _Nullable, NSInteger, BOOL))completion {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/product/myPubProductList") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        if (respondObject.code == 1000) {
            NSArray *array = [JHMarketPublishModel mj_objectArrayWithKeyValuesArray:respondObject.data[@"resultList"]];
            if (completion) {
                completion(nil,array,[[NSString stringWithFormat:@"%@", respondObject.data[@"exposureNum"]] integerValue], [[NSString stringWithFormat:@"%@", respondObject.data[@"polished"]] integerValue]);
            }
        }else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil, 0, NO);
            }
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(error,nil, 0, NO);
        }
    }];
}

///查询单条
+(void)getSinglePublishList:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable, NSArray<JHMarketPublishModel *> * _Nullable))completion {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/product/myPubSingleProduct") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        if (respondObject.code == 1000) {
            NSArray *array = [JHMarketPublishModel mj_objectArrayWithKeyValuesArray:@[respondObject.data]];
            if (completion) {
                completion(nil,array);
            }
        }else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
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

+ (void)highlightPublishList:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable, NSDictionary * _Nullable))completion {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/product/myPubPolish") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.code == 1000) {
            if (completion) {
                completion(nil, respondObject.data);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
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

+ (void)updateGoodsStatus:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable, NSDictionary * _Nullable))completion {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/product/update/productStatus") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.code == 1000) {
            if (completion) {
                completion(nil, respondObject.data);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
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

+ (void)updateProductPrice:(NSMutableDictionary *)params Completion:(void (^)(NSError * _Nullable, NSDictionary * _Nullable))completion {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/product/updateProductPrice") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.code == 1000) {
            if (completion) {
                completion(nil, respondObject.data);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
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
+ (void)confirmAppriaseOrderDetail:(NSDictionary *)params completion:(JHApiRequestHandler)completion{
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/appraisalOrder/auth/confirmPage") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
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
+ (void)appriaseOrderPreparePay:(NSDictionary *)params completion:(JHApiRequestHandler)completion{
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/appraisalOrder/auth/confirmOrder") Parameters:params isEncryption:YES requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
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
+ (void)appriaseProductAuth:(NSDictionary *)params Completion:(void (^)(NSError * _Nullable error, JHMarketProductAuthModel *_Nullable model))completion {
    NSString *url = FILE_BASE_STRING(@"/api/mall/product/auth");
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        if (respondObject.code == 1000) {
            NSDictionary *dic = respondObject.data;
            JHMarketProductAuthModel *model = [JHMarketProductAuthModel mj_objectWithKeyValues:dic];
            if (completion) {
                completion(nil, model);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(error, nil);
        }
    }];
}

+ (void)getEditGoodsData:(NSDictionary *)params Completion:(void (^)(NSError * _Nullable error, JHIssueGoodsEditModel *_Nullable model))completion{
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/product/productPubDataBuild") Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {

        JHIssueGoodsEditModel *model = [JHIssueGoodsEditModel  mj_objectWithKeyValues:respondObject.data];
        if (model) {
            if (completion) {
                completion(nil, model);
            }
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error, nil);
            }
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

@end
