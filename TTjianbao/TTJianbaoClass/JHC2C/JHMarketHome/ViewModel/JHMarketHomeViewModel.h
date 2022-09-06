//
//  JHMarketHomeViewModel.h
//  TTjianbao
//
//  Created by plz on 2021/5/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHMarketHomeModel.h"
#import "JHC2CGoodsListModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JHMarketHomeCellStyle) {
    JHNewStoreHomeCellStyleKingKong,     /// 金刚
    JHNewStoreHomeCellStyleBgAd,         /// 广告
    JHNewStoreHomeCellStyleBoutique,     /// 专场
    JHNewStoreHomeCellStyleGoods,        /// 商品
};

@class JHMarketHomeCellStyleKingKongViewModel;
@class JHMarketHomeCellStyleBgAdViewModel;
@class JHMarketHomeCellStyleSpecialViewModel;
@class JHMarketHomeCellStyleGoodsViewModel;
@interface JHMarketHomeViewModel : NSObject

@property (nonatomic, strong) JHMarketHomeCellStyleKingKongViewModel   *kingKongViewModel;
@property (nonatomic, strong) JHMarketHomeCellStyleBgAdViewModel       *bgAdViewModel;
@property (nonatomic, strong) JHMarketHomeCellStyleSpecialViewModel    *specialViewModel;
@property (nonatomic, strong) JHMarketHomeCellStyleGoodsViewModel      *goodsViewModel;

@end

/// 搜索
@interface JHMarketHomeSearchWordListViewModel: NSObject
@property (nonatomic, strong) NSArray <JHMarketHomeSearchWordListItemViewModel *>*productListBeanList;
@end

/// 金刚
@interface JHMarketHomeCellStyleKingKongViewModel: NSObject
@property (nonatomic, strong) NSArray <JHMarketHomeKingKongItemModel *>*operationSubjectList;
@property (nonatomic, assign) JHMarketHomeCellStyle         cellStyle;
@end

/// 广告
@interface JHMarketHomeCellStyleBgAdViewModel: NSObject
@property (nonatomic, assign) JHMarketHomeCellStyle  cellStyle;
@end

/// 专场
@interface JHMarketHomeCellStyleSpecialViewModel: NSObject
@property (nonatomic, strong) NSArray <JHMarketHomeSpecialItemModel *>*operationPosition;
@property (nonatomic, assign) JHMarketHomeCellStyle  cellStyle;
@end

/// 商品
@interface JHMarketHomeCellStyleGoodsViewModel: NSObject
@property (nonatomic, strong) NSArray<JHC2CProductBeanListModel *> *productList;
@property (nonatomic, strong) NSArray<JHMarketHomeHotTopItemModel *> *hotTopicResponses;
@property (nonatomic, assign) BOOL hasMore;
@property (nonatomic, assign) JHMarketHomeCellStyle   cellStyle;
@end

NS_ASSUME_NONNULL_END
