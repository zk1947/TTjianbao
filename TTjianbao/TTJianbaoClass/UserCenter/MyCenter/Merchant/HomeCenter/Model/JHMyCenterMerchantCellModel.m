//
//  JHMyCenterMerchantCellModel.m
//  TTjianbao
//
//  Created by apple on 2020/4/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "JHWebViewController.h"
#import "JHCommonUserViewModel.h"

#import "JHSelectMerchantViewController.h"
#import "JHSignViewController.h"
#import "JHMyCenterMerchantCellModel.h"

#import "UserInfoRequestManager.h"

#import "JHUnionSignView.h"
#import "JHSQManager.h"
#import "JHBusinessFansSettingBusiness.h"


@implementation JHMyCenterMerchantCellModel

-(NSMutableArray<JHMyCenterMerchantCellButtonModel *> *)buttonArray{
    if(!_buttonArray){
        _buttonArray = [NSMutableArray new];
    }
    return _buttonArray;
}

@end

@interface JHMyCenterMerchantCellButtonModel ()

@property (nonatomic, strong) JHCommonUserViewModel *userViewModel;

@end

@implementation JHMyCenterMerchantCellButtonModel


+ (JHMyCenterMerchantCellButtonModel *)creatWithMessageCount:(NSInteger)messageCount icon:(NSString *)icon title:(NSString *)title type:(JHMyCenterMerchantPushType)type {
    ///默认全部
    JHMyCenterMerchantCellButtonModel * model = [JHMyCenterMerchantCellButtonModel creatWithMessageCount:messageCount icon:icon title:title type:type contentType:JHMyCenterContentTypeAll];
    return model;
}

+ (JHMyCenterMerchantCellButtonModel *)creatWithMessageCount:(NSInteger)messageCount icon:(NSString *)icon title:(NSString *)title type:(JHMyCenterMerchantPushType)type contentType:(JHMyCenterContentType)contentType {
    JHMyCenterMerchantCellButtonModel *model = [JHMyCenterMerchantCellButtonModel new];
    model.messageCount = messageCount;
    model.icon = icon;
    model.title = title;
    model.cellType = type;
    model.contentType = contentType;
    return model;
}

- (NSString *)getContentType {
    switch (self.contentType) {
        case JHMyCenterContentTypeLiving:
            return @"1";
            break;
        case JHMyCenterContentTypeStore:
            return @"2";
            break;
        default:
            return @"0";
            break;
    }
}

-(void)pushViewController
{
    User *user = [UserInfoRequestManager sharedInstance].user;   
    JHUnionSignStatus status = [UserInfoRequestManager sharedInstance].unionSignStatus;
    
    if ([JHSQManager needAutoEnterMerchantVC]) {
        [self enterMerchantVC];
        return;
    }
    
//    BOOL selectType = (self.cellType == JHMyCenterMerchantPushTypeReSaleWallet);
//    if((status != JHUnionSignStatusComplete && status != JHUnionSignStatusReviewing) && selectType && (!user.isAssistant))
//    {
//        if (status == JHUnionSignStatusSigning) {
//            [self enterUnionSignPage];
//            return;
//        }
//        [JHUnionSignAlertView creatUnionSignAlertViewWithStatus:status];
//        return;
//    }所有角色原始零钱去掉
    
    JHRouterModel* router = [JHRouterModel new];
    NSString *type = [self getContentType];
    BOOL fansClub = NO;
    switch (self.cellType) {
        
        case JHMyCenterMerchantPushTypeOrderWillPay:
        {/// 待付款
            router.vc = @"JHOrderListViewController";
            router.type = @(JHRouterTypeParams).stringValue;
            router.params = @{@"isSeller" : @YES,@"currentIndex":@"1", @"bussId":type};
        }
        break;
            
        case JHMyCenterMerchantPushTypeOrderWillSendGoods:
        {/// 待发货
        
            router.vc = @"JHOrderListViewController";
            router.type = @(JHRouterTypeParams).stringValue;
            router.params = @{@"isSeller" : @YES,@"currentIndex":@"2", @"bussId":type};
            
        }
        break;
            
        case JHMyCenterMerchantPushTypeOrderDidSentGoods:
        {/// 已发货
        
            router.vc = @"JHOrderListViewController";
            router.type = @(JHRouterTypeParams).stringValue;
            router.params = @{@"isSeller" : @YES,@"currentIndex":@"3", @"bussId":type};
        }
        break;
            
        case JHMyCenterMerchantPushTypeOrderAfterSale:
        {/// 售后
            router.vc = @"JHOrderListViewController";
            router.type = @(JHRouterTypeParams).stringValue;
            router.params = @{@"isSeller" : @YES,@"currentIndex":@"5", @"bussId":type};
        }
        break;
            
        case JHMyCenterMerchantPushTypeReSaleWillSale:
        {/// 待上架
            router.vc = @"JHMainLiveRoomWillSalePageViewController";
        }
        break;
                
        case JHMyCenterMerchantPushTypeReSaleDidSale:
        {
       /// 最近出售
            router.vc = @"JHLastSaleStoneViewViewController";
        }
        break;
                
        case JHMyCenterMerchantPushTypeReSaleSendSale:
        {
        /// 寄售
            router.vc = @"JHMainLiveRoomOnSalePageViewController";
        }
        break;
            
        case JHMyCenterMerchantPushTypeReSaleWallet:
        {
       /// 零钱
            router.vc = @"JHBillTotalViewController";
        }
        break;
            
        case JHMyCenterMerchantPushTypeReSaleReturn:
        {
        /// 寄回
        
            router.vc = @"JHPurchaseStoneViewController";
            router.type = @(JHRouterTypeParams).stringValue;
            router.params = @{@"pageType":@2};
            
        }
        break;
            
        case JHMyCenterMerchantPushTypeReSaleOrder:
        {
        /// 原石订单
            router.vc = @"JHPurchaseStoneViewController";
            router.type = @(JHRouterTypeParams).stringValue;
            router.params = @{@"pageType":@1};
        }
        break;
        ///回收相关  全部为h5页面
        case JHMyCenterMerchantPushTypeRecyleWillPay:
        {
            ///待付款
            router.vc = @"JHWebViewController";
            router.type = @(JHRouterTypeParams).stringValue;
            router.params = @{@"urlString" : MerchantRecyleDetailURL(@"1", type)};
        }
            break;
        case JHMyCenterMerchantPushTypeRecyleWillSend:
        {
            ///待发货
            router.vc = @"JHWebViewController";
            router.type = @(JHRouterTypeParams).stringValue;
            router.params = @{@"urlString" : MerchantRecyleDetailURL(@"2", type)};
        }
            break;
        case JHMyCenterMerchantPushTypeRecyleDidSend:
        {
            ///待收货
            router.vc = @"JHWebViewController";
            router.type = @(JHRouterTypeParams).stringValue;
            router.params = @{@"urlString" : MerchantRecyleDetailURL(@"3", type)};
        }
            break;
        case JHMyCenterMerchantPushTypeRecyleWillConfirmPrice:
        {
            ///确认价格
            router.vc = @"JHWebViewController";
            router.type = @(JHRouterTypeParams).stringValue;
            router.params = @{@"urlString" : MerchantRecyleDetailURL(@"4", type)};
        }
            break;
        case JHMyCenterMerchantPushTypeRecyleArbitration:
        {
            ///仲裁查看
            router.vc = @"JHWebViewController";
            router.type = @(JHRouterTypeParams).stringValue;
            NSString *url = [NSString stringWithFormat:H5_BASE_STRING(@"/jianhuo/app/recycle/order/orderArbitrationList.html?index=0&bussId=%@"), type];
            router.params = @{@"urlString" : url};
        }
            break;

        ///店铺工具相关
        case JHMyCenterMerchantPushTypeMerchantCollege:
        {
            ///商学院
            router.vc = @"JHBusinessCollegeViewController";
//            router.type = @(JHRouterTypeParams).stringValue;
//            router.params = @{@"urlString" : MerchantRecyleDetailURL(@"waitConfirmPrice")};
        }
            break;
        case JHMyCenterMerchantPushTypeShopOrderComment:
        {
        /// 评价管理
            router.vc = @"JHOrderCommentManngeViewController";
            router.type = @(JHRouterTypeParams).stringValue;
            router.params = @{@"isSeller" : (user.isAssistant ? @0 : @1)};
        }
        break;
            
        case JHMyCenterMerchantPushTypeShopOrderOut:
        {
      /// 订单导出
            router.vc = @"OrderExportListViewController";
        }
        break;
            
        case JHMyCenterMerchantPushTypeShopCoupon:
        {
        /// 代金券管理
            router.vc = @"JHShopCouponViewController";
        }
        break;
            
        case JHMyCenterMerchantPushTypeShopOrderQuestion:
        {
        /// 问题单
            router.vc = @"JHOrderQuestionViewController";
        }
        break;
            
        case JHMyCenterMerchantPushTypeShopOrderWish:
        {
        /// 心愿单
            router.vc = @"JHWebViewController";
            router.type = @(JHRouterTypeParams).stringValue;
            router.params = @{@"urlString" : ShowWishPaperURL(1,1,0)};
        }
        break;
            
        case JHMyCenterMerchantPushTypeShopMute:
        {
        /// 禁言
            router.vc = @"JHMuteListViewController";
        }
        break;
            
        case JHMyCenterMerchantPushTypeShopRePlay:
        {
        /// 直播回放记录
            router.vc = @"JHBackPlayListVC";
        }
        break;
            
        case JHMyCenterMerchantPushTypeShopTrain:
        {
        /// 培训直播
        [JHRootController toNativeVC:@"NTESAudienceLiveViewController" withParam:@{@"roomId":[UserInfoRequestManager sharedInstance].infoConfigDict.channelLocalId} from:@"JHMyCenterMerchantView"];
            return;
        }
        break;
            
        case JHMyCenterMerchantPushTypeShopAssistant:
        {
        /// 助理管理
            router.vc = @"JHAssistantViewController";
        }
        break;
            
        case JHMyCenterMerchantPushTypeMoneyManger: {
        /// 资金管理
//            router.vc = @"JHBillTotalViewController";
            router.vc = @"JHWebViewController";
            router.type = @(JHRouterTypeParams).stringValue;
            NSString *url = H5_BASE_STRING(@"/jianhuo/app/recycle/asset/asset_entrance.html");
            router.params = @{@"urlString" : url};
        }
            break;
        case JHMyCenterMerchantPushTypeShopLastDayData: {
        /// 店铺数据
            router.vc = @"JHWebViewController";
            router.type = @(JHRouterTypeParams).stringValue;
            NSString *url = H5_BASE_STRING(@"/jianhuo/app/recycle/dataBoard/index.html");
            router.params = @{@"urlString" : url};
        }
            break;
        case JHMyCenterMerchantPushTypeCustomizeOrderWillAccept: {
            /// 定制待接单
            router.vc = @"JHCustomizeOrderListViewController";
            router.type = @(JHRouterTypeParams).stringValue;
            router.params = @{@"isSeller" : @YES,@"currentIndex":@"2"};
        }
            break;
        case JHMyCenterMerchantPushTypeCustomizeOrderWillPay:
        {
            /// 定制待付款
            router.vc = @"JHCustomizeOrderListViewController";
            router.type = @(JHRouterTypeParams).stringValue;
            router.params = @{@"isSeller" : @YES,@"currentIndex":@"1"};
        }
        break;
            
        case JHMyCenterMerchantPushTypeCustomizeOrderPlanning:
        {
            /// 定制方案中
            router.vc = @"JHCustomizeOrderListViewController";
            router.type = @(JHRouterTypeParams).stringValue;
            router.params = @{@"isSeller" : @YES,@"currentIndex":@"3"};
        }
        break;
            
        case JHMyCenterMerchantPushTypeCustomizeOrderMaking:
        {
            /// 定制制作中
            router.vc = @"JHCustomizeOrderListViewController";
            router.type = @(JHRouterTypeParams).stringValue;
            router.params = @{@"isSeller" : @YES,@"currentIndex":@"4"};
        }
        break;
            
        case JHMyCenterMerchantPushTypeCustomizeOrderWillSend:
        {
            /// 定制待发货
            router.vc = @"JHCustomizeOrderListViewController";
            router.type = @(JHRouterTypeParams).stringValue;
            router.params = @{@"isSeller" : @YES,@"currentIndex":@"5"};
        }
        break;
        case JHMyCenterMerchantPushTypeRecyclingPool:
        {
#pragma todo - 待修改回收池控制器的url
            /// 回收池
            NSLog(@"JHMyCenterMerchantPushTypeRecyclingPool");
//            router.vc = @"";
//            router.type = @(JHRouterTypeParams).stringValue;
//            router.params = @{@"isSeller" : @YES,@"currentIndex":@"5"};
        }
        break;
            
        case JHMyCenterMerchantPushTypeUserAuth : {
            /// 商家入驻
            router.vc = @"JHUserAuthInfoViewController";
        }
            break;
        case JHMyCenteBusinessFansSettingManager: {
            
            fansClub = YES;
            router.vc = @"JHBusinessFansSettingViewController";
            router.type = @(JHRouterTypeParams).stringValue;
            router.params = @{
                @"anchorId" :user.customerId,
                @"channelId":[UserInfoRequestManager sharedInstance].infoConfigDict.channelLocalId
            };
        }
            break;
        case JHMyCenterMerchantPushTypeCompeteDayData : {
            /// 我的参拍
            router.vc = @"JHMyCompeteViewController";
        }
            break;
        case JHMyCenterMerchantPushTypeGoodsManageDayData : {
            /// 商品管理
            router.vc = @"JHGoodsMagerViewController";
        }
            break;
        case JHMyCenterMerchantPushTypeShopServiceData : {
            /// 客服管理
            router.vc = @"JHServiceManageViewController";
            router.type = @(JHRouterTypeParams).stringValue;
            router.params = @{
                @"anchorId" :user.customerId,
            };
        }
            break;
            //活动报名
        case JHMyCenteBusinessActivityEntryManager:{
            router.vc = @"JHWebViewController";
            router.type = @(JHRouterTypeParams).stringValue;
            NSString *url = H5_BASE_STRING(@"/jianhuo/app/activityApply/activityList.html");
            router.params = @{@"urlString" : url};
        }
            break;
            //福袋
        case JHMyCenteBusinessActivityFuDai:{
            //我的福袋
            router.vc = @"JHLuckyBagAllViewController";
        }
            break;

        default:
            break;
    }
    
    if(router.vc && !fansClub){
        [JHRouters gotoPageByModel:router];
    }else if(router.vc){
        [self requestFansStatus:router];
    }
}

//请求fansclub状态
- (void)requestFansStatus:(JHRouterModel*)router{
    NSString *customerId = [UserInfoRequestManager sharedInstance].user.customerId;
    [JHBusinessFansSettingBusiness businessFansAnchorId:customerId StatusCompletion:^(NSError * _Nullable error, BOOL isGuaQi) {
        if (isGuaQi) {
            JHTOAST(@"粉丝团已被挂起，请联系官方运营人员");
        }else{
            if(router.vc){
                [JHRouters gotoPageByModel:router];
            }
        }
    }];
}

+ (void)pushSocialAuthViewController{
    if ([JHSQManager needAutoEnterMerchantVC]) {
        [[JHMyCenterMerchantCellButtonModel new] enterMerchantVC];
        return;
    }
}

//进入商家认证
- (void)enterMerchantVC {
    JHUserSignInfo *signInfo = [UserInfoRequestManager sharedInstance].levelModel.sign;
    //0未认证 1已认证 2企业认证中 3企业审核不通过
    if (signInfo.status_real == 1 || signInfo.status_real == 4) { ///已认证  认证通过
        if (signInfo.sign_type == 1) {
            ///已签约
            return;
        }
        if (signInfo.sign_type == 0) {
            ///已认证 未签约 跳转至签约界面
            [self.userViewModel loadSignPageUrlCompeleteBlock:^(NSString * _Nonnull url) {
                [JHMyCenterMerchantCellButtonModel gotoSignFile:url];
            }];
            return;
        }
    }
    if (signInfo.status_real == 2) {
        ///认证中 跳转到审核界面
        JHSignViewController *vc = [[JHSignViewController alloc] init];
        vc.checkStatus = JHCheckStatusChecking;  ///审核中
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
        return;
    }
    if (signInfo.status_real == 0 || signInfo.status_real == 3) {
        ///未认证/已认证 跳转至公告页
        JHSelectMerchantViewController *vc = [JHSelectMerchantViewController new];
        vc.merchantType = signInfo.real_type;
        vc.authStatus = signInfo.status_real;
        vc.signStatus = signInfo.sign_type;
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
        return;
    }
}

- (JHCommonUserViewModel *)userViewModel {
    if (!_userViewModel) {
        _userViewModel = [[JHCommonUserViewModel alloc] init];
    }
    return _userViewModel;
}

+ (void)gotoSignFile:(NSString *)htmlString {
    if (!htmlString) {  ///如果html字符串为空 不应该走下面的代码
        return;
    }
    JHWebViewController *webVC = [[JHWebViewController alloc] init];
    webVC.urlString =  htmlString;
    webVC.isNeedPoptoRoot = YES;
    [[JHRootController currentViewController].navigationController pushViewController:webVC animated:YES];
}

///进入银联签约h5页面
- (void)enterUnionSignPage {
    JHWebViewController *vc = [[JHWebViewController alloc] init];
    vc.titleString = JHLocalizedString(@"signContractTitle");
    vc.urlString = [UserInfoRequestManager sharedInstance].unionSignRequestInfoUrl;
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
}

@end
