//
//  JHC2CProductDetailBusiness.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/6/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CProductDetailBusiness.h"

@implementation JHC2CProductDetailBusiness


+ (void)requestC2CProductDetailProductID:(NSString *)productID completion:(void (^)(NSError * _Nullable, JHC2CProoductDetailModel * _Nullable))completion{
    
//    JHC2CProoductDetailModel *model = [JHC2CProoductDetailModel  mj_objectWithKeyValues:[self getSeleTestDic]];
//    completion(nil, model);

    NSMutableDictionary* par = [NSMutableDictionary dictionary];
    par[@"productId"] = productID;
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/product/c2c/detail") Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        JHC2CProoductDetailModel *model = [JHC2CProoductDetailModel  mj_objectWithKeyValues:respondObject.data];
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
+ (void)requestC2CProductComment:(NSDictionary *)parDic completion:(void (^)(NSError * _Nullable, JHC2CProoductDetailModel * _Nullable))completion{
    [HttpRequestTool postWithURL:COMMUNITY_FILE_BASE_STRING(@"/auth/user/comment") Parameters:parDic requestSerializerType:RequestSerializerTypeJson  successBlock:^(RequestModel *respondObject) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         
            JHCommentData *commentData = [JHCommentData modelWithJSON:respondObject.data];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UITipView showTipStr:@"评论成功"];
                completion(nil, nil);
            });
        });
        [SVProgressHUD dismiss];
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [UITipView showTipStr:respondObject.message];
    }];


}

///
+ (void)requestC2CProductDetailPaiMai:(NSString *)auctionSn completion:(void (^)(NSError * _Nullable, JHC2CAuctionRefershModel * _Nullable))completion{
    NSMutableDictionary* par = [NSMutableDictionary dictionary];
    par[@"auctionSn"] = auctionSn;
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/product/auction/refresh") Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        JHC2CAuctionRefershModel *model = [JHC2CAuctionRefershModel  mj_objectWithKeyValues:respondObject.data];
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



+ (void)requestC2CProductDetailPaiMaiList:(NSString *)productID page:(NSNumber *)page completion:(void (^)(NSError * _Nullable, JHC2CJiangPaiListModel * _Nullable))completion{
    NSMutableDictionary* par = [NSMutableDictionary dictionary];
    par[@"auctionSn"] = productID;
    par[@"pageNo"] = page;
    par[@"pageSize"] = @10;
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/product/price/record") Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        JHC2CJiangPaiListModel *model = [JHC2CJiangPaiListModel  mj_objectWithKeyValues:respondObject.data];
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

+ (void)requestC2CProductDetailSeeCount:(NSString *)productID completion:(void (^)(NSError * _Nullable, JHC2CProductDetailUserListModel * _Nullable))completion{
    
    NSMutableDictionary* par = [NSMutableDictionary dictionary];
    par[@"productId"] = productID;
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/product/getViewUserList") Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        JHC2CProductDetailUserListModel *model = [JHC2CProductDetailUserListModel  mj_objectWithKeyValues:respondObject.data];
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
+ (void)requestC2CProductDetailCollectCount:(NSString *)productID completion:(void (^)(NSError * _Nullable, JHC2CProductDetailUserListModel * _Nullable))completion{
    
    NSMutableDictionary* par = [NSMutableDictionary dictionary];
    par[@"productId"] = productID;
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/product/getCollectionUserList") Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        JHC2CProductDetailUserListModel *model = [JHC2CProductDetailUserListModel  mj_objectWithKeyValues:respondObject.data];
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


+ (void)requestC2CProductDetailCollectProduct:(NSDictionary *)dic completion:(void (^)(NSError * _Nullable))completion{
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/product/follow") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.code == 1000) {
            completion(nil);
        }else{
            
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            completion(error);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(error);
        }
    }];

    
    
}

+ (void)requestC2CProductDetailCancleCollectProduct:(NSDictionary *)dic completion:(void (^)(NSError * _Nullable))completion{
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/product/followCancel") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.code == 1000) {
            completion(nil);
        }else{
            
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            completion(error);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(error);
        }
    }];
}

+ (void)requestC2CProductDetailCollectWithProduct:(NSString *)productID completion:(void (^)(NSError * _Nullable, BOOL))completion{
    
    NSMutableDictionary* par = [NSMutableDictionary dictionary];
    par[@"productId"] = productID;
    par[@"customerId"] = UserInfoRequestManager.sharedInstance.user.customerId;

    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/product/followStatus") Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.code == 1000) {
            
            completion(nil,YES);
        }else{
            
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            completion(error,NO);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(error,NO);
        }
    }];

    
    
}


+ (void)requestC2CSetPriceProductSn:(NSString *)productSn andPrice:(NSString*)price isDelegate:(BOOL)delegate completion:(void (^)(NSError * _Nullable))completion{
    
    NSMutableDictionary* par = [NSMutableDictionary dictionary];
    par[@"productSn"] = productSn;
    par[@"agent"] = delegate ? @"1" : @"0";
    par[@"price"] = price;
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/product/auction") Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.code == 1000) {
            completion(nil);
        }else{
            
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            completion(error);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(error);
        }
    }];
}


+ (void)requestC2CCancleSetPriceProductSn:(NSString *)productSn completion:(void (^)(NSError * _Nullable))completion{
    
    NSMutableDictionary* par = [NSMutableDictionary dictionary];
    par[@"productSn"] = productSn;
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/product/auction/cancel") Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.code == 1000) {
            completion(nil);
        }else{
            
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            completion(error);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(error);
        }
    }];
}
+ (void)requestC2CProductSeeOrWant:(NSDictionary *)dic completion:(void (^)(NSError * _Nullable error))completion{
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/product/browse") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.code == 1000) {
            completion(nil);
        }else{
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            completion(error);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(error);
        }
    }];
}

+ (void)requestC2CProductBrowse:(NSDictionary *)dic completion:(void (^)(NSError * _Nullable error, BOOL isFollow))completion{
    NSString *url = COMMUNITY_FILE_BASE_STRING(@"/user/isFollow");
    
    url = [NSString stringWithFormat:@"%@/%@/%@",url,dic[@"user_id"],dic[@"followed_user_id"]];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.code == 1000) {
            NSNumber *follow = respondObject.data[@"is_follow"];
            completion(nil, follow.boolValue);
        }else{
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            completion(error,NO);
        }

    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(error,NO);
        }

    }];

    
}

+ (void)requestC2CPaySureMoney:(NSDictionary *)dic completion:(void (^)(NSError * _Nullable, JHC2CSureMoneyModel *))completion{
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/auth/mall/order/marketDepositOrder") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        JHC2CSureMoneyModel *model = [JHC2CSureMoneyModel  mj_objectWithKeyValues:respondObject.data];
        if (model) {
            completion(nil,model);
        }else{
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            completion(error,nil);
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

+ (void)requestC2CChatCount:(NSString *)parID completion:(void (^)(NSError * _Nullable, NSInteger ))completion{
    
    NSString *url = COMMUNITY_FILE_BASE_STRING(@"/content/getCommentNum?");
    
    url = [NSString stringWithFormat:@"%@item_id=%@",url,parID];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject.code == 1000) {
            NSDictionary *dic = respondObject.data[@"CommentTotalNum"];
            NSNumber *num = [dic allValues].lastObject;
            completion(nil, num.integerValue);
        }else{
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            completion(error,0);
        }

    } failureBlock:^(RequestModel * _Nullable respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
            completion(error,0);
        }

    }];

//    content/getCommentNum?item_id=dasdada,eqeqeq

}

@end
