//
//  JHNewStoreHomeViewModel.h
//  TTjianbao
//
//  Created by user on 2021/2/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHMallModel.h"
#import "JHNewStoreHomeModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JHNewStoreHomeCellStyle) {
    JHNewStoreHomeCellStyle_Banner = 888, /// 轮播
    JHNewStoreHomeCellStyle_KingKong,     /// 金刚
    JHNewStoreHomeCellStyle_BgAd,         /// 横幅广告
    JHNewStoreHomeCellStyle_NewPeople,    /// 新人
    JHNewStoreHomeCellStyle_Boutique,     /// 专场
    JHNewStoreHomeCellStyle_GoodsLine,    /// 分割线
    JHNewStoreHomeCellStyle_Goods,        /// 商品
};

@class JHNewStoreHomeCellStyle_BannerViewModel;
@class JHNewStoreHomeCellStyle_KingKongViewModel;
@class JHNewStoreHomeCellStyle_BgAdViewModel;
@interface JHNewStoreHomeCellStyle_MallModelViewModel : NSObject
@property (nonatomic, strong) JHNewStoreHomeCellStyle_BannerViewModel   *bannerModel;
@property (nonatomic, strong) JHNewStoreHomeCellStyle_KingKongViewModel *kingKongModel;
@property (nonatomic, strong) JHNewStoreHomeCellStyle_BgAdViewModel     *bgAdVModel;
@end


/// 轮播
@interface JHNewStoreHomeCellStyle_BannerViewModel : NSObject
@property (nonatomic, strong) NSArray <JHMallBannerModel*>*slideShow;
@property (nonatomic, assign) JHNewStoreHomeCellStyle      cellStyle;
@end

/// 金刚
@interface JHNewStoreHomeCellStyle_KingKongViewModel: NSObject
@property (nonatomic, strong) NSArray <JHMallCategoryModel *>*operationSubjectList;
@property (nonatomic, assign) JHNewStoreHomeCellStyle         cellStyle;
@end

/// 横幅广告
@interface JHNewStoreHomeCellStyle_BgAdViewModel: NSObject
@property (nonatomic, strong) NSArray <JHMallOperateModel*> *operationPosition;
@property (nonatomic, assign) JHNewStoreHomeCellStyle  cellStyle;
@end

/// 新人
@class JHNewUserRedPacketAlertViewModel;
@interface JHNewStoreHomeCellStyle_NewPeopleViewModel: NSObject
@property (nonatomic, strong) JHNewUserRedPacketAlertViewModel *anewPeopleModel;
@property (nonatomic, assign) JHNewStoreHomeCellStyle              cellStyle;
@end

/// 专场
@class JHNewStoreHomeBoutiqueShowListModel;
@interface JHNewStoreHomeCellStyle_BoutiqueViewModel: NSObject
@property (nonatomic, strong) JHNewStoreHomeBoutiqueShowListModel *boutiqueModel;
@property (nonatomic, assign) JHNewStoreHomeCellStyle              cellStyle;
@property (nonatomic, assign) BOOL                                 isFirstCell;
@end

/// 商品分割线
@interface JHNewStoreHomeCellStyle_GoodsLineViewModel: NSObject
@property (nonatomic, assign) JHNewStoreHomeCellStyle                        cellStyle;
@end

/// 商品
@interface JHNewStoreHomeCellStyle_GoodsViewModel: NSObject
@property (nonatomic, strong) NSArray<JHNewStoreHomeGoodsProductListModel *> *productList;
@property (nonatomic, strong) NSArray<JHNewStoreHomeGoodsTabInfoModel *> *recommendTabList;
@property (nonatomic, assign) JHNewStoreHomeCellStyle              cellStyle;
@end


/// 秒杀专区
@interface JHNewStoreHomeCellStyle_KillActivityViewModel: NSObject
@property (nonatomic, strong) JHNewStoreHomeKillActivityModel *killActivityModel;
@property (nonatomic, assign) JHNewStoreHomeCellStyle          ellStyle;
@end


NS_ASSUME_NONNULL_END
