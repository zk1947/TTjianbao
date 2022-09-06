//
//  JHLuckyBagBusiniss.m
//  TTjianbao
//
//  Created by zk on 2021/11/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHLuckyBagBusiniss.h"

@implementation JHLuckyBagBusiniss

+ (void)loadShowListData:(NSDictionary *)param completion:(void(^)(NSError *_Nullable error, NSArray *_Nullable resourceArr))completion{
    NSString *url = FILE_BASE_STRING(@"/seller_blessing_bag/bag_list/auth");
    [HttpRequestTool postWithURL:url Parameters:param requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        if (respondObject) {
            if (completion) {
                NSArray *array = [NSArray modelArrayWithClass:[JHLuckyBagShowModel class] json:respondObject.data[@"records"]];
                completion(nil,array);
            }
        }else{
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
        }
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
       if (completion) {
           completion(error,nil);
       }
    }];
}

+ (void)loadRewardData:(NSDictionary *)param completion:(void(^)(NSError *_Nullable error, NSArray *_Nullable resourceArr))completion{
    NSString *url = FILE_BASE_STRING(@"/seller_blessing_bag/customer_prize_list/auth");
    [HttpRequestTool postWithURL:url Parameters:param requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        if (respondObject) {
            if (completion) {
                NSArray *array = [NSArray modelArrayWithClass:[JHLuckyBagRewardModel class] json:respondObject.data[@"records"]];
                completion(nil,array);
            }
        }else{
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
        }
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
       if (completion) {
           completion(error,nil);
       }
    }];
}

+ (void)loadLuckyBagMsgData:(void(^)(NSError *_Nullable error, JHLuckyBagModel *_Nullable model))completion{
    NSString *url = FILE_BASE_STRING(@"/seller_blessing_bag/show_seller_bag/auth");
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject) {
            if (completion) {
                JHLuckyBagModel *model = [JHLuckyBagModel mj_objectWithKeyValues:respondObject.data];
                completion(nil,model);
            }
        }else{
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

+ (void)sendLuckyBagData:(NSDictionary *)param completion:(void(^)(NSError *_Nullable error, BOOL success, NSString *_Nullable message))completion{
    NSString *url = FILE_BASE_STRING(@"/seller_blessing_bag/publish_seller_bag/auth");
    [HttpRequestTool postWithURL:url Parameters:param requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        if (respondObject) {
            if (completion) {
                BOOL success = respondObject.data[@"success"];
                NSString *message = respondObject.data[@"toastInfo"];
                completion(nil,success,message);
            }
        }else{
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,NO,nil);
            }
        }
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
       if (completion) {
           completion(error,NO,nil);
       }
    }];
}

+ (void)downLuckyBagData:(NSDictionary *)param completion:(void(^)(NSError *_Nullable error, NSString *_Nullable message))completion{
    NSString *url = FILE_BASE_STRING(@"/seller_blessing_bag/terminate_seller_bag/auth");
    [HttpRequestTool getWithURL:url Parameters:param successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject) {
            if (completion) {
                completion(nil,respondObject.message);
            }
        }else{
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

+ (void)loadBagTaskData:(NSDictionary *)param completion:(void(^)(NSError *_Nullable error, JHLuckyBagTaskModel *_Nullable model))completion{
    NSString *url = FILE_BASE_STRING(@"/customer_blessing_bag/auth/customer_join");
    [HttpRequestTool getWithURL:url Parameters:param successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject) {
            if (completion) {
                JHLuckyBagTaskModel *model = [JHLuckyBagTaskModel mj_objectWithKeyValues:respondObject.data];
                completion(nil,model);
            }
        }else{
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

+ (void)sendBagMsgData:(NSDictionary *)param completion:(void(^)(NSError *_Nullable error, NSString *_Nullable message))completion{
    NSString *url = FILE_BASE_STRING(@"/customer_blessing_bag/auth/customer_comment");
    [HttpRequestTool getWithURL:url Parameters:param successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject) {
            if (completion) {
                completion(nil,respondObject.message);
            }
        }else{
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

+ (void)loadBagEntranceData:(NSDictionary *)param completion:(void(^)(NSError *_Nullable error, CustomerBagTagModel *_Nullable model))completion{
    NSString *url = FILE_BASE_STRING(@"/customer_blessing_bag/auth/find-effective-bag");
    [HttpRequestTool getWithURL:url Parameters:param successBlock:^(RequestModel * _Nullable respondObject) {
        if (respondObject) {
            if (completion) {
                CustomerBagTagModel *model = [CustomerBagTagModel mj_objectWithKeyValues:respondObject.data];
                completion(nil,model);
            }
        }else{
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

@end
