//
//  JHNewStoreHomeBusiness.m
//  TTjianbao
//
//  Created by user on 2021/2/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreHomeBusiness.h"
#import "JHNewStoreHomeModel.h"
#import "JHHotWordModel.h"
#import "JHNewUserRedPacketAlertView.h"

@implementation JHNewStoreHomeBusiness
/*
 * 商城热搜关键词
 */
+ (void)getHotKeywords:(HTTPCompleteBlock)completeBlock {
    NSString *url = COMMUNITY_FILE_BASE_STRING(@"/v1/shop/hot_words");
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        NSArray * hotHeys = [JHHotWordModel mj_objectArrayWithKeyValuesArray:respondObject.data].copy;
        completeBlock(hotHeys, NO);
    } failureBlock:^(RequestModel *respondObject) {
        completeBlock(nil, YES);
    }];
}

/*
 * 运营位
 */
+ (void)getNewStoreHomeOperationInfo:(void (^)(NSError * _Nullable, JHNewStoreHomeCellStyle_MallModelViewModel * _Nullable))completion {
    NSString *url = FILE_BASE_STRING(@"/anon/operation/mall-list-defini");
    [HttpRequestTool getWithURL:url Parameters:nil  successBlock:^(RequestModel *respondObject) {
        JHMallModel *model = [JHMallModel mj_objectWithKeyValues:respondObject.data];
        if (!model || (!model.hidePperationPosition &&
                       model.operationPosition.count == 0 &&
                       model.operationSubjectList.count == 0 &&
                       model.slideShow.count == 0)) {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
            return;
        }
        
        JHNewStoreHomeCellStyle_MallModelViewModel *viewModel = [[JHNewStoreHomeCellStyle_MallModelViewModel alloc] init];
        
        JHNewStoreHomeCellStyle_BannerViewModel *bannerModel = [[JHNewStoreHomeCellStyle_BannerViewModel   alloc] init];
        bannerModel.slideShow = model.slideShow;
        bannerModel.cellStyle = JHNewStoreHomeCellStyle_Banner;
        
        JHNewStoreHomeCellStyle_KingKongViewModel *kingKongModel = [[JHNewStoreHomeCellStyle_KingKongViewModel alloc] init];
        kingKongModel.operationSubjectList = model.operationSubjectList;
        kingKongModel.cellStyle = JHNewStoreHomeCellStyle_KingKong;

        JHNewStoreHomeCellStyle_BgAdViewModel *bgAdVModel = [[JHNewStoreHomeCellStyle_BgAdViewModel alloc] init];
        bgAdVModel.operationPosition = model.operationPosition;
        bgAdVModel.cellStyle = JHNewStoreHomeCellStyle_BgAd;

        
        viewModel.bannerModel   = bannerModel;
        viewModel.kingKongModel = kingKongModel;
        viewModel.bgAdVModel    = bgAdVModel;
        
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

/*
 * 新人专享
 */
+ (void)getNewStoreHomeNewPeopleGift:(void (^)(JHNewStoreHomeCellStyle_NewPeopleViewModel * _Nullable))completion {
    [JHNewUserRedPacketAlertView getNewUserRedPacketEntranceWithLocation:2 complete:^(JHNewUserRedPacketAlertViewModel * _Nullable model) {
        if (model) {
            JHNewStoreHomeCellStyle_NewPeopleViewModel *viewModel = [[JHNewStoreHomeCellStyle_NewPeopleViewModel alloc] init];
            viewModel.anewPeopleModel = model;
            viewModel.cellStyle = JHNewStoreHomeCellStyle_NewPeople;
            if (completion) {
                completion(viewModel);
            }
        }
    }];
}

/*
 * 专场列表
 */
+ (void)getBoutiqueListCompletion:(void (^)(NSError * _Nullable, NSArray<JHNewStoreHomeCellStyle_BoutiqueViewModel *> * _Nullable))completion {
    NSString *url = FILE_BASE_STRING(@"/api/mall/show/showList");
    [HttpRequestTool postWithURL:url Parameters:nil requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        JHNewStoreHomeBoutiqueModel *model = [JHNewStoreHomeBoutiqueModel mj_objectWithKeyValues:respondObject.data];
        if (!model || model.showList.count == 0) {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
            return;
        }
        
        NSArray<JHNewStoreHomeCellStyle_BoutiqueViewModel *>*viewModels = [model.showList jh_map:^id _Nonnull(JHNewStoreHomeBoutiqueShowListModel * _Nonnull obj, NSUInteger idx) {
            JHNewStoreHomeCellStyle_BoutiqueViewModel *bouViewModel = [[JHNewStoreHomeCellStyle_BoutiqueViewModel alloc] init];
            bouViewModel.isFirstCell = (idx == 0)?YES:NO;
            bouViewModel.boutiqueModel = obj;
            bouViewModel.cellStyle = JHNewStoreHomeCellStyle_Boutique;
            return bouViewModel;
        }];
        if (completion) {
            completion(nil,viewModels);
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

/*
 * 商品列表
 */
+ (void)getGoodsListAndTab:(NSInteger)pageIndex
                  pageSize:(NSInteger)pageSize
               productType:(JHGoodManagerListRequestProductType)productType
          recommendTabName:(NSString *__nullable)recommendTabName
                Completion:(nonnull void (^)(NSError * _Nullable, JHNewStoreHomeCellStyle_GoodsViewModel * _Nullable))completion {
    User *user = [UserInfoRequestManager sharedInstance].user;
    NSString *url = FILE_BASE_STRING(@"/api/mall/product/listRecommend");
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
        @"pageNo":@(pageIndex),
        @"pageSize":@(pageSize),
        @"productType":@(productType),
        @"customerId" : user.customerId ?: @""   //4.0.2 新增
    }];
    if (!isEmpty(recommendTabName)) {
        [dict addEntriesFromDictionary:@{
            @"recommendTabName":recommendTabName,
        }];
    }
    [HttpRequestTool postWithURL:url Parameters:dict requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        JHNewStoreHomeGoodsListModel *model = [JHNewStoreHomeGoodsListModel mj_objectWithKeyValues:respondObject.data];
        if (!model || (model.recommendTabList.count == 0 && model.productList.count == 0)) {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
            return;
        }
//
        JHNewStoreHomeCellStyle_GoodsViewModel *goodsViewModel = [[JHNewStoreHomeCellStyle_GoodsViewModel alloc] init];
        goodsViewModel.recommendTabList = model.recommendTabList;
        goodsViewModel.productList = model.productList;
        goodsViewModel.cellStyle = JHNewStoreHomeCellStyle_Goods;
        if (completion) {
            completion(nil,goodsViewModel);
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

/*
 * 秒杀专区
 */
+ (void)getKillActivity:(void (^)(NSError * _Nullable, JHNewStoreHomeCellStyle_KillActivityViewModel * _Nullable))completion {
    NSString *url = FILE_BASE_STRING(@"/api/mall/seckill/getSeckillIndex");
    [HttpRequestTool postWithURL:url Parameters:nil requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        JHNewStoreHomeKillActivityModel *model = [JHNewStoreHomeKillActivityModel mj_objectWithKeyValues:respondObject.data];
        if (!model || !model.showBanner) {
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:respondObject.code
                                             userInfo:@{NSLocalizedDescriptionKey: respondObject.message}];
            if (completion) {
                completion(error,nil);
            }
            return;
        }
        
        JHNewStoreHomeCellStyle_KillActivityViewModel *viewModel = [[JHNewStoreHomeCellStyle_KillActivityViewModel alloc] init];
        viewModel.killActivityModel = model;
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

@end
