//
//  JHStoreDetailViewModel.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailViewModel.h"
#import "JHChatGoodsInfoModel.h"
#import "JHAuthorize.h"
#import "JHC2CProductDetailBusiness.h"
#import "JHRushPurBusiness.h"
#import "JHRushPurChaseViewController.h"


@interface JHStoreDetailViewModel()
{
    BOOL isReportStoreDetail;
}

@property (nonatomic, strong) JHStoreCommentModel *commentModel;

@property (nonatomic, strong) NSArray<CommentTagMode *> *commentTagArr;

@property (nonatomic, strong) NSArray<JHNewStoreHomeGoodsProductListModel *> *sameShopArr;

@property (nonatomic, strong) NSArray<JHNewStoreHomeGoodsProductListModel *> *recommentArr;

@property(nonatomic, strong) NSArray<JHC2CJiangPaiRecord*> * historyRecords;

/// 当前触发保证金弹框
@property(nonatomic, strong) NSString * sureMoneyIsAgent;

@property(nonatomic) BOOL hasRefreshAuction;
@end

@implementation JHStoreDetailViewModel
#pragma mark - Life Cycle Functions
- (instancetype)init {
    self = [super init];
    if (self) {
//        [self.refreshTableView sendNext:nil];
        // 底部工具条
        [self bindFunction];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(getDetailInfo) name:@"JHStoreDetailViewController_refershData" object:nil];
        [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(refreshAuction:) name:@"JHStoreDetailViewController_auctionRefershData" object:nil];
        
    }
    return self;
}
- (void)dealloc {
    NSLog(@"商品详情-%@ 释放", [self class]);
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

#pragma mark - 事件

/// 展示说明弹框
/// @param dic
- (void)pushShowIntroduct:(NSDictionary*)dic{
    NSDictionary *par = dic[@"parameter"];
    NSMutableDictionary *parDic = [self getBaseProductDetailStatistic];
    parDic[@"button_name"] = par[@"name"];
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickDetailElement" params:parDic type:JHStatisticsTypeSensors];
    [self.pushvc sendNext:dic];
}

#pragma mark - 其他商品详情页面
- (void)pushOtherProductDetail:(NSDictionary*)dic isSameShop:(BOOL)sameShop{
    NSMutableDictionary *parDic = [self getBaseProductDetailStatistic];
    NSDictionary *par = dic[@"parameter"];
    parDic[@"original_price"] = [self getPrice:par[@"original_price"]];;
    parDic[@"post_coupon_price"] = nil;
    NSString *sepStr = sameShop ? @"同店好货列表" : @"猜您喜欢列表";
    if([dic[@"type"] isEqualToString:@"SpecialShow"]){
        parDic[@"commodity_id"] = par[@"productId"];
        parDic[@"zc_id"] = par[@"showId"];
        parDic[@"zc_name"] = par[@"zc_name"];
        parDic[@"store_from"] = sepStr;
        [JHAllStatistics jh_allStatisticsWithEventId:@"zcEnter" params:parDic type:JHStatisticsTypeSensors];
    }else{
        parDic[@"commodity_id"] = par[@"productId"];
        parDic[@"model_type"] = sepStr;
        [JHAllStatistics jh_allStatisticsWithEventId:@"commodityClick" params:parDic type:JHStatisticsTypeSensors];
    }

    [self.pushvc sendNext:dic];
}


#pragma mark - 评价详情页面
- (void)pushCommentDetailAndStatic:(BOOL)addStatic{
    NSString *shopId = self.dataModel.shopInfo.shopId;
    if (shopId == nil || shopId.length <= 0) { return; }
    NSDictionary *par = @{@"shopId" : shopId};
    NSDictionary *dic = @{@"type" : @"comment",
                          @"parameter" : par};
    [self.pushvc sendNext:dic];
    
    if (addStatic) {
        NSMutableDictionary *parDic = [self getBaseProductDetailStatistic];
        parDic[@"button_name"] = @"商家评论查看全部";
        [JHAllStatistics jh_allStatisticsWithEventId:@"clickDetailElement" params:parDic type:JHStatisticsTypeSensors];
    }
}

/// 专场跳转
- (void)pushSpecialShow {
    //秒杀单独跳转
    if(self.dataModel.existShow && self.dataModel.specialShowInfo.showType.integerValue > 2){
        NSDictionary *par = @{@"showId" : @""};
        NSDictionary *dic = @{@"type" : @"JHRushPurChaseViewController",
                              @"parameter" : par};
        [self.pushvc sendNext:dic];

    }else{
        NSString *showId = self.dataModel.specialShowInfo.showId;
        if (showId == nil) {return;}
        NSDictionary *par = @{@"showId" : showId};
        NSDictionary *dic = @{@"type" : @"SpecialShow",
                              @"parameter" : par};
        [self.pushvc sendNext:dic];
        [self reportSpecialShowEvent];

    }
}
/// 确认订单跳转
- (void)pushOrder {
    NSLog(@"确认订单");
    
    if (self.functionViewModel.purchaseStatus == PurchaseStateCantBuy) { return; }
    
    if (self.dataModel.sellStock <= 0 && [self.dataModel.productType isEqualToString:@"0"]) {
        self.toastMsg = @"来晚了哦~";
        self.functionViewModel.purchaseStatus = PurchaseStateSoldout;
        return;
    }
    if (![self isLogin]) { return; }
    if (self.productId == nil) { return; }
    
    NSString *showId = self.dataModel.specialShowInfo.showId;
    
    NSDictionary *par = [NSMutableDictionary dictionary];
    [par setValue:self.productId forKey:@"productId"];
    if (showId != nil) {
        [par setValue:showId forKey:@"showId"];
    }
    NSDictionary *dic = @{@"type" : @"Order",
                          @"parameter" : par};
    [self.pushvc sendNext:dic];
    [self reportBuy];
}
/// 支付跳转
- (void)pushPayment {
    NSLog(@"支付订单");
    if (![self isLogin]) { return; }
    NSDictionary *par = @{};
    NSDictionary *dic = @{@"type" : @"Payment",
                          @"parameter" : par};
    [self.pushvc sendNext:dic];
}
/// 店铺跳转
- (void)pushShop {
    NSLog(@"店铺");
    NSString *shopId = self.dataModel.shopInfo.shopId;
    if (shopId == nil || shopId.length <= 0) { return; }
    
    NSDictionary *par = @{@"shopId" : shopId};
    NSDictionary *dic = @{@"type" : @"Shop",
                          @"parameter" : par};
    [self.pushvc sendNext:dic];
}

/// 店铺跳转 店铺商品
- (void)pushShopProduct{
    NSLog(@"店铺");
    NSString *shopId = self.dataModel.shopInfo.shopId;
    if (shopId == nil || shopId.length <= 0) { return; }
    
    NSDictionary *par = @{@"shopId" : shopId};
    NSDictionary *dic = @{@"type" : @"Shop",
                          @"parameter" : par};
    [self.pushvc sendNext:dic];
    NSMutableDictionary *parDic = [self getBaseProductDetailStatistic];
    parDic[@"button_name"] = @"店铺推荐商品";
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickDetailElement" params:parDic type:JHStatisticsTypeSensors];
}


/// 店铺跳转Btn click
- (void)pushShopOnlyBtn {
    NSLog(@"店铺");
    NSString *shopId = self.dataModel.shopInfo.shopId;
    if (shopId == nil || shopId.length <= 0) { return; }
    
    NSDictionary *par = @{@"shopId" : shopId};
    NSDictionary *dic = @{@"type" : @"Shop",
                          @"parameter" : par};
    [self.pushvc sendNext:dic];
    
    NSMutableDictionary *parDic = [self getBaseProductDetailStatistic];
    parDic[@"button_name"] = @"进入店铺";
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickIntoStore" params:parDic type:JHStatisticsTypeSensors];
}

/// 客服跳转
- (void)pushSerice {
    NSLog(@"客服");
    if (self.dataModel.existShow == true) { // 专场客服
        
    }else { // 普通客服
        
    }
    
    JHChatGoodsInfoModel *model = [[JHChatGoodsInfoModel alloc] init];
    model.title = self.dataModel.productName;
    model.price = self.dataModel.price;
    model.productId = self.dataModel.productId;
    model.goodsPlatformType = 1;
    
    if (self.dataModel.mainImageUrl.count > 0) {
        model.iconUrl = self.dataModel.mainImageUrl[0];
    }
    
    NSDictionary *par = @{@"JHChatGoodsInfoModel" : model};
    NSDictionary *dic = @{@"type" : @"Serice",
                          @"parameter" : par};
    [self.pushvc sendNext:dic];
}
/// 用户教育跳转
- (void)pushEducation {
    NSLog(@"用户教育");
    NSMutableDictionary *parDic = [self getBaseProductDetailStatistic];
    parDic[@"button_name"] = @"严选好物";
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickDetailElement" params:parDic type:JHStatisticsTypeSensors];
    
    NSString *url = self.dataModel.userEducationUrl;
    if (url == nil) { return; }
    NSDictionary *par = @{@"url" : url};
    NSDictionary *dic = @{@"type" : @"Education",
                          @"parameter" : par};
    [self.pushvc sendNext:dic];
    [self reportUserEducationEvent];
}
/// 优惠券
- (void)pushCoupon {
    NSLog(@"优惠券");
    NSString *sellerId = self.dataModel.shopInfo.sellerId;
    if (sellerId == nil) { return; }
    NSDictionary *par = @{@"sellerId" : sellerId};
    NSDictionary *dic = @{@"type" : @"Coupon",
                          @"parameter" : par};
    [self.pushvc sendNext:dic];
}
/// 跳转收藏
- (void)pushCollectList {
//    NSLog(@"收藏");
//    if (![self isLogin]) { return; }
//    NSDictionary *par = @{};
//    NSDictionary *dic = @{@"type" : @"Collect",
//                          @"parameter" : par};
//    [self.pushvc sendNext:dic];
    [self reportCollectListEvent];
}
/// 新人福利
- (void)pushNewUserActivities {
    NSLog(@"新人福利");
    NSString *url = self.dataModel.specialShowInfo.showUrl;
    if (url == nil) { return; }
    NSDictionary *par = @{@"url" : url};
    NSDictionary *dic = @{@"type" : @"NewUserActivities",
                          @"parameter" : par};
    [self.pushvc sendNext:dic];
    [self reportActivityEvent];
}
/// 登录
- (void)pushLogin {
    NSLog(@"新人福利");
    NSDictionary *par = @{};
    NSDictionary *dic = @{@"type" : @"Login",
                          @"parameter" : par};
    [self.pushvc sendNext:dic];
}

/// 弹出出价列表
- (void)pushAuction {
    NSLog(@"出价列表");
    NSDictionary *par = @{@"ansId" : self.dataModel.auctionFlow.auctionSn};
    NSDictionary *dic = @{@"type" : @"Auction",
                          @"parameter" : par};
    [self.pushvc sendNext:dic];
}

- (BOOL)isLogin {
    if (![JHRootController isLogin]) {
        [self pushLogin];
        return false;
    }
    return true;
}
/// 点击购买按钮
- (void)didClickBuy {
    
    switch (self.functionViewModel.purchaseStatus) {
        case PurchaseStateBuy: //购买
            [self pushOrder];
            break;
        case PurchaseStateSalesRemind:
            [self setSalesRemind];
            break;
        case PurchaseStateSalesReminded:
            break;
        case PurchaseStateOff:
            break;
        case PurchaseStateSoldout:
            break;
        default:
            break;
    }
}
/// 设置开售提醒
- (void)setSalesRemind {
    @weakify(self)
    if (![self isLogin]) { return; }
    NSString *productId = self.productId;
    if (productId == nil) { return; }
    
    //秒杀单独设置提醒体系
    if(self.dataModel.existShow && self.dataModel.specialShowInfo.showType.integerValue > 2){
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"productId"] = productId;
        dic[@"showId"] = self.dataModel.specialShowInfo.showId;
        [JHRushPurBusiness  requestSalesReminder:dic completion:^(NSError * _Nullable error) {
            [SVProgressHUD dismiss];
            if (!error) {
                self.functionViewModel.purchaseStatus = PurchaseStateSalesReminded;
                self.toastMsg = @"开售提醒设置成功";
                [self.refreshUpper sendNext:@"remind"];
            }else{
                JHTOAST(error.localizedDescription);
            }
        }];

    }else{
        [JHStoreDetailBusiness salesRemindWithProductId:productId successBlock:^(RequestModel * _Nullable respondObject) {
            @strongify(self)
            self.functionViewModel.purchaseStatus = PurchaseStateSalesReminded;
            self.toastMsg = @"开售提醒设置成功";
            if (self.dataModel.specialShowInfo == nil) { return; }
            [self.dataModel.specialShowInfo addRemindCount];
            JHStoreDetailPriceViewModel *priceModel =  (JHStoreDetailPriceViewModel *)self.cellViewModelList.firstObject.cellViewModelList.firstObject;
            if ([priceModel isKindOfClass:JHStoreDetailPriceViewModel.class]) {
                priceModel.remindCount = @(priceModel.remindCount.integerValue + 1).stringValue;
            }
            [self.refreshUpper sendNext:@"remind"];
        } failureBlock:^(RequestModel * _Nullable respondObject) {
            
        }];
        [self reportSalesRemind];
    }
    
}
/// 点击收藏
- (void)didClickCollect {
    NSLog(@"收藏");
    if (![self isLogin]) { return; }
    @weakify(self)
    if (self.functionViewModel.collectState == 0) {
        [JHStoreDetailBusiness followProduct:self.productId successBlock:^(RequestModel * _Nullable respondObject) {
            @strongify(self)
            
            self.functionViewModel.collectState = 1;
            [self reportCollectEventWithCollectState:true];
            [JHAuthorize clickTriggerPushAuthorizetion:JHAuthorizeClickTypeGoodsCollection];
            
            self.toastMsg = @"收藏成功~";
        } failureBlock:^(RequestModel * _Nullable respondObject) {
            
        }];
    }else{
        [JHStoreDetailBusiness followCancelProduct:self.productId successBlock:^(RequestModel * _Nullable respondObject) {
            @strongify(self)
            self.toastMsg = @"取消收藏成功~";
            self.functionViewModel.collectState = 0;
            [self reportCollectEventWithCollectState:false];
        } failureBlock:^(RequestModel * _Nullable respondObject) {
            
        }];
    }
}
/// 点击关注
- (void)didClickShopFocus {
    NSLog(@"关注");
    if (![self isLogin]) { return; }
    NSString *shopId = self.dataModel.shopInfo.shopId;
    if (shopId == nil) { return; }
    [self reportShopFollowEvent];
    @weakify(self)
    if (self.focusStatus == false) {
        [JHStoreDetailBusiness shopFollowWithShopId:shopId type:@"1" successBlock:^(RequestModel * _Nullable respondObject) {
            @strongify(self)
            self.focusStatus = true;
            self.toastMsg = @"关注成功~";
            [self.dataModel.shopInfo addFollowNum];
            [self.refreshUpper sendNext:nil];
        } failureBlock:^(RequestModel * _Nullable respondObject) {
            
        }];
    }else {
        [JHStoreDetailBusiness shopFollowWithShopId:shopId type:@"0" successBlock:^(RequestModel * _Nullable respondObject) {
            @strongify(self)
            self.focusStatus = false;
            self.toastMsg = @"取消关注成功~";
            [self.dataModel.shopInfo minusFollowNum];
            [self.refreshUpper sendNext:nil];
        } failureBlock:^(RequestModel * _Nullable respondObject) {
            
        }];
    }
}


/// 立即出价
- (void)chuJiaAction{
    if (![self isLogin]) { return; }
    
    //埋点
    NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:0];
    parDic[@"page_position"] = @"商城拍卖商品详情页";
    parDic[@"commodity_id"] = self.productId;
    NSString *original_price = [self.auctionModel.buyerPrice isNotBlank] ?  self.auctionModel.buyerPrice : self.auctionModel.startPrice;
    parDic[@"original_price"] = [NSNumber numberWithInteger:original_price.integerValue/100.f];
    parDic[@"starting_price"] = @(self.auctionModel.startPrice.integerValue/100.f);
    [JHAllStatistics jh_allStatisticsWithEventId:@"immediateBidButtonClick" params:parDic type:JHStatisticsTypeSensors];
    
    if (self.dataModel.auctionFlow.earnestMoney == 0) {
        NSDictionary *par = @{@"isAgent" : @"0"};
        NSDictionary *dic = @{@"type" : @"setAgentAndPrice",
                              @"parameter" : par};
        [self.pushvc sendNext:dic];
    }else{
        self.sureMoneyIsAgent = @"0";
        [self checkSureMoney];
    }

}

/// 设置代理
- (void)agentSetAction{
    if (![self isLogin]) { return; }
    if (self.dataModel.auctionFlow.earnestMoney == 0) {
        NSDictionary *par = @{@"isAgent" : @"1"};
        NSDictionary *dic = @{@"type" : @"setAgentAndPrice",
                              @"parameter" : par};
        [self.pushvc sendNext:dic];
    }else{
        self.sureMoneyIsAgent = @"1";
        [self checkSureMoney];
    }
}
- (void)checkSureMoney{
    [SVProgressHUD show];
    NSMutableDictionary* par = [NSMutableDictionary dictionary];
    par[@"auctionSn"] = self.dataModel.auctionFlow.auctionSn;
    par[@"orderType"] = @"9";
    par[@"orderCategory"] = @"mallAuctionDepositOrder";
    par[@"earnestMoney"] = [NSNumber numberWithInteger:self.dataModel.auctionFlow.earnestMoney].stringValue;
    par[@"productId"] = self.productId;
    par[@"source"] = @"保证金";
    [JHC2CProductDetailBusiness requestC2CPaySureMoney:par completion:^(NSError * _Nullable error, JHC2CSureMoneyModel * model) {
        [SVProgressHUD dismiss];
        if ([model.orderStatus isEqualToString:@"waitpay"]) {
            NSDictionary *par = @{@"OrderID" : model.orderId};
            NSDictionary *dic = @{@"type" : @"paySurePrice",
                                  @"parameter" : par};
            [self.pushvc sendNext:dic];

        }else if([model.orderStatus isEqualToString:@"waitack"]){
            
            [SVProgressHUD showInfoWithStatus:@"订单确认中"];
        }else if([model.orderStatus isEqualToString:@"waitsellersend"]){
            NSDictionary *par = @{@"isAgent" : self.sureMoneyIsAgent};
            NSDictionary *dic = @{@"type" : @"setAgentAndPrice",
                                  @"parameter" : par};
            [self.pushvc sendNext:dic];
        }else{
            [SVProgressHUD showErrorWithStatus:@"获取信息失败"];
        }
    }];

}


#pragma mark - 数据
// 获取商品详情数据
- (void)getDetailInfo {
    if (self.productId == nil) { return; }
    self.auctionModel = nil;
    [JHStoreDetailBusiness getStoreDetailInfoWithProductId:self.productId successBlock:^(JHStoreDetailModel * _Nullable respondObject) {
        self.dataModel = respondObject;
        [self.endRefreshing sendNext:nil];
        //基础信息
        [self setupData];
        
        //依赖详情返回的其他请求信息
        [self getOtherData];
        
        //埋点
        [self reportStoreDetail];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [self.endRefreshing sendNext:nil];
    }];
}

- (void)getOtherData{
    if (self.shotScreen) {return;}
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    dispatch_group_enter(group);
    
    if (self.dataModel.shopInfo.sellerId.length) {
        //获取评论
        dispatch_group_enter(group);
        dispatch_group_enter(group);
        [JHStoreDetailBusiness requestCommentListWithSellerID:self.dataModel.shopInfo.sellerId completion:^(NSError * _Nullable error, JHStoreCommentModel * _Nullable model) {
            self.commentModel = model;
            dispatch_group_leave(group);
        }];
        //获取评论tag
        [JHStoreDetailBusiness requestTagsWithSellerID:self.dataModel.shopInfo.sellerId completion:^(NSError * _Nullable error, NSArray<CommentTagMode *> * _Nullable arr) {
            self.commentTagArr = arr;
            dispatch_group_leave(group);
        }];
    }
    
    //获取同店好货
    [JHStoreDetailBusiness requestSameShopGoodProduct:self.productId shopId:self.dataModel.shopInfo.shopId completion:^(NSError * _Nullable error, NSArray<JHNewStoreHomeGoodsProductListModel *> * _Nullable arr) {
        self.sameShopArr = arr;
        dispatch_group_leave(group);
    }];
    
    [JHStoreDetailBusiness requestRecommendProductGoodProduct:self.productId page:0 completion:^(NSError * _Nullable error, NSArray<JHNewStoreHomeGoodsProductListModel *> * _Nullable arr) {
        self.recommentArr = arr;
        dispatch_group_leave(group);
    }];
    
    if ([self isAuctionProduct]) {
        dispatch_group_enter(group);
        [JHStoreDetailBusiness requestProductDetailPaiMai:self.dataModel.auctionFlow.auctionSn completion:^(NSError * _Nullable error, JHB2CAuctionRefershModel * _Nullable model) {
            self.auctionModel = model;
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self setupData];
    });
}

- (void)refreshAuction:(NSNotification*)notice{
    if (self.hasRefreshAuction) {return;}
    self.hasRefreshAuction = YES;
    NSNumber * fromRefresh = notice.userInfo[@"fromRefresh"];
    [JHStoreDetailBusiness requestProductDetailPaiMai:self.dataModel.auctionFlow.auctionSn completion:^(NSError * _Nullable error, JHB2CAuctionRefershModel * _Nullable model) {
        self.auctionModel = model;
        [self setupData];
        if (fromRefresh.boolValue) {
            JHTOAST(@"更新出价成功");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.hasRefreshAuction = NO;
            });
        }else{
            self.hasRefreshAuction = NO;
        }
    }];
}


- (void)setupData {
    if (self.dataModel == nil) { return; }
    [self.cellViewModelList removeAllObjects];
    
    self.reCommentSectionIndex = NSNotFound;
    self.commentSectionIndex = NSNotFound;

    // 标题、价格、标签区
    JHStoreDetailSectionCellViewModel *section0 = [[JHStoreDetailSectionCellViewModel alloc] init];
    section0.sectionType = SectionType_topPrice;
    
    // 优惠券 区
    JHStoreDetailSectionCellViewModel *section1 = [[JHStoreDetailSectionCellViewModel alloc] init];
    section1.sectionType = SectionType_Coupon;

    // 用户教育 区
    JHStoreDetailSectionCellViewModel *section2 = [[JHStoreDetailSectionCellViewModel alloc] init];
    section2.sectionType = SectionType_Education;
    
    // 规格参数、 商品介绍、商品大图、区
    JHStoreDetailSectionCellViewModel *section3 = [[JHStoreDetailSectionCellViewModel alloc] init];
    section3.sectionType = SectionType_ProductDetail;

    //店铺区域
    JHStoreDetailSectionCellViewModel *section4 = [[JHStoreDetailSectionCellViewModel alloc] init];
    section4.sectionType = SectionType_Shop;

    //保障图片区域
    JHStoreDetailSectionCellViewModel *section5 = [[JHStoreDetailSectionCellViewModel alloc] init];
    section5.sectionType = SectionType_BaoZhang;
    // 拍卖出价记录
    JHStoreDetailSectionCellViewModel *sectionAuction = [[JHStoreDetailSectionCellViewModel alloc] init];
    sectionAuction.sectionType = SectionType_AuctionList;

    // 留言评价
    JHStoreDetailSectionCellViewModel *commentsection = [[JHStoreDetailSectionCellViewModel alloc] init];
    commentsection.sectionType = SectionType_Comment;

    // 通电好货 推荐
    JHStoreDetailSectionCellViewModel *reCommentsection = [[JHStoreDetailSectionCellViewModel alloc] init];
    reCommentsection.sectionType = SectionType_SameShop;

    // 分享信息
    [self setupShare];
    
    // 表头、视频+图片
    [self setupHeaderData];
    
    // 商品售卖状态描述
    [self setupSellStatusDesc];
    
    // 商品售卖状态
    [self setupSellStatus];
    
    // 收藏状态
    [self setupCollectStatus];
    
    // 价格
    [self setupPriceWithSection:section0];
    // 标题
    [self setupTitleWithSection:section0];
    // 标签
    [self setupTagWithSection:section0];
    // 专场
    [self setupSpecialWithSection:section0];
    
    // 拍卖
    BOOL hasAuctionList = [self setupAutionListSection:sectionAuction];

    // 优惠券
    BOOL hasCoupon = [self setupCouponWithSection:section1];
    // 用户教育
    BOOL hasEducation = [self setupEducationWithSection:section2];
    // 规格
    BOOL hasSpec = [self setupSpecWithSection:section3];
    // 商品描述
    BOOL hasGoodDes = [self setupGoodsDesWithSection:section3];
    // 商品大图
    BOOL hasGoodImage = [self setupGoodsImageWithSection:section3];
    // 店铺title
    BOOL hasShopTitle = [self setupShopTitleWithSection:section4];
    // 店铺
    BOOL hasShop = [self setupShopWithSection:section4];
    // 保障
    BOOL hasSecurity = [self setupSecurityWithSection:section5];
    // 留言评价
    BOOL hasComment = [self setupCommentSection:commentsection];

    
    // 同店
    BOOL hasSameShop = [self setupSameShopSection:reCommentsection];
    // 推荐
    BOOL hasRecoment = [self setupRecomentSection:reCommentsection];

    
    // 添加分区
    [self.cellViewModelList appendObject:section0];
    if (hasCoupon) {
        [self.cellViewModelList appendObject:section1];
    }
    if (hasEducation) {
        [self.cellViewModelList appendObject:section2];
    }
    if (hasAuctionList){
        [self.cellViewModelList appendObject:sectionAuction];
        sectionAuction.sectionIndex = [self.cellViewModelList indexOfObject:sectionAuction];
    }
    if (hasSpec || hasGoodDes || hasGoodImage) {
        [self.cellViewModelList appendObject:section3];
        section3.sectionIndex = [self.cellViewModelList indexOfObject:section3];
        self.specSectionIndex = section3.sectionIndex;
    }
    if ((hasShop || hasShopTitle) && !self.shotScreen) {
        [self.cellViewModelList appendObject:section4];
    }
    if (hasComment) {
        [self.cellViewModelList appendObject:commentsection];
        commentsection.sectionIndex = [self.cellViewModelList indexOfObject:commentsection];
        self.commentSectionIndex = commentsection.sectionIndex;
    }
    if (hasSecurity) {
        [self.cellViewModelList appendObject:section5];
    }
    if (hasSameShop || hasRecoment) {
        [self.cellViewModelList appendObject:reCommentsection];
        reCommentsection.sectionIndex = [self.cellViewModelList indexOfObject:reCommentsection];
        self.reCommentSectionIndex = reCommentsection.sectionIndex;
    }

    // 刷新列表
    [self.refreshTableView sendNext:nil];
    
    [self refreshVCNav];
}

- (void)refreshVCNav{
    BOOL hasComment = self.commentSectionIndex != NSNotFound;
    BOOL hasReComment = self.reCommentSectionIndex != NSNotFound;
    [self.refreshNav sendNext:RACTuplePack(@(hasComment), @(hasReComment))];
}


#pragma mark - 默认占位数据
- (void)setupPlaceholderData {
    self.dataModel = [[JHStoreDetailModel alloc]init];
    
    self.dataModel.mainImageUrl = @[@""];
    self.dataModel.mainImageMiddleUrl = @[@""];
    self.dataModel.productSellStatus = @"0";
    [self setupData];
//    [self.cellViewModelList removeAllObjects];
//    // 标题、价格、标签区
//    JHStoreDetailSectionCellViewModel *section0 = [[JHStoreDetailSectionCellViewModel alloc] init];
//    // 用户教育 区
//    JHStoreDetailSectionCellViewModel *section2 = [[JHStoreDetailSectionCellViewModel alloc] init];
//    // 表头、视频+图片
//    [self setupHeaderData];
//    // 售卖状态
//    [self setupSellStatus];
//    // 用户教育
//    BOOL hasEducation = [self setupEducationWithSection:section2];
//    // 添加分区
//    [self.cellViewModelList appendObject:section0];
//    if (hasEducation) {
//        [self.cellViewModelList appendObject:section2];
//    }
//    // 刷新列表
//    [self.refreshTableView sendNext:nil];
}
#pragma mark - 表头、视频+图片
- (void)setupHeaderData {
    self.videoUrl = self.dataModel.videoUrl;
    
    [self.headerViewModel setupDataWithVideoUrl:self.dataModel.videoCoverUrl
                                      imageList:self.dataModel.mainImageMiddleUrl
                                     mediumUrls:self.dataModel.mainImageUrl];
    
}
#pragma mark - 价格区
- (void)setupPriceWithSection : (JHStoreDetailSectionCellViewModel*)section {
    
    NSString *salePrice = self.dataModel.price;
    NSString *price ;
    StoreDetailType type = Normal;
    NSString *startTime;
    NSInteger countdownTime = 0;
    NSString *titleText;
    NSString *discount;
    JHStoreDetailPriceViewModel *priceModel = [[JHStoreDetailPriceViewModel alloc] init];
    //拍卖
    if([self isAuctionProduct]){
        type = Auction;
        //刷新接口数据优先展示
        if (self.auctionModel) {
            JHB2CAuctionRefershModel *auModel = self.auctionModel;
            
            //所有异常状态以及流拍
            StoreDetailAuctionStatus aus = StoreDetailAuctionStatus_Finish_noBuyer;
            
            //预告状态
            if (auModel.productDetailStatus  == 10 ||
                auModel.productDetailStatus  == 11) {
                aus = StoreDetailAuctionStatus_YuGao;
                salePrice = [CommHelp getPriceWithInterFen:self.auctionModel.startPrice.integerValue];
            //拍卖中
            }else if(auModel.productDetailStatus ==  20 ||
                     auModel.productDetailStatus ==  21 ||
                     auModel.productDetailStatus ==  22){
                aus = auModel.buyerPrice.length ? StoreDetailAuctionStatus_InSelling : StoreDetailAuctionStatus_InSelling_noBuyer;
                if(auModel.buyerPrice.length){salePrice = [CommHelp getPriceWithInterFen:auModel.buyerPrice.integerValue];}

            //拍卖结束 不包括流拍
            }else if(auModel.productDetailStatus ==  31 ||
                     auModel.productDetailStatus ==  32 ||
                     auModel.productDetailStatus ==  33 ||
                     auModel.productDetailStatus ==  35){
                aus = StoreDetailAuctionStatus_Finish;
                if(auModel.buyerPrice.length){salePrice = [CommHelp getPriceWithInterFen:auModel.buyerPrice.integerValue];}
            }
            priceModel.auctionStatus = aus;
            priceModel.remindCount = auModel.auctionRemindCount;
            priceModel.maxBuyerPrice = auModel.buyerPrice;
            priceModel.auStartTime = auModel.auctionStartTime;
            countdownTime = auModel.endTime;
            price = [CommHelp getPriceWithInterFen:self.auctionModel.startPrice.integerValue];
    //刷新接口为返回，暂时使用详情接口
        }else{
            JHProductAuctionFlowModel *auModel = self.dataModel.auctionFlow;
            //所有异常状态以及流拍
            StoreDetailAuctionStatus aus = StoreDetailAuctionStatus_Finish_noBuyer;
            salePrice = [CommHelp getPriceWithInterFen:auModel.startPrice];
            //预告状态
            if (auModel.productDetailStatus  == 10 ||
                auModel.productDetailStatus  == 11) {
                aus = StoreDetailAuctionStatus_YuGao;
            //拍卖中
            }else if(auModel.productDetailStatus ==  20 ||
                     auModel.productDetailStatus ==  21 ||
                     auModel.productDetailStatus ==  22){
                aus = auModel.maxBuyerPrice.length ? StoreDetailAuctionStatus_InSelling : StoreDetailAuctionStatus_InSelling_noBuyer;
                if(auModel.maxBuyerPrice.length){salePrice = auModel.maxBuyerPrice;}
            //拍卖结束 不包括流拍
            }else if(auModel.productDetailStatus ==  31 ||
                     auModel.productDetailStatus ==  32 ||
                     auModel.productDetailStatus ==  33 ||
                     auModel.productDetailStatus ==  35){
                aus = StoreDetailAuctionStatus_Finish;
                if(auModel.maxBuyerPrice.length){salePrice = auModel.maxBuyerPrice;}
            }
            priceModel.auctionStatus = aus;
            priceModel.remindCount = auModel.auctionRemindCount;
            priceModel.maxBuyerPrice = auModel.maxBuyerPrice;
            priceModel.auStartTime = auModel.auctionStartTime;
            countdownTime = auModel.endTime;
            price = [CommHelp getPriceWithInterFen:auModel.startPrice];
        }
    }else if (self.dataModel.existShow) {
        ProductSpecialShowInfo *specialInfo = self.dataModel.specialShowInfo;
        salePrice = specialInfo.showPrice;
        price = self.dataModel.price;
        discount = specialInfo.showDiscount;
        priceModel.detailText = @"距专场结束";
        if ([specialInfo.showType isEqualToString:@"0"]) {
            type = NewUser;
            titleText = @"新人价";
        }else if ([specialInfo.showType isEqualToString:@"1"]) {
            titleText = @"专场价";
            if ([specialInfo.showStatus isEqualToString:@"1"]) { // 热卖
                type = HotSale;
                
                if (specialInfo.showRemainTime > 0) {
                    countdownTime = specialInfo.showRemainTime;
                }else{
                    type = Normal;
                    salePrice = self.dataModel.price;
                    price = nil;
                }
            }else if ([specialInfo.showStatus isEqualToString:@"0"]) { // 预告
                type = Preview;
                
                startTime = specialInfo.showSaleStartTime;
                RAC(priceModel, previewNumText) = RACObserve(specialInfo, showRemindCount);
            }else if ([specialInfo.showStatus isEqualToString:@"2"]) { // 结束
                type = Normal;
            }
        }else{
            titleText = @"秒杀价";
            priceModel.detailText = @"距秒杀结束";
            discount = nil;
            if ([specialInfo.showStatus isEqualToString:@"1"]) { // 热卖
                type = RushPurChase;
                if (specialInfo.showRemainTime > 0) {
                    countdownTime = specialInfo.showRemainTime;
                }else{
                    type = Normal;
                    salePrice = self.dataModel.price;
                    price = nil;
                }
            }else if ([specialInfo.showStatus isEqualToString:@"0"]) { // 预告
                type = RushPurChase;
                priceModel.detailText = @"距秒杀开始";
                if (specialInfo.showRemainTime > 0) {
                    countdownTime = specialInfo.showRemainTime;
                }else{
                    type = Normal;
                    salePrice = self.dataModel.price;
                    price = nil;
                }
            }else if ([specialInfo.showStatus isEqualToString:@"2"]) { // 结束
                type = Normal;
            }

        }
        
    }
    
    [priceModel setupDataWithSalePrice:salePrice price:price isAuction:[self isAuctionProduct] discount:discount];
    if (startTime != nil && startTime.length > 0) {
        priceModel.previewSaleDateText = startTime;
    }
    if (countdownTime > 1) {
        priceModel.countdownTime = countdownTime  / 1000;
//        @weakify(self)
        [RACObserve(priceModel, countdownTime) subscribeNext:^(id  _Nullable x) {
//            @strongify(self)
            NSInteger time = [x integerValue];
            if (time <= 0 && self.type != Auction) {
                [priceModel setupDataWithSalePrice:price price:nil isAuction:[self isAuctionProduct] discount:nil];
            }
        }];
    }
    
    if (titleText.length > 0) {
        priceModel.titleText = titleText;
    }
    
    priceModel.type = type;
    self.type = type;
    
    @weakify(self)
    [priceModel.reloadCellSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.refreshCell sendNext:RACTuplePack(@"0", @"0")];
    }];
    [priceModel.pushvc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if ([x isEqualToString:@"NewUserActivities"]) {
            [self pushNewUserActivities];
        }
    }];
    
    [section.cellViewModelList appendObject:priceModel];
}
#pragma mark - 标题区
- (void)setupTitleWithSection : (JHStoreDetailSectionCellViewModel*)section {
    NSString *title = self.dataModel.productName;
    
    BOOL isOrphan = [self.dataModel.uniqueStatus isEqualToString:@"1"];
    
    JHStoreDetailTitleViewModel *titleModel = [[JHStoreDetailTitleViewModel alloc]
                                          initWithText:title isOrphan:isOrphan];
    [section.cellViewModelList appendObject:titleModel];
}
#pragma mark - 标签区
- (void)setupTagWithSection : (JHStoreDetailSectionCellViewModel*)section {
    JHStoreDetailTagViewModel *tagModel = [[JHStoreDetailTagViewModel alloc] init];
    
    NSMutableArray *list = [[NSMutableArray alloc] init];
    
    if (self.dataModel.productTagList == nil || self.dataModel.productTagList.count <= 0) { return; }
    for (NSString *tag in self.dataModel.productTagList) {
        JHStoreDetailTagItemViewModel *tagItem = [[JHStoreDetailTagItemViewModel alloc] init];
        tagItem.titleText = tag;
        [list appendObject:tagItem];
    }
    tagModel.itemList = list;
    
    [section.cellViewModelList appendObject:tagModel];
}
#pragma mark - 专场区
- (void)setupSpecialWithSection : (JHStoreDetailSectionCellViewModel*)section {
    if (self.dataModel.existShow == false) { return; }
    // 此区域不展示新人福利入口
    if ([self.dataModel.specialShowInfo.showType isEqualToString:@"0"]) { return; }
    if (self.dataModel.specialShowInfo.showName == nil) { return; }
    JHStoreDetailSpecialViewModel *special = [[JHStoreDetailSpecialViewModel alloc] init];
    special.titleText = self.dataModel.specialShowInfo.showName;
    
    [section.cellViewModelList appendObject:special];
    
    @weakify(self)
    [special.pushvc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self pushSpecialShow];
    }];
}
#pragma mark - 优惠券区
- (BOOL)setupCouponWithSection : (JHStoreDetailSectionCellViewModel*)section {
    if (self.dataModel.couponList == nil || self.dataModel.couponList.count <= 0 ) { return false; }
    JHStoreDetailCouponViewModel *coupon = [[JHStoreDetailCouponViewModel alloc] init];
    for (NSString *str in self.dataModel.couponList) {
        JHStoreDetailCouponItemViewModel *item = [[JHStoreDetailCouponItemViewModel alloc] init];
        item.titleText = str;
        [coupon.itemList appendObject:item];
    }
    @weakify(self)
    [coupon.pushvc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self pushCoupon];
    }];
    
    [section.cellViewModelList appendObject:coupon];
    
    return true;
}
#pragma mark - 用户教育区
- (BOOL)setupEducationWithSection : (JHStoreDetailSectionCellViewModel*)section {
    JHStoreDetailEducationViewModel *education = [[JHStoreDetailEducationViewModel alloc] init];
    BOOL straightHair = self.dataModel.directDelivery == 1 ? YES : NO;
    education.currentBusinessModel = straightHair ? JHBusinessModel_SH : JHBusinessModel_De;
    [section.cellViewModelList appendObject:education];
    
    @weakify(self)
    [education.pushvc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self pushEducation];
    }];
    
    return true;
}
#pragma mark - 出价记录
- (BOOL)setupAutionListSection : (JHStoreDetailSectionCellViewModel*)section {
    if ([self isAuctionProduct] && self.auctionModel) {
        JHStoreDetailAuctionListViewModel *auction = [[JHStoreDetailAuctionListViewModel alloc] init];
        auction.addPrice = self.auctionModel.bidIncrement;
        auction.auctionSn = self.auctionModel.auctionSn;
        [section.cellViewModelList appendObject:auction];
        @weakify(self);
        [auction.reloadCellSubject subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            [self.refreshCell sendNext:x];
        }];
        [auction.pushvc subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            [self pushAuction];
        }];
        auction.historyRecords = self.historyRecords;
        auction.listCount = self.auctionModel.number;
        [auction.recordsArrSubject subscribeNext:^(NSArray<JHC2CJiangPaiRecord *> * _Nullable x) {
            @strongify(self);
            self.historyRecords = x;
        }];

        return YES;
    }
    return NO;
}


#pragma mark - 同店
- (BOOL)setupSameShopSection : (JHStoreDetailSectionCellViewModel*)section {
    if (!self.sameShopArr.count) {return NO;}
    JHB2CSameShopCellViewModel *auction = [[JHB2CSameShopCellViewModel alloc] init];
    auction.rowIndex = 0;
    [section.cellViewModelList appendObject:auction];
    auction.listDataArr = self.sameShopArr;
    @weakify(self);
    [RACObserve(section, sectionIndex) subscribeNext:^(id  _Nullable x) {
        auction.sectionIndex = [x unsignedIntegerValue];
    }];

    [auction.reloadCellSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.refreshCell sendNext:x];
    }];
    [auction.pushvc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self pushOtherProductDetail:x isSameShop:YES];
    }];
    return true;
}

#pragma mark - 推荐
- (BOOL)setupRecomentSection : (JHStoreDetailSectionCellViewModel*)section {
    if (!self.recommentArr.count) {return NO;}
    JHB2CRecommenViewModel *auction = [[JHB2CRecommenViewModel alloc] init];
    auction.productId = self.productId;
    auction.rowIndex = self.sameShopArr.count ? 1 : 0;
    auction.recommentArr = self.recommentArr;
    [section.cellViewModelList appendObject:auction];
    @weakify(self);
    [RACObserve(section, sectionIndex) subscribeNext:^(id  _Nullable x) {
        auction.sectionIndex = [x unsignedIntegerValue];
    }];
    [auction.reloadCellSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.refreshCell sendNext:x];
    }];
    [auction.pushvc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self pushOtherProductDetail:x isSameShop:NO];
    }];
    return true;
}

#pragma mark - 留言评价区域
- (BOOL)setupCommentSection: (JHStoreDetailSectionCellViewModel*)section {
    if (!self.commentModel.datas.count) {return NO;}
    
    NSMutableArray *reloadSignalArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *pushSignalArr = [NSMutableArray arrayWithCapacity:0];

    //评论headerCell
    JHB2CCommentHeaderViewModel *auction0 = [[JHB2CCommentHeaderViewModel alloc] init];
    auction0.rowIndex = 0;
    auction0.countOfComment = self.commentModel.countStr;
    auction0.haoPing = self.dataModel.shopInfo.orderGrades; // self.commentModel.orderGrade;
    [section.cellViewModelList appendObject:auction0];
    
    auction0.tagArr = [self.commentTagArr jh_map:^id _Nonnull(CommentTagMode * _Nonnull obj, NSUInteger idx) {
        if ([obj.tagName isEqualToString:@"全部"]) {
            return nil;
        }
        return [NSString stringWithFormat:@"%@ (%@)",obj.tagName,obj.countStr];
    }];
    [reloadSignalArr addObject:auction0.reloadCellSubject];
    
    [pushSignalArr addObject:auction0.pushvc];
    
    for (NSInteger i = 0 ; i< MIN(self.commentModel.datas.count, 3); i++) {
        JHB2CCommentViewModel *auction = [[JHB2CCommentViewModel alloc] init];
        auction.rowIndex = 1 + i;
        auction.commentMode = self.commentModel.datas[i];
        [section.cellViewModelList appendObject:auction];
        [reloadSignalArr addObject:auction.reloadCellSubject];
        [pushSignalArr addObject:auction.pushvc];
        [RACObserve(section, sectionIndex) subscribeNext:^(id  _Nullable x) {
            auction.sectionIndex = [x integerValue];
        }];
    }
    RACSignal* mergeReloadSignal = [RACSignal merge:reloadSignalArr];
    RACSignal* mergePushSignal = [RACSignal merge:pushSignalArr];
    @weakify(self);
    [mergeReloadSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.refreshCell sendNext:x];
    }];
    [mergePushSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self pushCommentDetailAndStatic:NO];
    }];
    [auction0.moreBtnAction subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self pushCommentDetailAndStatic:YES];
    }];

    return true;
}

#pragma mark - 店铺title区
- (BOOL)setupShopTitleWithSection : (JHStoreDetailSectionCellViewModel*)section {
    if (self.dataModel.shopInfo == nil) { return false; }
    ProductShopInfo *shopInfo = self.dataModel.shopInfo;
    JHStoreDetailShopTitleViewModel *shopTitle = [[JHStoreDetailShopTitleViewModel alloc] init];
    
    shopTitle.iconUrl = shopInfo.shopLogoImg;
    shopTitle.titleText = shopInfo.shopName;
    shopTitle.totalScore = shopInfo.comprehensiveScore;
    shopTitle.praiseText = shopInfo.orderGrades;
    shopTitle.sellerType = shopInfo.sellerType;
    self.focusStatus = shopInfo.followStatus;
    
    RAC(shopTitle, focusStatus) = RACObserve(self, focusStatus);
    
    [section.cellViewModelList appendObject:shopTitle];
    
    @weakify(self)
    RAC(shopTitle, fansText) = RACObserve(shopInfo, followNum);
    [shopTitle.pushvc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self pushShop];
    }];
    [shopTitle.focusAction subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self didClickShopFocus];
    }];
    
    [shopTitle.goShopBtnAction subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self pushShopOnlyBtn];
    }];
    return true;
}
#pragma mark - 店铺区
- (BOOL)setupShopWithSection : (JHStoreDetailSectionCellViewModel*)section {
    if (self.dataModel.shopInfo == nil) { return false; }
    ProductShopInfo *shopInfo = self.dataModel.shopInfo;
    if (shopInfo.shopProductList == nil || shopInfo.shopProductList.count <= 0) { return false; }
    
    JHStoreDetailShopViewModel *shop = [[JHStoreDetailShopViewModel alloc] init];
    
    for (ShopProductInfo *info in shopInfo.shopProductList) {
        JHStoreDetailShopItemViewModel *shopItem = [[JHStoreDetailShopItemViewModel alloc] init];
        shopItem.iconUrl = info.coverImage.url;
        shopItem.titleText = info.productName;
        if (info.showPrice != nil && info.showPrice.length > 0) {
            [shopItem setupPrice:info.showPrice];
        }else {
            [shopItem setupPrice:info.price];
        }
        [shop.itemList appendObject:shopItem];
    }
    [section.cellViewModelList appendObject:shop];
    
    @weakify(self)
    [shop.pushvc subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self pushShopProduct];
    }];
    
    return true;
}
#pragma mark - 规格区
- (BOOL)setupSpecWithSection : (JHStoreDetailSectionCellViewModel*)section {
    if (self.dataModel.productAttrList == nil || self.dataModel.productAttrList.count <= 0) { return false; }
    JHStoreDetailSectionTitleViewModel *specTitle = [[JHStoreDetailSectionTitleViewModel alloc] init];
    specTitle.titleText = @"规格参数";
    [section.cellViewModelList appendObject:specTitle];
    
    for (ProductSpecInfo *spec in self.dataModel.productAttrList) {
        JHStoreDetailSpecViewModel *specModel = [[JHStoreDetailSpecViewModel alloc] init];
        specModel.titleText = spec.attrName;
        specModel.detailText = spec.attrValue;
        specModel.hasIntroduct = spec.attrDescTitle.length;
        specModel.attrDescTitle = spec.attrDescTitle;
        specModel.ID = spec.ID;
        [section.cellViewModelList appendObject:specModel];
        @weakify(self);
        [specModel.pushvc subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self pushShowIntroduct:x];
        }];

    }
    return true;
}
#pragma mark - 商品介绍区
- (BOOL)setupGoodsDesWithSection : (JHStoreDetailSectionCellViewModel*)section {
    
    if (self.dataModel.productDesc == nil || self.dataModel.productDesc.length <= 0) { return false; }
    
    JHStoreDetailSectionTitleViewModel *goodsTitle = [[JHStoreDetailSectionTitleViewModel alloc] init];
    goodsTitle.titleText = @"商品特征";
    
    JHStoreDetailGoodsDesViewModel *goodsDes = [[JHStoreDetailGoodsDesViewModel alloc] init];
    goodsDes.titleText = self.dataModel.productDesc;
    [RACObserve(section, sectionIndex) subscribeNext:^(id  _Nullable x) {
        goodsDes.sectionIndex = [x unsignedIntegerValue];
    }];
    @weakify(self)
    [goodsDes.reloadCellSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.refreshCell sendNext:x];
    }];

    [section.cellViewModelList appendObject:goodsTitle];
    [section.cellViewModelList appendObject:goodsDes];
    goodsDes.rowIndex = [section.cellViewModelList indexOfObject:goodsDes];
    
    return true;
}
#pragma mark - 商品图片区
- (BOOL)setupGoodsImageWithSection : (JHStoreDetailSectionCellViewModel*)section {
    
    if (self.dataModel.detailImages == nil || self.dataModel.detailImages.count <= 0) { return false; }
    
    JHStoreDetailSectionTitleViewModel *imageTitle = [[JHStoreDetailSectionTitleViewModel alloc] init];
    imageTitle.titleText = @"商品详情";
    
    [section.cellViewModelList appendObject:imageTitle];
    
    NSArray *imageInfos = self.dataModel.detailImages;
    
    NSMutableArray *imageUrls = [NSMutableArray new];
    NSMutableArray *mediumImageUrls = [NSMutableArray new];
    for (ProductImageInfo *imageInfo in imageInfos) {
        [imageUrls appendObject:imageInfo.middleUrl];
        [mediumImageUrls appendObject:imageInfo.url];
    }
    
    self.goodsThumbsUrls = imageUrls;

    self.goodsMediumUrls = mediumImageUrls;
    self.goodsLargeUrls = mediumImageUrls;
    
    NSInteger index = 0;
    for (ProductImageInfo *imageInfo in self.dataModel.detailImages) {
        JHStoreDetailImageViewModel *image = [[JHStoreDetailImageViewModel alloc] init];
        image.imageUrl = imageInfo.middleUrl;
        image.index = index;
        image.width = ScreenW;
        CGFloat height = (ScreenW - 24) * imageInfo.height / imageInfo.width + 8;
        image.height = height;
        [section.cellViewModelList appendObject:image];
        index += 1;
    }
    
    return true;
}
#pragma mark - 保障区
- (BOOL)setupSecurityWithSection : (JHStoreDetailSectionCellViewModel*)section {
    JHStoreDetailSecurityViewModel *security = [[JHStoreDetailSecurityViewModel alloc] init];
    security.directDelivery = self.dataModel.directDelivery == 1;
    BOOL straightHair = self.dataModel.directDelivery == 1 ? YES : NO;
    security.currentBusinessModel = straightHair ? JHBusinessModel_SH : JHBusinessModel_De;
    [section.cellViewModelList appendObject:security];
    @weakify(self);
    [security.pushvc subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self pushEducation];
    }];
    return true;
}
#pragma mark - 分享信息
- (void)setupShare {
    if (self.dataModel.shareInfo == nil) { return; }
    self.shareInfo = [JHShareInfo new];
    self.shareInfo.title = self.dataModel.shareInfo.title;
    self.shareInfo.desc = self.dataModel.shareInfo.desc;
    self.shareInfo.url = self.dataModel.shareInfo.url;
    self.shareInfo.img = self.dataModel.shareInfo.img;
    self.shareInfo.shareType = ShareObjectTypeStoreGoodsDetail;
}
#pragma mark - 商品售卖状态描述
- (void)setupSellStatusDesc {
    if (self.dataModel.productSellStatusDesc == nil || self.dataModel.productSellStatusDesc.length <= 0) { return; }
    self.productSellStatusDesc = self.dataModel.productSellStatusDesc;

}
#pragma mark - 商品售卖状态
- (void)setupSellStatus {
    //拍卖
    if([self isAuctionProduct]){
        JHB2CAuctionRefershModel *auModel = self.auctionModel;
        self.functionViewModel.functionView_type = JHStoreDetailFunctionView_Type_Auction;
        self.functionViewModel.auModel = auModel;
        self.functionViewModel.detailAuModel = self.dataModel.auctionFlow;
        PurchaseState purchaseState = PurchaseStateOff;
        NSInteger productStatus = auModel ? auModel.productDetailStatus : self.dataModel.auctionFlow.productDetailStatus;
        //预告状态未提醒
        if (productStatus  == 10){
            purchaseState = PurchaseStateSalesRemind;
        }else if(productStatus  == 11){
            purchaseState = PurchaseStateSalesReminded;
            //出价状态
        }else if(productStatus ==  20 ||
                 productStatus ==  22){
            purchaseState = PurchaseStateAuction_Selling;
            //出价领先
        }else if(productStatus ==  21){
            purchaseState = PurchaseStateAuction_Selling_LingXian;
        //流拍
        }else if(productStatus ==  30){
            purchaseState = PurchaseStateFinish;
        //售出
        }else if(productStatus ==  31 ||
                 productStatus ==  33 ||
                 productStatus ==  35){
            purchaseState = PurchaseStateFinish_Soldout;
        }else if(productStatus ==  32){
            purchaseState = PurchaseStateBuy;
        }
        self.functionViewModel.purchaseStatus = purchaseState;
//    //普通
    }else{
        if(self.dataModel.existShow && [self.dataModel.specialShowInfo.showType isEqualToString:@"3"]){
            self.functionViewModel.functionView_type = JHStoreDetailFunctionView_Type_RushPurchase;
        }else{
            if ([self isShowQuanHouPrice]) {
                self.functionViewModel.discountPrice = self.dataModel.discountPrice;
            }
        }
        
        NSInteger status = [self.dataModel.productSellStatus integerValue];
        PurchaseState purchaseState = PurchaseStateBuy;
        switch (status) {
            case 0:
                // 可售库存为0且存在待支付订单 不可购买
                if (self.dataModel.productSellStatusDesc != nil &&
                    self.dataModel.sellStock <= 0) {
                    purchaseState = PurchaseStateCantBuy;
                }else{
                    purchaseState = PurchaseStateBuy;
                }
                break;
            case 1:
                purchaseState = PurchaseStateOff;
                break;
            case 2:
                purchaseState = PurchaseStateSoldout;
                break;
            case 3:
                purchaseState = PurchaseStateSalesRemind;
                break;
            case 4:
                purchaseState = PurchaseStateSalesReminded;
                break;
            default:
                break;
        }
        self.functionViewModel.purchaseStatus = purchaseState;

    }
}
#pragma mark - 收藏状态
- (void)setupCollectStatus {
    self.functionViewModel.collectState = self.dataModel.followStatus;
}
#pragma mark - 工具条
- (void)bindFunction {
    @weakify(self)
    [self.functionViewModel.buyAction subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self didClickBuy];
    }];
    [self.functionViewModel.shopAction subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self pushShop];
    }];
    [self.functionViewModel.serviceAction subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self pushSerice];
    }];
    [self.functionViewModel.collectAction subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self didClickCollect];
    }];
    
    //立即出价
    [self.functionViewModel.buyPriceAction subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self chuJiaAction];
    }];
    //设置代理
    [self.functionViewModel.agentSetAction subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self agentSetAction];
    }];

}




#pragma mark - Lazy
- (NSString *)businessId {
    return _dataModel.shopInfo.sellerId;
}
- (void)setProductId:(NSString *)productId {
    _productId = productId;
    [self setupPlaceholderData];
}
- (NSMutableArray<JHStoreDetailSectionCellViewModel *> *)cellViewModelList {
    if (!_cellViewModelList) {
        _cellViewModelList = [NSMutableArray array];
    }
    return _cellViewModelList;
}
- (JHStoreDetailHeaderViewModel *)headerViewModel {
    if (!_headerViewModel) {
        _headerViewModel = [[JHStoreDetailHeaderViewModel alloc] init];
    }
    return _headerViewModel;
}
- (JHStoreDetailFunctionViewModel *)functionViewModel {
    if (!_functionViewModel) {
        _functionViewModel = [[JHStoreDetailFunctionViewModel alloc] init];
    }
    return _functionViewModel;
}
- (RACReplaySubject *)refreshTableView {
    if (!_refreshTableView) {
        _refreshTableView = [RACReplaySubject subject];
    }
    return _refreshTableView;
}
- (RACReplaySubject<RACTuple *> *)refreshCell {
    if (!_refreshCell) {
        _refreshCell = [RACReplaySubject subject];
    }
    return _refreshCell;
}
- (RACSubject<NSDictionary *> *)pushvc {
    if (!_pushvc) {
        _pushvc = [RACSubject subject];
    }
    return _pushvc;
}
- (RACSubject *)endRefreshing {
    if (!_endRefreshing) {
        _endRefreshing = [RACSubject subject];
    }
    return _endRefreshing;
}
- (RACSubject *)refreshUpper {
    if (!_refreshUpper) {
        _refreshUpper = [RACSubject subject];
    }
    return _refreshUpper;
}

- (RACReplaySubject<RACTuple *> *)refreshNav {
    if (!_refreshNav) {
        _refreshNav = [RACReplaySubject subject];
    }
    return _refreshNav;
}

#pragma mark - 埋点
/// 返回顶部事件
- (void)reportBackTopEvent {
    [JHAllStatistics jh_allStatisticsWithEventId:@"backTopClick"
                                          params:@{@"store_from" : @"商品详情页"}
                                            type:JHStatisticsTypeSensors];
}
/// 专场入口进入事件
- (void)reportSpecialShowEvent {
    NSDictionary *par = @{
        @"store_from" : @"商品详情页",
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"jgqzcClick"
                                          params:par
                                            type:JHStatisticsTypeSensors];
}

/// 新人活动入口进入事件
- (void)reportActivityEvent {
    [JHAllStatistics jh_allStatisticsWithEventId:@"xrhdClick"
                                          params:@{@"store_from" : @"商品详情页"}
                                            type:JHStatisticsTypeSensors];
}
/// 开售提醒点击事件
- (void)reportSalesRemind {
    
    NSString *zcid = [self getShowId];
    NSString *zcname = [self getShowName];
    NSDictionary *par = @{
        @"zc_id" : zcid,
        @"zc_name" : zcname,
        @"tx_type" : @"商品",
        @"store_from" : @"商品详情页",
        @"commodity_id" : self.productId,
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"kstxClick"
                                          params:par
                                            type:JHStatisticsTypeSensors];
}
/// 收藏
- (void)reportCollectEventWithCollectState : (BOOL) collectState {
    // 点击事件 应与 源状态相反
    NSDictionary *par = @{
        @"commodity_id" : self.productId,
        @"commodity_name" : self.dataModel.productName,
        @"is_favorite" : @(collectState),
        @"favorite_Type" : @"goods",
        @"page_position" : @"goodsinfo",
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickFavorite"
                                          params:par
                                            type:JHStatisticsTypeSensors];
}
/// 跳转收藏点击事件
- (void)reportCollectListEvent {
    NSString *zcid = [self getShowId];
    NSString *zcname = [self getShowName];

    NSDictionary *par = @{
        @"zc_id" : zcid,
        @"zc_name" : zcname,
        @"store_from" : @"商品详情页",
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"scClick"
                                          params:par
                                            type:JHStatisticsTypeSensors];
}
/// 分享点击
- (void)reportShareEvent {
    NSString *zcid = [self getShowId];
    NSString *zcname = [self getShowName];
    NSString *item_id = self.productId;
    NSDictionary *par = @{
        @"zc_id" : zcid,
        @"zc_name" : zcname,
        @"store_from" : @"商品详情页",
        @"item_id":NONNULL_STR(item_id)
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"shareClick"
                                          params:par
                                            type:JHStatisticsTypeSensors];
}
/// 商品详情浏览
- (void)reportStoreDetail {
    if (isReportStoreDetail == true) { return; }
    isReportStoreDetail = true;
    
    NSString *zcid = [self getShowId];
    NSString *zcname = [self getShowName];
    NSString *price = self.dataModel.specialShowInfo.showPrice ? self.dataModel.specialShowInfo.showPrice : self.dataModel.price;
    
    NSMutableDictionary *par = [[NSMutableDictionary alloc] init];
    [par setValue:self.fromPage forKey:@"source_page"];
    [par setValue:self.dataModel.productId forKey:@"commodity_id"];
    [par setValue:self.dataModel.productName forKey:@"commodity_name"];
    [par setValue:[self getPrice:self.dataModel.price] forKey:@"original_price"];
    [par setValue:[self getPrice:price] forKey:@"present_price"];
    [par setValue:@"天天商城" forKey:@"commodity_section_name"];
    [par setValue:[self getActivityName] forKey:@"activity_name"];
    [par setValue:self.dataModel.specialShowInfo.showId forKey:@"topic_id"];
    [par setValue:self.dataModel.shopInfo.shopId forKey:@"store_seller_id"];
    [par setValue:self.dataModel.shopInfo.shopName forKey:@"store_seller_name"];
    par[@"is_coupon_price"] = [self isShowQuanHouPrice] ? @YES : @NO;
    
    par[@"first_commodity"] = self.dataModel.firstCateName;
    par[@"second_commodity"] = self.dataModel.secondCateName;
    par[@"third_commodity"] = self.dataModel.thirdCateName;
    par[@"goods_type"] = [self.dataModel.productType isEqualToString:@"0"] ? @"一口价商品" : @"拍卖商品";

    par[@"is_special_goods"] = self.dataModel.existShow ? @YES : @NO;
    if (self.dataModel.existShow) {
        par[@"zc_id"] = zcid;
        par[@"zc_name"] = zcname;
        
//        NSString *showStr = @"新人";
//        switch (self.dataModel.specialShowInfo.showType.integerValue) {
//            case 0:
//            {
//                showStr = @"新人";
//            }
//                break;
//            case 1:
//            {
//                showStr = @"普通";
//            }
//                break;
//            case 2:
//            {
//                showStr = @"拍卖";
//            }
//                break;
//            case 3:
//            {
//                showStr = @"普通秒杀";
//            }
//                break;
//            case 4:
//            {
//                showStr = @"大促秒杀";
//            }
//                break;
//
//            default:
//                break;
//        }
        par[@"show_type"] = self.dataModel.specialShowInfo.showType;
    }
//    取接口数据，中文枚举值，如下:
//    0-新人，1-普通，2-拍卖，3-普通秒杀，4-大促秒杀"


    [JHAllStatistics jh_allStatisticsWithEventId:@"commodityPageView"
                                          params:par
                                            type:JHStatisticsTypeSensors];
}
/// 点击购买
- (void)reportBuy {
  
    NSString *price = self.dataModel.specialShowInfo.showPrice ? self.dataModel.specialShowInfo.showPrice : self.dataModel.price;
    
    NSMutableDictionary *par = [[NSMutableDictionary alloc] init];
    [par setValue:@"立即购买" forKey:@"button_name"];
    [par setValue:@"商品详情页" forKey:@"page_position"];
    [par setValue:self.dataModel.productId forKey:@"commodity_id"];
    [par setValue:self.dataModel.productName forKey:@"commodity_name"];
    [par setValue:[self getPrice:self.dataModel.price] forKey:@"original_price"];
    [par setValue:[self getPrice:price] forKey:@"present_price"];
    [par setValue:@"天天商城" forKey:@"commodity_section_name"];
    [par setValue:[self getActivityName] forKey:@"activity_name"];
    [par setValue:self.dataModel.specialShowInfo.showId forKey:@"topic_id"];
    [par setValue:self.dataModel.shopInfo.shopId forKey:@"store_seller_id"];
    [par setValue:self.dataModel.shopInfo.shopName forKey:@"store_seller_name"];
    
    par[@"post_coupon_price"] = [self getPrice:self.dataModel.discountPrice];
    par[@"goods_type"] = self.dataModel.thirdCateName;
    if ([self isShowQuanHouPrice]) {
        par[@"button_name"] =  @"领券购买";
    }
    [JHAllStatistics jh_allStatisticsWithEventId:@"buyButtonClick"
                                          params:par
                                            type:JHStatisticsTypeSensors];
}
/// 关注
- (void)reportShopFollowEvent {
    // 点击事件 应与 源状态相反
    NSString *type = self.focusStatus == true ? @"取消关注" : @"关注";
    NSDictionary *par = @{
        @"operation_type" : type,
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"storeOperate"
                                          params:par
                                            type:JHStatisticsTypeSensors];
    NSMutableDictionary *parDic = [self getBaseProductDetailStatistic];
    parDic[@"button_name"] = @"关注";
    parDic[@"is_focus"] = self.focusStatus ? @NO : @YES;
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickFocus" params:parDic type:JHStatisticsTypeSensors];
}
/// 用户教育
- (void)reportUserEducationEvent {
    NSDictionary *par = @{
        @"store_from" : @"商品详情页",
    };
    [JHAllStatistics jh_allStatisticsWithEventId:@"dbdhjyxxClick"
                                          params:par
                                            type:JHStatisticsTypeSensors];
}
- (NSString *)getShowId {
    NSString *zcid = self.dataModel.specialShowInfo.showId ? self.dataModel.specialShowInfo.showId : @"";
//    if ([self.dataModel.specialShowInfo.showType isEqualToString:@"0"]) {
//        return @"";
//    }
    return zcid;
    
}
- (NSString *)getShowName {
    NSString *zcname = self.dataModel.specialShowInfo.showName ? self.dataModel.specialShowInfo.showName : @"";
//    if ([self.dataModel.specialShowInfo.showType isEqualToString:@"0"]) {
//        return @"";
//    }
    return zcname;
}
- (NSString *)getActivityName {
    NSString *name = @"";
    if ([self.dataModel.specialShowInfo.showType isEqualToString:@"0"]) {
        name = @"新人专享";
    }
    return name;
}
- (NSNumber *)getPrice : (NSString *)price {
    NSNumber *num = [NSNumber numberWithString:price];
    return num;
}


- (NSMutableDictionary*)getBaseProductDetailStatistic{
    NSMutableDictionary *parDic = [NSMutableDictionary dictionaryWithCapacity:0];
    parDic[@"page_position"] = @"商城商品详情页";
    parDic[@"location_commodity_id"] = self.productId;
    parDic[@"original_price"] = [self getPrice: self.dataModel.price];
    parDic[@"post_coupon_price"] = [self getPrice: self.dataModel.discountPrice];
    parDic[@"location_goods_type"] = self.dataModel.thirdCateName;
    return parDic;
}

- (BOOL)isShowQuanHouPrice{
    BOOL show = NO;
    if (self.dataModel) {
        NSString *discountPrice =  self.dataModel.discountPrice;
        NSString *price =  self.dataModel.price;
        NSString *showPrice =  self.dataModel.specialShowInfo.showPrice;
        //专场
        if (discountPrice.length && self.dataModel.existShow && ![discountPrice isEqualToString:showPrice]) {
            show = YES;
        }else if(discountPrice.length && !self.dataModel.existShow && ![discountPrice isEqualToString:price]){
            show = YES;
        }
    }
    return show;
}

- (BOOL)isAuctionProduct{
    BOOL auc = NO;
    if ([self.dataModel.productType isEqualToString:@"1"]) {
        auc = YES;
    }
    return auc;
}
@end

