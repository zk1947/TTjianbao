//
//  SourceMallApiManager.m
//  TTjianbao
//
//  Created by jiang on 2019/8/22.
//  Copyright © 2019 Netease. All rights reserved.
//
#import "JHMallGroupConditionModel.h"
#import "SourceMallApiManager.h"
#import "FileUtils.h"
#import "NSString+Common.h"
#import <SVProgressHUD.h>
#import "JHMallCateModel.h"
#import "JHMallOperationModel.h"

/// 源头直购首页 订单鉴定数量
#define JHRequestPathGetOrderNumber FILE_BASE_STRING(@"/anon/operation/get-order-number")

@implementation SourceMallApiManager

//获取周年庆-源头直播-皮肤-落地页跳转url:getAnniversaryLink
+ (void)getCelebrateMallDetailUrl:(JHResponse)response
{
    JHRequestModel* model = [JHRequestModel new];
    //>>>/anon/stone-restore/get-anniversary-link
    [model setRequestPath:@"/anon/stone-restore/get-anniversary-link"];
    [JH_REQUEST asynPost:model success:^(id respData) {
        NSMutableArray* array = [NSMutableArray array];
        if([respData isKindOfClass:[NSDictionary class]])
        {
            NSDictionary* dic = respData;
            /**
                JHCelebrateButtonTypeCoupon,
                JHCelebrateButtonTypeRedpacket,
                JHCelebrateButtonTypeBill,
                JHCelebrateButtonTypeResaleStone,
                JHCelebrateButtonTypeMallOne,
                JHCelebrateButtonTypeMallTwo,
                JHCelebrateButtonTypeMallThree,
             */
            NSString* urlStr = [dic objectForKey:@"shopUrl4"];
            if(![NSString isEmpty:urlStr])
            {
                [array addObject:[self makeRouterWebModelByKey:urlStr]];
            }
            urlStr = [dic objectForKey:@"redPacketUrl"];
            if(![NSString isEmpty:urlStr])
            {
                [array addObject:[self makeRouterWebModelByKey:urlStr]];
            }
            urlStr = [dic objectForKey:@"accountUrl"];
            if(![NSString isEmpty:urlStr])
            {
                [array addObject:[self makeRouterWebModelByKey:urlStr]];
            }
            urlStr = [dic objectForKey:@"restoreUrl"];
            if(![NSString isEmpty:urlStr])
            {
                [array addObject:[self makeRouterWebModelByKey:urlStr]];
            }
            urlStr = [dic objectForKey:@"shopUrl1"];
            if(![NSString isEmpty:urlStr])
            {
                [array addObject:[self makeRouterModelByKey:urlStr]];
            }
            urlStr = [dic objectForKey:@"shopUrl2"];
            if(![NSString isEmpty:urlStr])
            {
                [array addObject:[self makeRouterModelByKey:urlStr]];
            }
            urlStr = [dic objectForKey:@"shopUrl3"];
            if(![NSString isEmpty:urlStr])
            {
                [array addObject:[self makeRouterModelByKey:urlStr]];
            }
        }
        response(array, [JHRespModel nullMessage]);
    } failure:^(NSString *errorMsg) {
        response([JHRespModel nullMessage], errorMsg);
    }];
}

+ (JHRouterModel*)makeRouterWebModelByKey:(NSString*)url
{
    JHRouterModel* router = [JHRouterModel new];
    router.type = @(JHRouterTypeParams).stringValue;
    router.vc = @"JHWebViewController";
    router.params = [NSDictionary dictionaryWithObject:url forKey:@"urlString"]; //urlString>htmlString
    return router;
}

+ (JHRouterModel*)makeRouterModelByKey:(NSString*)url
{
    JHRouterModel* router = [JHRouterModel new];
    router.type = @(JHRouterTypeParams).stringValue;
    router.vc = @"JHShopWindowPageController";
    router.params = [NSDictionary dictionaryWithObject:url forKey:@"showcaseId"];
    return router;
}

+ (void)getMallCateCompletion:(JHApiRequestHandler)completion{
    ///sellGroup
   //cate/videoCate
        NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/sellGroup?pageNo=%ld&pageSize=%ld"),0,100];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        NSError *error=nil;
        if (completion) {
                completion(respondObject,error);
        }
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            if ([FileUtils writeDataToFile:MallCateData data:[NSJSONSerialization dataWithJSONObject:respondObject.data options:NSJSONWritingPrettyPrinted error:nil]]) {
                NSLog(@"写入成功");
            }
        });

    } failureBlock:^(RequestModel *respondObject) {
        
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        if (completion) {
             completion(respondObject,error);
        }
    }];
}
+ (void)getMallBannerCompletion:(JHApiRequestHandler)completion{
    
    [HttpRequestTool getWithURL: COMMUNITY_FILE_BASE_STRING(@"/ad/2") Parameters:nil successBlock:^(RequestModel *respondObject) {
          NSError *error=nil;
          completion(respondObject,error);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            if ([FileUtils writeDataToFile:MallBannerData data:[NSJSONSerialization dataWithJSONObject:respondObject.data options:NSJSONWritingPrettyPrinted error:nil]]) {
                NSLog(@"写入成功");
            }
        });
    } failureBlock:^(RequestModel *respondObject) {
        
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        completion(respondObject,error);
    }];
}

+ (void)getMallMyAttentonCompletion:(JHApiRequestHandler)completion{
    //
    ///channel/followSellChannel
    //channel/sell/authoptional
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/channel/followSellChannel2?pageNo=%ld&pageSize=%ld"),0,100];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        NSError *error=nil;
        completion(respondObject,error);
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        completion(respondObject,error);
    }];
}

+(void)requestGroupConditionArrayBlock:(void (^) (NSArray *modelArray))block
{
    [HttpRequestTool postWithURL: FILE_BASE_STRING(@"/anon/channel/channel-setting/list") Parameters:nil requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        if(IS_ARRAY(respondObject.data) && block)
        {
            NSArray *array = [JHMallGroupConditionModel mj_objectArrayWithKeyValuesArray:respondObject.data];
            block(array);
            return;
        }
        block(@[]);
    } failureBlock:^(RequestModel *respondObject) {
        block(@[]);
    }];
}

+ (void)getMallMyWatchTrackCompletion:(JHApiRequestHandler)completion{
    
    NSMutableArray * watchTracks=[JHUserDefaults objectForKey:kMallWatchTrackKey];
    
    if(watchTracks && IS_ARRAY(watchTracks)) {
        NSString *channelIds = [watchTracks componentsJoinedByString:@","];
        NSString *url = FILE_BASE_STRING(@"/channel/getChannelFootprint");
        [HttpRequestTool getWithURL:url Parameters:@{@"channelIds":channelIds?:@""} successBlock:^(RequestModel *respondObject) {
             
               NSError *error=nil;
               completion(respondObject,error);
           } failureBlock:^(RequestModel *respondObject) {
               NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                    code:respondObject.code
                                                userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
               completion(respondObject,error);
           }];
    }
}

+ (void)getMallSpecialAreaCompletion:(JHApiRequestHandler)completion{
    
    [HttpRequestTool getWithURL: FILE_BASE_STRING(@"/anon/operation/list") Parameters:nil successBlock:^(RequestModel *respondObject) {
            DDLogInfo(@"专区专题数据==%@",respondObject.data);
             NSError *error=nil;
             completion(respondObject,error);
       } failureBlock:^(RequestModel *respondObject) {
           
           NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                code:respondObject.code
                                            userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
           completion(respondObject,error);
       }];
    
}

+ (void)deleteDataFromFiles
{
    [FileUtils deleteDataFromFile:MallBannerData] ;
    [FileUtils deleteDataFromFile:MallLivesData] ;
    [FileUtils deleteDataFromFile:MallCateData] ;
}

+ (void)requestOrderCountBlock:(JHApiRequestHandler)completion {
    
    [HttpRequestTool getWithURL:JHRequestPathGetOrderNumber Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        if ([respondObject.data isKindOfClass:[NSDictionary class]]) {
            NSString *data = [NSString stringWithFormat:@"%@", respondObject.data[@"count"]];
            respondObject.data = data;
            completion(respondObject, nil);
        } else {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:respondObject.code userInfo:@{NSLocalizedDescriptionKey: @"解析错误"}];
                      
            completion(respondObject,error);
        }
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain code:respondObject.code userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
                  
        completion(respondObject,error);
    }];
}


+ (void)getMallCustomSpecialAreaCompletion:(JHApiRequestHandler)completion{
    
    [HttpRequestTool getWithURL: FILE_BASE_STRING(@"/anon/operation/list-definiNew") Parameters:nil  successBlock:^(RequestModel *respondObject) {
             DDLogInfo(@"新专区专题数据==%@",respondObject.data);
             NSError *error=nil;
             completion(respondObject,error);
       } failureBlock:^(RequestModel *respondObject) {
           
           NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                code:respondObject.code
                                            userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
           completion(respondObject,error);
       }];
    
}
+ (void)getMallListAdvertCompletion:(JHApiRequestHandler)completion{
    [HttpRequestTool postWithURL: FILE_BASE_STRING(@"/anon/operation/defini") Parameters:@{@"definiSerial":@"6"}  requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        DDLogInfo(@"新专区专题数据==%@",respondObject.data);
        NSError *error=nil;
        completion(respondObject,error);
    } failureBlock:^(RequestModel *respondObject) {
        NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:respondObject.code
                                         userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
        completion(respondObject,error);
    }];
}
+ (void)getSourceMallCate:(NSString*)prentId Completion:(HTTPCompleteBlock)completion {
    NSString *url = FILE_BASE_STRING(@"/anon/channel/sell-channel-groups");
    [HttpRequestTool getWithURL:url Parameters:@{@"prentId":prentId?:@""} successBlock:^(RequestModel *respondObject) {
        NSArray *existArr = [JHMallCateModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        if (completion) {
            completion(existArr, NO);
        }
    } failureBlock:^(RequestModel *respondObject) {
        if (completion) {
            completion(nil, YES);
        }
    }];
}

+ (void)getChannelDetail:(NSString *)ID Completion:(void(^)(BOOL hasError, ChannelMode* channelMode))completion{
    [HttpRequestTool getWithURL:[ FILE_BASE_STRING(@"/channel/detail/authoptional?&clientType=commonlink&channelId=") stringByAppendingString:OBJ_TO_STRING(ID)] Parameters:nil successBlock:^(RequestModel *respondObject) {
        ChannelMode * channel = [ChannelMode mj_objectWithKeyValues:respondObject.data];
        if (completion) {
            completion(YES, channel);
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        
        if (completion) {
            completion(NO, nil);
        }
    }];
    
}

///请求直播购物页面每个标签下的运营位数据
+ (void)getMallGroupBannerList:(NSString *)definiSerial Completion:(HTTPCompleteBlock)block {
    
    [HttpRequestTool postWithURL: FILE_BASE_STRING(@"/anon/operation/defini") Parameters:@{@"definiSerial":definiSerial}  requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            JHOperationDetailModel *model = [JHOperationDetailModel  mj_objectWithKeyValues:respondObject.data];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(model, NO);
                }
            });
        });
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(respondObject, YES);
        }
    }];
}


@end
