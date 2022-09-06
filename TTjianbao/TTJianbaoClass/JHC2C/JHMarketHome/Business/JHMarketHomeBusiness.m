//
//  JHMarketHomeBusiness.m
//  TTjianbao
//
//  Created by plz on 2021/5/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketHomeBusiness.h"

@implementation JHMarketHomeBusiness

+ (void)getSearchWordListData:(void(^)(NSError *_Nullable error, NSArray<JHHotWordModel *> * _Nullable respObj))completion{
    NSString *url = FILE_BASE_STRING(@"/anon/operation/ctocTopSearchList");
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        NSArray *wordsArray = respondObject.data;
        if (!wordsArray || wordsArray.count == 0) {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
            return;
        }
        NSMutableArray *resultArr = [NSMutableArray array];
        for (NSDictionary *wordDic in wordsArray) {
            JHHotWordModel *wordModel = [JHHotWordModel new];
            wordModel.title = wordDic[@"name"];
            [resultArr addObject:wordModel];
        }
        if (completion) {
            completion(nil,resultArr.copy);
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

+ (void)getMarketCategroyListData:(void(^)(NSError *_Nullable error, JHMarketHomeViewModel *_Nullable viewModel))completion{
    NSString *url = FILE_BASE_STRING(@"/anon/operation/ctoc-list-defini");
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        JHMarketHomeModel *model = [JHMarketHomeModel mj_objectWithKeyValues:respondObject.data];
        if (!model) {//|| model.operationSubjectList.count == 0
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
            return;
        }
        JHMarketHomeViewModel *viewModel = [[JHMarketHomeViewModel alloc] init];
        
        JHMarketHomeCellStyleKingKongViewModel *kingKongModel = [[JHMarketHomeCellStyleKingKongViewModel alloc] init];
        kingKongModel.operationSubjectList = model.operationSubjectList;
        kingKongModel.cellStyle = JHNewStoreHomeCellStyleKingKong;
        
        JHMarketHomeCellStyleBgAdViewModel *bgAdViewModel = [[JHMarketHomeCellStyleBgAdViewModel alloc] init];
        bgAdViewModel.cellStyle = JHNewStoreHomeCellStyleBgAd;

        JHMarketHomeCellStyleSpecialViewModel *specialViewModel = [[JHMarketHomeCellStyleSpecialViewModel alloc] init];
        specialViewModel.operationPosition = model.operationPosition;
        specialViewModel.cellStyle = JHNewStoreHomeCellStyleBoutique;

        viewModel.kingKongViewModel   = kingKongModel;
        viewModel.bgAdViewModel = bgAdViewModel;
        viewModel.specialViewModel    = specialViewModel;
        
        if (completion) {
            completion(nil,viewModel);
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

+ (void)getMarketGoodsListData:(NSInteger)pageIndex pageSize:(NSInteger)pageSize productType:(NSInteger)productType Completion:(void(^)(NSError *_Nullable error, JHMarketHomeCellStyleGoodsViewModel *_Nullable viewModel))completion{
    User *user = [UserInfoRequestManager sharedInstance].user;
    NSString *url = FILE_BASE_STRING(@"/api/mall/product/listRecommendC2c");
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
        @"productType":@(productType),
        @"pageNo":@(pageIndex),
        @"pageSize":@(pageSize),
        @"imageType":@"s,m,b,o",
        @"customerId" : user.customerId ?: @""   //4.0.2 新增
    }];
    [HttpRequestTool postWithURL:url Parameters:dict requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        JHMarketHomeCellStyleGoodsViewModel *model = [JHMarketHomeCellStyleGoodsViewModel mj_objectWithKeyValues:respondObject.data];
        if (!model || model.productList.count == 0) {//&& model.hotTopicResponses.count == 0)
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
            return;
        }
        model.cellStyle = JHNewStoreHomeCellStyleGoods;
        if (completion) {
            completion(nil,model);
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

+ (void)getMyAcutionStatus:(void(^)(NSError *_Nullable error, JHMarketHomeLikeStatusModel *model))completion{
    NSString *url = FILE_BASE_STRING(@"/api/mall/product/homePage/myAuction");
    [HttpRequestTool postWithURL:url Parameters:nil requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        JHMarketHomeLikeStatusModel *model = [JHMarketHomeLikeStatusModel mj_objectWithKeyValues:respondObject.data];
        if (!model) {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
            return;
        }
//        int status = [respondObject.data[@"auctionResult"] intValue];
        if (completion) {
            completion(nil,model);
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

+ (void)cheakUserIsLimit:(int)limitType sellerId:(NSInteger)sellerId completion:(void(^)(NSString *_Nullable reason, int level))completion{
    User *user = [UserInfoRequestManager sharedInstance].user;
    NSDictionary *param = @{
        @"customerId":user.customerId,
        @"punishFunctionType":@(limitType),
        @"sellerId":@(sellerId)
    };
    NSString *url = FILE_BASE_STRING(@"/auth/mall/customerPunish/check");
    [HttpRequestTool postWithURL:url Parameters:param requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        if (respondObject.data) {
            if (completion) {
                completion(respondObject.data[@"punishReason"],[respondObject.data[@"punishType"] intValue]);
            }
        }else{
            if (completion) {
                completion(@"",0);
            }
        }
    } failureBlock:^(RequestModel *respondObject) {
        if (completion) {
            completion(respondObject.message,0);
        }
    }];
}

+(void)logProperty:(NSDictionary *)dic{
    NSMutableString *proprety = [[NSMutableString alloc] init];
    //遍历数组 生成声明属性的代码，例如 @property (nonatomic, copy) NSString str
    //打印出来后 command+c command+v
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *str;
        //        NSLog(@"%@",[obj class]);
        //判断的数据类型，生成相应的属性
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFString")] || [obj isKindOfClass:NSClassFromString(@"NSTaggedPointerString")] || [obj isKindOfClass:NSClassFromString(@"__NSCFConstantString")]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, copy) NSString *%@;",key];
        }
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFNumber")]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, assign) int %@;",key];
        }
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFArray")] || [obj isKindOfClass:[NSArray class]]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@;",key];
        }
        
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFDictionary")] || [obj isKindOfClass:[NSDictionary class]]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, strong) NSDictionary *%@;",key];
        }
        if ([obj isKindOfClass:NSClassFromString(@"__NSCFBoolean")]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, assign) BOOL %@;",key];
        }
        [proprety appendFormat:@"\n%@\n",str];
    }];
    NSLog(@"%@",proprety);
}


@end
