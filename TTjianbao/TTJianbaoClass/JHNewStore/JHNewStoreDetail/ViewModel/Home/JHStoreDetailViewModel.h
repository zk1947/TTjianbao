//
//  JHStoreDetailViewModel.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//  Describe : 商品详情ViewModel

#import <Foundation/Foundation.h>
#import "JHStoreDetailSectionCellViewModel.h"
#import "JHStoreDetailCellBaseViewModel.h"
#import "JHStoreDetailFunctionViewModel.h"
#import "JHStoreDetailHeaderViewModel.h"
#import "JHStoreDetailPriceViewModel.h"
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
#import "JHStoreDetailAuctionListViewModel.h"
#import "JHB2CCommentViewModel.h"
#import "JHB2CSameShopCellViewModel.h"
#import "JHB2CRecommenViewModel.h"
#import "JHB2CCommentHeaderViewModel.h"

#import "JHShareInfo.h"
#import "UMengManager.h"

//NS_ASSUME_NONNULL_BEGIN

@interface JHStoreDetailViewModel : NSObject

/// 缩略模式
@property(nonatomic) BOOL  shotScreen;

/// 店铺关注状态
@property (nonatomic, assign) BOOL focusStatus;
/// 详情类型 
@property (nonatomic, assign) StoreDetailType type;
/// 来源
@property (nonatomic, copy) NSString *fromPage;
/// toast
@property (nonatomic, copy) NSString *toastMsg;
/// 是否有视频
@property (nonatomic, copy) NSString *videoUrl;
/// 商品ID
@property (nonatomic, copy) NSString *productId;
/// 商家ID
@property (nonatomic, copy) NSString *businessId;
/// 分享信息
@property (nonatomic, strong) JHShareInfo *shareInfo;
/// 刷新上层页面-当关注、优惠券领取状态改变时触发。
@property (nonatomic, strong) RACSubject *refreshUpper;

/// 规格参数的 分区 index
@property (nonatomic, assign) NSInteger specSectionIndex;
/// 留言分区 index
@property (nonatomic, assign) NSInteger commentSectionIndex;
/// 推荐分区 index
@property (nonatomic, assign) NSInteger reCommentSectionIndex;

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

/// 刷新Nav
@property (nonatomic, strong) RACReplaySubject<RACTuple*> *refreshNav;

@property (nonatomic, strong) JHStoreDetailModel *dataModel;

@property (nonatomic, strong) JHB2CAuctionRefershModel *auctionModel;

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


/// 返回顶部事件
- (void)reportBackTopEvent;
/// 分享点击事件
- (void)reportShareEvent;

///校验保证金状态，并吊起出价或设置代理
- (void)checkSureMoney;
@end

//NS_ASSUME_NONNULL_END
