//
//  JHStoreSnapShootViewModel.h
//  TTjianbao
//
//  Created by jiangchao on 2021/2/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "JHStoreDetailSectionCellViewModel.h"
#import "JHStoreDetailCellBaseViewModel.h"
#import "JHStoreDetailFunctionViewModel.h"
#import "JHStoreDetailHeaderViewModel.h"
#import "JHStoreSnapShootPriceViewModel.h"
#import "JHStoreDetailTitleViewModel.h"
#import "JHStoreDetailTagViewModel.h"
#import "JHStoreDetailSpecialViewModel.h"
#import "JHStoreDetailCouponViewModel.h"
#import "JHStoreDetailEducationViewModel.h"
#import "JHStoreDetailShopViewModel.h"
#import "JHStoreDetailSpecViewModel.h"
#import "JHStoreDetailImageViewModel.h"
#import "JHStoreDetailSecurityViewModel.h"
#import "JHStoreDetailSectionTitleViewModel.h"
#import "JHStoreDetailGoodsDesViewModel.h"
#import "JHStoreDetailBusiness.h"
#import "JHStoreDetailShopTitleViewModel.h"
#import "JHShareInfo.h"
#import "UMengManager.h"
#import "JHStoreSnapShootDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHStoreSnapShootViewModel : NSObject

/// toast
@property (nonatomic, copy) NSString *toastMsg;
/// 是否有视频
@property (nonatomic, copy) NSString *videoUrl;
/// 商品ID
@property (nonatomic, copy) NSString *productId;
/// 分享信息
@property (nonatomic, strong) JHShareInfo *shareInfo;
/// 规格参数的 分区 index
@property (nonatomic, assign) NSUInteger specSectionIndex;
/// 选项卡index
@property (nonatomic, assign) NSUInteger categoryTitleIndex;
/// 商品售卖状态描述
@property (nonatomic, copy) NSString *productSellStatusDesc;
/// 商品介绍图
@property (nonatomic, strong) NSArray<NSString *> *goodsThumbsUrls;
@property (nonatomic, strong) NSArray<NSString *> *goodsMediumUrls;
@property (nonatomic, strong) NSArray<NSString *> *goodsLargeUrls;

/// 加载完成
@property (nonatomic, strong) RACSubject *endRefreshing;
/// 跳转
@property (nonatomic, strong) RACSubject<NSDictionary *> *pushvc;
/// 刷新tableview
@property (nonatomic, strong) RACReplaySubject *refreshTableView;
/// 刷新cell
@property (nonatomic, strong) RACReplaySubject<RACTuple*> *refreshCell;

/// 表头viewModel
@property (nonatomic, strong) JHStoreDetailHeaderViewModel *headerViewModel;
/// 底部工具条viewmodel
@property (nonatomic, strong) JHStoreDetailFunctionViewModel *functionViewModel;

/// cell 集合- 存储类表所需所有  cellViewModel
@property (nonatomic, strong) NSMutableArray<JHStoreDetailSectionCellViewModel *> *cellViewModelList;


/// 获取商品详情信息
- (void)getDetailInfo;
/// 跳转收藏
- (void)pushCollectList;

@end

NS_ASSUME_NONNULL_END
