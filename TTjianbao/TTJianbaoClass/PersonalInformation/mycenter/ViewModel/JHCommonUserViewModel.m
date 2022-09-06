//
//  JHCommomUserViewModel.m
//  TTjianbao
//
//  Created by lihui on 2020/4/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCommonUserViewModel.h"
#import "BannerMode.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "JHMySectionModel.h"
#import "JHPurchaseStoneModel.h"
#import "JHStoreApiManager.h"
#import "JHShopWindowLayout.h"
#import "User.h"
#import "JHMyUserInfoDraftHeader.h"
#import "UserInfoRequestManager.h"
#import "JHUserInfoApiManager.h"

#define fiveCellCount 5
#define fourCellCount 4

static CGFloat const kCellHeight = 81.f;

@interface JHCommonUserViewModel ()

@property (nonatomic, assign) NSInteger page;  //分页

@end


@implementation JHCommonUserViewModel


- (instancetype)init {
    self = [super init];
     if (self) {
        ///轮播图数据
        [self requestBanners];
    }
    return self;
}

///获取签约的url
- (void)loadSignPageUrlCompeleteBlock:(void(^)(NSString *url))block {
    [SVProgressHUD show];
    NSString *url = COMMUNITY_FILE_BASE_STRING(@"/v1/contract/sign");
    [HttpRequestTool postWithURL:url Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        NSLog(@"请求成功:%@", respondObject.data);
        ///跳转签约界面
        NSString *urlString = respondObject.data[@"url"];
        if (block) {
            block(urlString);
        }
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        NSLog(@"请求失败:%@ - %zd", respondObject.message, respondObject.code);
        NSString *message = respondObject.message;
        [UITipView showTipStr:message ? message : @"跳转失败"];
        if (block) {
            block(nil);
        }
    }];
}
///获取banner的数据
- (void)requestBannersWithBlock:(void(^)(void))block {
    NSString *string = COMMUNITY_FILE_BASE_STRING(@"/ad/4");
    NSLog(@"string::%@",string);
    @weakify(self);
    [HttpRequestTool getWithURL:string Parameters:nil successBlock:^(RequestModel *respondObject) {
        @strongify(self);
        self.bannerModes = [NSMutableArray array];
        self.bannerModes = [BannerCustomerModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        NSLog(@"bannerModes:---- %@", self.bannerModes);
        if (block) {
            block();
        }
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
    }];
}
///轮播图数据
- (void)requestBanners {
    NSString *string = COMMUNITY_FILE_BASE_STRING(@"/ad/4");
    NSLog(@"string::%@",string);
    @weakify(self);
    [HttpRequestTool getWithURL:string Parameters:nil successBlock:^(RequestModel *respondObject) {
        @strongify(self);
        self.bannerModes = [NSMutableArray array];
        self.bannerModes = [BannerCustomerModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        NSLog(@"bannerModes:---- %@", self.bannerModes);
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
    }];
}

- (void)loadPersonCenterDataWithBlock:(void(^)(void))block {
    self.sectionArray = [NSMutableArray arrayWithArray:[self configSectionData]];
    self.dataArray = [NSMutableArray arrayWithArray:[self configCellData]];
    if (block) {
        block();
    }
}

///section
- (NSArray *)configSectionData {
   // User *user = [UserInfoRequestManager sharedInstance].user;
   // JHUserTypeRole type = user.type;

    ///分区间隔10
    ///头部
    JHMySectionModel *headerMode = [[JHMySectionModel alloc] init];
    headerMode.title = @"";
    headerMode.columnCount = 1;
    headerMode.sectionType = JHMySectionTypeHeader;
    headerMode.cellSize = CGSizeMake(ScreenW, 0);
    headerMode.headerHeight = 0.f;
    headerMode.footerHeight = 10.f;

    ///店铺
    JHMySectionModel *shopMode = [[JHMySectionModel alloc] init];
    shopMode.title = @"";
    shopMode.columnCount = 1;
    shopMode.sectionType = JHMySectionTypeShop;
    shopMode.cellSize = CGSizeMake(ScreenW, 54);
    shopMode.headerHeight = 0.f;
    shopMode.footerHeight = 10.f;

    ///我的交易
    JHMySectionModel *orderMode = [[JHMySectionModel alloc] init];
    orderMode.title = @"我的交易";
    orderMode.columnCount = 5;
    orderMode.sectionType = JHMySectionTypeOrder;
    orderMode.cellSize = CGSizeMake(((ScreenW - 24))/5, kCellHeight-8-8);
    orderMode.headerHeight = 44.f;
    orderMode.footerHeight = 20.f;

    // 我的回收
//    JHMySectionModel *recycleMode = [[JHMySectionModel alloc] init];
//    recycleMode.title = JHLocalizedString(@"myRecycle");///@"我的回收";
//    recycleMode.columnCount = 5;
//    recycleMode.sectionType = JHMySectionTypeWallet;
//    recycleMode.cellSize = CGSizeMake(((ScreenW - 20))/recycleMode.columnCount, 80);
//    recycleMode.headerHeight = 30.f;
//    recycleMode.footerHeight = 20.f;
    
    ///轮播图
    JHMySectionModel *cycleMode = [[JHMySectionModel alloc] init];
    cycleMode.title = @"";
    cycleMode.columnCount = 1;
    cycleMode.sectionType = JHMySectionTypeCycle;
    cycleMode.cellSize = CGSizeMake(ScreenW - 20, (ScreenW - 20)*144/702); // CGSizeMake(ScreenW, 70*(ScreenW-24)/355);
    cycleMode.headerHeight = 0.f;
    cycleMode.footerHeight = 10.f;

    ///钱包
    JHMySectionModel *walletMode = [[JHMySectionModel alloc] init];
    walletMode.title = JHLocalizedString(@"myWallet");///@"我的钱包";
    walletMode.columnCount = 5;
    walletMode.sectionType = JHMySectionTypeWallet;
    walletMode.cellSize = CGSizeMake(((ScreenW - 24))/walletMode.columnCount, kCellHeight-20);
    walletMode.headerHeight = 44.f;
    walletMode.footerHeight = 20.f;
    
    ///创作中心
    JHMySectionModel *community = [[JHMySectionModel alloc] init];
    community.title = @"创作中心";
    community.columnCount = 4;
    community.sectionType = JHMySectionTypeCommunity;
//    community.cellSize = CGSizeMake(((ScreenW - 24))/4, kCellHeight);
//    community.headerHeight = 44.f;
//    community.footerHeight = 20.f;
    community.cellSize = CGSizeMake(((ScreenW - 24))/4, 0);
    community.headerHeight = 0;
    community.footerHeight = 0;
#pragma todo - 将原石回血做成弹框的格式
    ///原石回血
//    JHMySectionModel *resaleMode = [[JHMySectionModel alloc] init];
//    resaleMode.title = JHLocalizedString(@"stoneResale");///@"原石回血";
////    resaleMode.columnCount = (type == 7||type == 8)?4:5;
//    resaleMode.columnCount = 4;/// 宝慧确认统一 4
//    resaleMode.sectionType = JHMySectionTypeResale;
//    resaleMode.cellSize = CGSizeMake(floorl(((ScreenW - 20))/resaleMode.columnCount), 80);
//    resaleMode.headerHeight = 30.f;
//    resaleMode.footerHeight = 18.f;

    ///我的工具
    JHMySectionModel *toolMode = [[JHMySectionModel alloc] init];
    toolMode.title = JHLocalizedString(@"myTools");///@"我的工具";
    toolMode.columnCount = 5;
    toolMode.sectionType = JHMySectionTypeTools;
    ///宽度cell自身高度 - 下边footer的高度
    toolMode.cellSize = CGSizeMake(((ScreenW - 24))/5, 75.-8.);
    toolMode.headerHeight = 44.f;
    toolMode.footerHeight = 20.f;

    JHMySectionModel *recommendMode = [[JHMySectionModel alloc] init];
    recommendMode.title = JHLocalizedString(@"toRecommend");///@"为您推荐";
    recommendMode.columnCount = 2;
    recommendMode.sectionType = JHMySectionTypeRecommend;
    recommendMode.cellSize = CGSizeMake((ScreenW - 25)/2, 0);
    recommendMode.headerHeight = 0;
    recommendMode.footerHeight = 10.f;
    
    ///普通用户 头部 订单 回收 轮播 钱包 回血 工具 recycleMode
    return @[headerMode, orderMode, cycleMode, walletMode, community, toolMode, recommendMode];
}

- (NSArray *)resaleDataSource {
    ///原石回血 普通用户和未登录显示该模块 其他不显示
    NSMutableArray *resale = [NSMutableArray array];
    {
        JHMyCellModel *model2 = [[JHMyCellModel alloc] init];
        model2.title = JHLocalizedString(@"personBid"); ///有人出价
        model2.iconName = @"icon_person_stone_otherPrice";
        model2.isShowPoint = YES;
        model2.redMessageType = JHMyCenterRedPointOtherBid;
        model2.countString = @"";
        
        model2.vcName = @"JHUserCenterResaleViewController";
        model2.params = @{@"selectedIndex":@(0)};
        [resale addObject:model2];

        JHMyCellModel *model3 = [[JHMyCellModel alloc] init];
        model3.title = JHLocalizedString(@"sendSaleStone");//@"寄售原石";
        model3.iconName = @"icon_person_stone_resale";
        model3.isShowPoint = NO;
        model3.countString = @"";
        model3.vcName = @"JHUserCenterResaleViewController";
        model3.params = @{@"selectedIndex":@(1)};
        [resale addObject:model3];

        JHMyCellModel *model5 = [[JHMyCellModel alloc] init];
        model5.title = JHLocalizedString(@"myBid");//@"我的出价";
        model5.iconName = @"icon_person_my_price";
        model5.params = @{};
        model5.isShowPoint = NO;
        model5.redMessageType = JHMyCenterRedPointMyBid;
        model5.vcName = @"JHMyPriceViewController";
        [resale addObject:model5];

        JHMyCellModel *model4 = [[JHMyCellModel alloc] init];
        model4.title = JHLocalizedString(@"buyInStone"); //@"买入原石";
        model4.iconName = @"icon_person_stone_saled";
        model4.params = @{@"pageType":@(JHStonePageTypePurchase)};
        model4.isShowPoint = NO;
        model4.countString = @"";
        model4.vcName = @"JHPurchaseStoneViewController";
        [resale addObject:model4];

        JHMyCellModel *model6 = [[JHMyCellModel alloc] init];
        model6.title = JHLocalizedString(@"personalTransSale");//@"个人转售";
        model6.iconName = @"icon_person_resell";
        model6.params = @{};
        model6.isShowPoint = YES;
        model6.redMessageType = JHMyCenterRedPointPersonalTransSale;
        model6.countString = @"";
        model6.vcName = @"JHPersonalResellViewController";
        [resale addObject:model6];
    }
    return resale;
}

///cell

- (NSArray *)configCellData {
    User *user = [UserInfoRequestManager sharedInstance].user;
    ///1. 我的订单
    NSMutableArray *dingdan = [NSMutableArray array];
    {
       
        JHMyCellModel *model1 = [[JHMyCellModel alloc] init];
        model1.title = JHLocalizedString(@"waitPay");///@"待付款";
        model1.iconName = @"person_wait_pay_icon";
        model1.countString = @"";
        model1.redMessageType = JHMyCenterRedPointWillPay;
        model1.isShowPoint = user.hasWaitPay;
        model1.vcName = @"JHNewOrderListViewController";
        model1.params = @{@"currentIndex":@(1)};
        model1.isUpdateIconSize = YES;
        model1.isShowRedDot = YES;
        model1.growingClickString = JHTrackUserSeller_center_waitorder_click;
        [dingdan addObject:model1];
        
        JHMyCellModel *model2 = [[JHMyCellModel alloc] init];
        model2.title = JHLocalizedString(@"waitRecieve");///@"待收货";
        model2.iconName = @"person_wait_recv_icon";
        model2.countString = @"";
        model2.isShowPoint = NO;
        model2.redMessageType = JHMyCenterRedPointWillReceive;
        model2.vcName = @"JHNewOrderListViewController";
        model2.params = @{@"currentIndex":@(2)};
        model2.isUpdateIconSize = YES;
        model2.isShowRedDot = YES;
        model2.growingClickString = JHTrackUserSeller_center_receiveorder_click;
        [dingdan addObject:model2];
        
        JHMyCellModel *model3 = [[JHMyCellModel alloc] init];
        model3.title = JHLocalizedString(@"waitComment");///@"待评价";
        model3.iconName = @"person_wait_comment_icon";
        model3.countString = @"";
        model3.params = @{@"currentIndex":@(3)};
        model3.isShowPoint = NO;
        model3.redMessageType = JHMyCenterRedPointWillComment;
        model3.vcName = @"JHNewOrderListViewController";
        model3.isUpdateIconSize = YES;
        model3.isShowRedDot = YES;
        model3.growingClickString = JHTrackUserSeller_center_evaluateorder_click;
        [dingdan addObject:model3];
        
        JHMyCellModel *model4 = [[JHMyCellModel alloc] init];
        model4.title = JHLocalizedString(@"afterSale");///@"退款售后";
        model4.iconName = @"person_wait_appraise_icon";
        model4.countString = @"";
        model4.isShowPoint = NO;
        model4.redMessageType = JHMyCenterRedPointAfterSale;
        model4.vcName = @"JHNewOrderListViewController";
        model4.params = @{@"currentIndex":@(4)};
        model4.isUpdateIconSize = YES;
        model4.isShowRedDot = NO;
        model4.growingClickString = JHTrackUserSeller_center_refund_click;
        [dingdan addObject:model4];
        
        JHMyCellModel *model5 = [[JHMyCellModel alloc] init];
        model5.title = JHLocalizedString(@"myOrder");///@"我的订单";
        model5.iconName = @"person_my_pay_icon";
        model5.isShowPoint = NO;
        model5.isShowRightLine = YES;
        model5.countString = @"";
        model5.vcName = @"JHNewOrderListViewController";
        model5.params = @{@"currentIndex":@(0)};
        model5.isUpdateIconSize = YES;
        model5.isShowRedDot = NO;
        model5.growingClickString = JHTrackUserSeller_center_allorder_click;
        [dingdan addObject:model5];
        
        ///回收订单
        JHMyCellModel *model6 = [[JHMyCellModel alloc] init];
        model6.title = @"回收订单";
        model6.iconName = @"icon_mycenter_recycle";
        model6.countString = @"";
        model6.params = @{@"defaultIndex" : @(0)};
        model6.isShowPoint = NO;
        model6.redMessageType = JHMyCenterMerchantRecycleMySoldCount;
        model6.vcName = @"JHRecycleOrderPageController";
        model6.isUpdateIconSize = YES;
        model6.isShowRedDot = YES;
        model6.growingClickString = JHTrackUserSeller_center_evaluateorder_click;
        [dingdan addObject:model6];
        
        ///集市订单
        JHMyCellModel *model7 = [[JHMyCellModel alloc] init];
        model7.title = @"集市订单";
        model7.iconName = @"icon_mycenter_market";
        model7.countString = @"";
        model6.params = @{};
        model7.isShowPoint = NO;
        model7.redMessageType = JHMyCenterRedPointWillComment;
//        model7.vcName = @"JHNewOrderListViewController";
        model7.vcName = @"JHMarketOrderListViewController";
        model7.isUpdateIconSize = YES;
        model7.isShowRedDot = YES;
        model7.growingClickString = JHTrackUserSeller_center_evaluateorder_click;
        [dingdan addObject:model7];
        
        ///鉴定订单
        JHMyCellModel *model8 = [[JHMyCellModel alloc] init];
        model8.title = @"鉴定订单";
        model8.iconName = @"icon_mycenter_appraise";
        model8.countString = @"";
        model6.params = @{};
        model8.isShowPoint = NO;
        model8.redMessageType = JHMyCenterRedPointWillComment;
        model8.vcName = @"JHGraphicalSubListViewController";
        model8.isUpdateIconSize = YES;
        model8.isShowRedDot = YES;
        model8.growingClickString = JHTrackUserSeller_center_evaluateorder_click;
        [dingdan addObject:model8];

        NSInteger chaCount = fiveCellCount-dingdan.count%fiveCellCount;
        if (chaCount < fiveCellCount) {
            for (int i = 0; i<chaCount; i++) {
                JHMyCellModel *model9 = [[JHMyCellModel alloc] init];
                model9.title = @"";
                model9.iconName = @"";
                model9.countString = @"";
                model9.isShowPoint = NO;
                model9.isUpdateIconSize = YES;
                model9.isShowRedDot = NO;
                [dingdan addObject:model9];
            }
        }
    }
/*
    ///我的回收
    NSMutableArray *recycles = [NSMutableArray array];
    {
        JHMyCellModel *model1 = [[JHMyCellModel alloc] init];
        model1.title = JHLocalizedString(@"myPublish"); // "我发布的";
        model1.iconName = @"center_my_publish";
        model1.redMessageType = JHMyCenterMerchantRecycleMyPublishCount;
        model1.isShowRedDot = NO;
//        model1.countString = @"1";
        model1.vcName = @"JHRecyclePublishedViewController";
        model1.params = @{};
        [recycles addObject:model1];

        JHMyCellModel *model2 = [[JHMyCellModel alloc] init];
        model2.title = JHLocalizedString(@"mySale"); // "我卖出的";
        model2.iconName = @"center_my_sale";
        model2.redMessageType = JHMyCenterMerchantRecycleMySoldCount;
//        model2.redMessageType = JHMyCenterRedPointRecycleSoldOut;
//        model2.countString = @"2";
        model2.isShowPoint = NO;
        model2.vcName = @"JHRecycleSoldOutViewController";
        model2.params = @{};
        [recycles addObject:model2];
        
        NSInteger patchCount = fiveCellCount-recycles.count%fiveCellCount;
        if (patchCount < fiveCellCount) {
            for (int i = 0; i<patchCount; i++) {
                JHMyCellModel *model = [[JHMyCellModel alloc] init];
                model.title = @"";
                model.iconName = @"";
                model.countString = @"";
                model.isShowPoint = NO;
                [recycles addObject:model];
            }
        }
    }
 */

    ///我的钱包
    NSMutableArray *qianbao = [NSMutableArray array];
    {
        JHMyCellModel *model1 = [[JHMyCellModel alloc] init];
        model1.title = JHLocalizedString(@"subsidy");
        model1.iconName = @"icon_person_subsidy";
        model1.countString = user.bountyBalance?:@"0";
        model1.isShowPoint = NO;
        model1.vcName = @"JHAllowanceViewController";
        model1.params = @{@"isNative":@(YES)};
        [qianbao addObject:model1];

        JHMyCellModel *model2 = [[JHMyCellModel alloc] init];
        model2.title = JHLocalizedString(@"redbag"); ///红包
        model2.iconName = @"icon_person_red_pocket";
        model2.countString = user.enCouponCount?:@"0";
        model2.isShowPoint = NO;
        model2.vcName = @"JHMyCouponViewController";
        model2.params = @{};
        [qianbao addObject:model2];
     
        JHMyCellModel *model3 = [[JHMyCellModel alloc] init];
        model3.title = JHLocalizedString(@"coupon");//代金券
        model3.iconName = @"icon_person_coupon";
        model3.countString = user.enVoucherCount?:@"0";
        model3.isShowPoint = NO;
        model3.vcName = @"JHMallCouponViewController";
        model3.params = @{};
        [qianbao addObject:model3];
     
        JHMyCellModel *model4 = [[JHMyCellModel alloc] init];
        model4.title = JHLocalizedString(@"bean");
        model4.iconName = @"icon_person_bean";
        model4.countString = user.balance?:@"0";
        model4.isShowPoint = NO;
        model4.vcName = @"JHMyBeanViewController";
        [qianbao addObject:model4];
        
        NSInteger chaCount = fourCellCount-qianbao.count%fourCellCount;
        if (chaCount < fourCellCount) {
            for (int i = 0; i<chaCount; i++) {
                JHMyCellModel *model5 = [[JHMyCellModel alloc] init];
                model5.title = @"";
                model5.iconName = @"";
                model5.countString = @"0";
                model5.isShowPoint = NO;
                [qianbao addObject:model5];
            }
        }
        
        // 原石零钱
        JHMyCellModel *model6 = [[JHMyCellModel alloc] init];
        model6.title = JHLocalizedString(@"pocket");//@"原石零钱";
        model6.iconName = @"icon_person_amount";
        model6.isShowPoint = NO;
        model6.countString = [UserInfoRequestManager sharedInstance].user.smallChange?:@"0";
        model6.vcName = @"JHStonePinMoneyViewController";
        model6.params = @{};
        [qianbao addObject:model6];
    }
    
    ///我的创作中心
    NSMutableArray *community = [NSMutableArray array];
    {
        NSString *commentNum = @"";
        NSString *publishNum = @"";
        NSString *likeNum = @"";
        NSString *draftNum = @"";
        if([JHRootController isLogin]) {
            JHUserLevelInfoMode *obj = [UserInfoRequestManager sharedInstance].levelModel;
            commentNum = OBJ_TO_STRING(@(obj.comment_num));
            publishNum = OBJ_TO_STRING(@(obj.publish_num));
            likeNum = OBJ_TO_STRING(@(obj.like_content_num));
            draftNum = OBJ_TO_STRING(@([JHMyUserInfoDraftHeader draftCount]));
        }

        JHMyCellModel *model1 = [[JHMyCellModel alloc] init];
        model1.title = @"评过";
        model1.iconName = @"my_center_comment";
        model1.countString = commentNum;
        model1.isShowPoint = NO;
        model1.vcName = @"JHUserInfoViewController";
        model1.params = @{@"index":@"1", @"userId" : user.customerId};
        [community addObject:model1];

        JHMyCellModel *model2 = [[JHMyCellModel alloc] init];
        model2.title = @"发过";
        model2.iconName = @"my_center_write";
        model2.countString = publishNum;
        model2.isShowPoint = NO;
        model2.vcName = @"JHUserInfoViewController";
        model2.params = @{@"index":@"2", @"userId" : user.customerId};
        [community addObject:model2];

        JHMyCellModel *model3 = [[JHMyCellModel alloc] init];
        model3.title = @"赞过";
        model3.iconName = @"my_center_praise";
        model3.countString = likeNum;
        model3.isShowPoint = NO;
        model3.vcName = @"JHUserInfoViewController";
        model3.params = @{@"index":@"3", @"userId" : user.customerId};
        [community addObject:model3];



        NSInteger chaCount = fourCellCount-community.count%fourCellCount;
        if (chaCount < fourCellCount) {
            for (int i = 0; i<chaCount; i++) {
                JHMyCellModel *model5 = [[JHMyCellModel alloc] init];
                model5.title = @"";
                model5.iconName = @"";
                model5.countString = @"";
                model5.isShowPoint = NO;
                [community addObject:model5];
            }
        }
    }
        
    ///我的工具
    NSMutableArray *tools = [NSMutableArray array];
    {
        
        JHMyCellModel *model00 = [[JHMyCellModel alloc] init];
        model00.title = @"优惠兑换";
        model00.iconName = @"my_center_appraiser_00";
        model00.isShowPoint = NO;
        model00.countString = @"";
        model00.vcName = @"JHWebViewController";
        NSString *model00Title = @"优惠兑换";
        model00.params = @{@"titleString":model00Title,@"urlString":H5_BASE_STRING(@"/jianhuo/app/conversionCode/conversionCode.html")};
        [tools addObject:model00];
        
        JHMyCellModel *model0 = [[JHMyCellModel alloc] init];
        model0.title = JHLocalizedString(@"myCompete");
        model0.iconName = @"icon_person_compete";
        model0.isShowPoint = NO;
        model0.countString = @"";
        model0.vcName = @"JHMyCompeteViewController";
        model0.params = @{};//@{@"titleString":model0Title,@"urlString":ShowUserWishPaperURL(1,1,0)};
        [tools addObject:model0];
        
        JHMyCellModel *model1 = [[JHMyCellModel alloc] init];
        model1.title = JHLocalizedString(@"wishList");
        model1.iconName = @"icon_person_wish";
        model1.isShowPoint = NO;
        model1.countString = @"";
        model1.vcName = @"JHWebViewController";
        NSString *model1Title = JHLocalizedString(@"myWishList");
        model1.params = @{@"titleString":model1Title,@"urlString":ShowUserWishPaperURL(1,1,0)};
        [tools addObject:model1];
        
        JHMyCellModel *model2 = [[JHMyCellModel alloc] init];
        NSString *model2Title = JHLocalizedString(@"scoreExchange");
        model2.title = model2Title;
        model2.iconName = @"icon_person_score_exchange";
        model2.isShowPoint = NO;
        model2.countString = @"";
        model2.vcName = @"JHWebViewController";
        model2.params = @{@"titleString":model2Title,@"urlString":H5_BASE_STRING(@"/jianhuo/app/myIntegral.html")};
        [tools addObject:model2];
        
        JHMyCellModel *model3 = [[JHMyCellModel alloc] init];
        model3.title = JHLocalizedString(@"appraiseHistory");
        model3.iconName = @"icon_person_record_appraise";
        model3.isShowPoint = NO;
        model3.countString = @"";
        model3.vcName = @"JHLiveRecordViewController";
        model3.params = @{@"roleType":@(0)};
        [tools addObject:model3];

        NSString *title = JHLocalizedString(@"collectRiskAssess");
        JHMyCellModel *model4 = [[JHMyCellModel alloc] init];
        model4.title = title;
        model4.iconName = @"icon_person_risk";
        model4.isShowPoint = NO;
        model4.countString = @"";
        model4.vcName = @"JHWebViewController";
        model4.params = @{@"titleString":title,@"urlString":H5_BASE_STRING(@"/jianhuo/app/riskTtest.html")};
        [tools addObject:model4];

        JHMyCellModel *model5 = [[JHMyCellModel alloc] init];
        model5.title = JHLocalizedString(@"collect");
        model5.iconName = @"icon_person_collection";
        model5.isShowPoint = NO;
        model5.countString = @"";
        model5.vcName = @"JHSQCollectViewController";
        model5.params =  @{};
        [tools addObject:model5];
        
        JHMyCellModel *model6 = [[JHMyCellModel alloc] init];
        model6.title = @"在线客服";//联系客服
        model6.iconName = @"icon_person_chat";
//偷偷干掉了
//        if ( [JHQYChatManage unreadMessage]>0) {
//            model6.isShowPoint = YES;
//        }else {
//            model6.isShowPoint = NO;
//        }
        model6.isShowPoint = NO;
        model6.countString = @"";
        model6.vcName = @"";
        model6.params = @{};
        [tools addObject:model6];
        
        JHMyCellModel *model61 = [[JHMyCellModel alloc] init];
        model61.title = @"电话客服";
        model61.iconName = @"icon_person_phone";
        model61.isShowPoint = NO;
        model61.countString = @"";
        model61.vcName = @"";
        model61.params = @{};
        [tools addObject:model61];
        
        JHMyCellModel *model7 = [[JHMyCellModel alloc] init];
        model7.title = JHLocalizedString(@"helpCenter"); //帮助中心
        model7.iconName = @"icon_person_help";
        model7.isShowPoint = NO;
        model7.countString = @"";
        model7.vcName = @"JHWebViewController";
        model7.params = @{@"titleString":JHLocalizedString(@"helpCenter"),@"urlString":H5_BASE_STRING(@"/jianhuo/help.html")};
        [tools addObject:model7];
        
        JHMyCellModel *model8 = [[JHMyCellModel alloc] init];
        model8.title = JHLocalizedString(@"stoneResale"); //原石回血
        model8.iconName = @"center_stone_resale";
        model8.isShowPoint = NO;
        model8.countString = @"";
        model8.vcName = @"";
        model8.params = @{};
        [tools addObject:model8];
        
//        NSString *draftNum = @"";
//        if([JHRootController isLogin]) {
//            draftNum = OBJ_TO_STRING(@([JHMyUserInfoDraftHeader draftCount]));
//        }
        JHMyCellModel *model9 = [[JHMyCellModel alloc] init];
        model9.title = @"草稿箱";
        model9.iconName = @"my_center_draft";
        model9.countString = @"";
        model9.isShowPoint = NO;
        model9.vcName = @"JHDraftBoxController";
        [tools addObject:model9];
        
        NSInteger chaCount = fiveCellCount - tools.count%fiveCellCount;
        if (chaCount < fiveCellCount) {
            for (int i = 0; i<chaCount; i++) {
                JHMyCellModel *model5 = [[JHMyCellModel alloc] init];
                model5.title = @"";
                model5.iconName = @"";
                model5.countString = @"";
                model5.isShowPoint = NO;
                [tools addObject:model5];
            }
        }
    }
    
    ///普通用户 头部 订单 轮播 钱包 工具  recycles
    return @[@[], dingdan, @[], qianbao, community, tools];
}

#pragma mark -
#pragma mark -  为您推荐数据相关

- (void)loadRecommendData:(BOOL)isRefresh completeBlock:(void(^)(BOOL hasData, BOOL hasError))block {
    ///1订单列表 2订单详情 3个人中心 4商品详情
    self.page = !isRefresh ? self.page+1 : 1;

    @weakify(self);
    NSDictionary *dic = @{@"page" : @(self.page),
                          @"from" : @3
    };
    [JHStoreApiManager getRecommendListWithParams:dic block:^(id  _Nullable respObj, BOOL hasError) {
        @strongify(self);
        if (!hasError) {
            RequestModel *respondObject = (RequestModel *)respObj;
            ///橱窗列表
            NSArray *tempArray = [JHGoodsInfoMode mj_objectArrayWithKeyValuesArray:respondObject.data];
            ///过滤过期/失效的数据
            NSMutableArray *layoutArr = [NSMutableArray new];
            [tempArray enumerateObjectsUsingBlock:^(JHGoodsInfoMode * _Nonnull goodsInfo, NSUInteger idx, BOOL * _Nonnull stop) {
                JHShopWindowLayout *layout = [[JHShopWindowLayout alloc] initWithModel:goodsInfo];
                [layoutArr addObject:layout];
            }];
            if (isRefresh) { ///刷新数据
                self.recommendArray = [NSMutableArray arrayWithArray:layoutArr];
            }
            else {  //加载更多
                [self.recommendArray addObjectsFromArray:layoutArr];
            }
            
            BOOL hasData = YES;
            NSArray *data = respondObject.data;
            if (!data && data.count == 0) {
                hasData = NO;
            }
            else {
                hasData = YES;
            }
            if (block) {
                block(hasData, hasError);
            }
        }
    }];
}

#pragma mark -
#pragma mark - 网络请求判断用户是否为特卖商家
- (void)requestUserSellerInfo:(HTTPCompleteBlock)block {
    NSString *url = COMMUNITY_FILE_BASE_STRING(@"/v1/shop/bus_store");
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        NSNumber *sellerId = respondObject.data[@"seller_id"];
        if (block) {
            block(respondObject, NO);
        }
    } failureBlock:^(RequestModel *respondObject) {
        NSLog(@"不是特卖商家 or 网络请求失败");
        if (block) {
            block(respondObject, YES);
        }
    }];
}

@end

