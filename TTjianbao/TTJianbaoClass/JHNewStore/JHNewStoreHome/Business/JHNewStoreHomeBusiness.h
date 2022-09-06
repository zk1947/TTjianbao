//
//  JHNewStoreHomeBusiness.h
//  TTjianbao
//
//  Created by user on 2021/2/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHMallModel.h"
#import "JHNewStoreHomeViewModel.h"
#import "JHGoodManagerNormalModel.h"

NS_ASSUME_NONNULL_BEGIN


@class JHNewStoreHomeBoutiqueShowListModel;
@class JHNewStoreHomeGoodsListModel;
@interface JHNewStoreHomeBusiness : NSObject


/*
 * 商城热搜关键词
 */
+ (void)getHotKeywords:(HTTPCompleteBlock)completeBlock;

/*
 * 运营位
 */
+ (void)getNewStoreHomeOperationInfo:(void(^)(NSError *_Nullable error, JHNewStoreHomeCellStyle_MallModelViewModel *_Nullable viewModel))completion;

/*
 * 新人专享
 */
+ (void)getNewStoreHomeNewPeopleGift:(void (^)(JHNewStoreHomeCellStyle_NewPeopleViewModel * _Nullable viewModel))completion;

/*
 * 专场列表
 */
+ (void)getBoutiqueListCompletion:(void(^)(NSError *_Nullable error, NSArray<JHNewStoreHomeCellStyle_BoutiqueViewModel *> *_Nullable viewModels))completion;


/*
 * 商品列表
 */
+ (void)getGoodsListAndTab:(NSInteger)pageIndex
                  pageSize:(NSInteger)pageSize
               productType:(JHGoodManagerListRequestProductType)productType
          recommendTabName:(NSString *__nullable)recommendTabName
                Completion:(void(^)(NSError *_Nullable error, JHNewStoreHomeCellStyle_GoodsViewModel *_Nullable viewModel))completion;

/*
 * 秒杀专区
 */
+ (void)getKillActivity:(void(^)(NSError *_Nullable error, JHNewStoreHomeCellStyle_KillActivityViewModel *_Nullable viewModel))completion;
@end

NS_ASSUME_NONNULL_END
