//
//  JHMyCenterMerchantViewModel.m
//  TTjianbao
//
//  Created by apple on 2020/4/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMyCenterMerchantViewModel.h"
#import "UserInfoRequestManager.h"
#import <SVProgressHUD.h>

@implementation JHMyCenterMerchantViewModel

-(void)requestCommonDataWithSubscriber:(id<RACSubscriber>)subscriber
{
    UserInfoRequestManager *user = [UserInfoRequestManager sharedInstance];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/withdraw/myWithdrawAccount") Parameters:@{@"customerType" : @(user.user.type) , @"customerId":user.user.customerId} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        if (IS_DICTIONARY(respondObject.data)) {
            _dataSource = [JHMyShopModel mj_objectWithKeyValues:respondObject.data];
        }
        [subscriber sendNext:@1];
        [subscriber sendCompleted];

    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD showErrorWithStatus:respondObject.message];
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
    }];
}

- (void)reloadDataArray{
    User *user = [UserInfoRequestManager sharedInstance].user;

    if (self.livingData.count == 0) {///直播的数据
        if (!user.hasOpenLiving)
        {  ///去开通新服务
            JHMyCenterMerchantCellModel *model = [JHMyCenterMerchantCellModel new];
            model.cellType = JHMyCenterMerchantCellTypeLivingBlank;
            model.cellHeight = 490.;
            [self.livingData addObject:model];
        }
        else {
            {///订单管理
                JHMyCenterMerchantCellModel *model = [JHMyCenterMerchantCellModel new];
                model.cellType = JHMyCenterMerchantCellTypeOrder;
                model.cellHeight = 122.f;
                
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_wait_pay" title:@"待付款" type:JHMyCenterMerchantPushTypeOrderWillPay contentType:JHMyCenterContentTypeLiving]];
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_wait_send" title:@"待发货" type:JHMyCenterMerchantPushTypeOrderWillSendGoods contentType:JHMyCenterContentTypeLiving]];
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_sended" title:@"已发货" type:JHMyCenterMerchantPushTypeOrderDidSentGoods contentType:JHMyCenterContentTypeLiving]];
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_after_sale" title:@"退款售后" type:JHMyCenterMerchantPushTypeOrderAfterSale contentType:JHMyCenterContentTypeLiving]];
                [self.livingData addObject:model];
            }
            if(user.blRole_restoreAnchor)
            {/// 回血主播 因为助理不在这个页面 所以不考虑助理号
                JHMyCenterMerchantCellModel *model = [JHMyCenterMerchantCellModel new];
                model.cellType = JHMyCenterMerchantCellTypeResale;
                model.cellHeight = 122.f;
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_restore_will_shelf" title:@"待上架" type:JHMyCenterMerchantPushTypeReSaleWillSale]];
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_restore_sale_recently" title:@"最近出售" type:JHMyCenterMerchantPushTypeReSaleDidSale]];
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_restore_send" title:@"寄售原石" type:JHMyCenterMerchantPushTypeReSaleSendSale]];
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_restore_wallet" title:@"原石零钱" type:JHMyCenterMerchantPushTypeReSaleWallet]];
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_restore_back" title:@"寄回原石" type:JHMyCenterMerchantPushTypeReSaleReturn]];
    //            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"my_center_switch_resale_5" title:@"原石订单" type:JHMyCenterMerchantPushTypeReSaleOrder]];
                [self.livingData addObject:model];
            }
            if(user.blRole_customize)
            {/// 定制主播 因为助理不在这个页面 所以不考虑助理号
                JHMyCenterMerchantCellModel *model = [JHMyCenterMerchantCellModel new];
                model.cellType = JHMyCenterMerchantCellTypeCustomize;
                model.cellHeight = 122.f;
                
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_wait_pay" title:@"待付款" type:JHMyCenterMerchantPushTypeCustomizeOrderWillPay]];
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_sended" title:@"待收货" type:JHMyCenterMerchantPushTypeCustomizeOrderWillAccept]];
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_planning" title:@"方案中" type:JHMyCenterMerchantPushTypeCustomizeOrderPlanning]];
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_making" title:@"制作中" type:JHMyCenterMerchantPushTypeCustomizeOrderMaking]];
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_wait_send" title:@"待发货" type:JHMyCenterMerchantPushTypeCustomizeOrderWillSend]];
                [self.livingData addObject:model];
            }
            if(user.hasOpenRecyle)
            {///回收主播 因为助理不在这个页面 所以不考虑助理号
                JHMyCenterMerchantCellModel *model = [JHMyCenterMerchantCellModel new];
                model.cellType = JHMyCenterMerchantCellTypeRecyle;
                model.cellHeight = 122.f;

                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_wait_pay" title:@"待付款" type:JHMyCenterMerchantPushTypeRecyleWillPay contentType:JHMyCenterContentTypeLiving]];
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_wait_send" title:@"待发货" type:JHMyCenterMerchantPushTypeRecyleWillSend contentType:JHMyCenterContentTypeLiving]];

                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_wait_send" title:@"待收货" type:JHMyCenterMerchantPushTypeRecyleDidSend contentType:JHMyCenterContentTypeLiving]];
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_mycenter_sale_return" title:@"待确认价格" type:JHMyCenterMerchantPushTypeRecyleWillConfirmPrice contentType:JHMyCenterContentTypeLiving]];
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_mycenter_arbitration" title:@"仲裁查看" type:JHMyCenterMerchantPushTypeRecyleArbitration contentType:JHMyCenterContentTypeLiving]];
                [self.livingData addObject:model];
            }
            {
                ///资金管理
                JHMyCenterMerchantCellModel *model = [JHMyCenterMerchantCellModel new];
                model.cellType = JHMyCenterMerchantCellTypeMoney;
                model.cellHeight = 125.f;
                [self.livingData addObject:model];
            }
            {
                /// 店铺工具
                JHMyCenterMerchantCellModel *model = [JHMyCenterMerchantCellModel new];
                model.cellType = JHMyCenterMerchantCellTypeShop;
                model.cellHeight = 267.f;
                [self.livingData addObject:model];
                
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_business_college" title:@"商学院" type:JHMyCenterMerchantPushTypeMerchantCollege]];

                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_order_comment" title:@"评价管理" type:JHMyCenterMerchantPushTypeShopOrderComment]];
                
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_order_export_record" title:@"订单导出记录" type:JHMyCenterMerchantPushTypeShopOrderOut]];
                
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_voucher" title:@"代金券管理" type:JHMyCenterMerchantPushTypeShopCoupon]];


                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_flaw_order" title:@"问题单" type:JHMyCenterMerchantPushTypeShopOrderQuestion]];
                
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_wish" title:@"宝友心愿单" type:JHMyCenterMerchantPushTypeShopOrderWish]];
                
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_ban_manage" title:@"禁言管理" type:JHMyCenterMerchantPushTypeShopMute]];
                
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_living_record" title:@"直播回放记录" type:JHMyCenterMerchantPushTypeShopRePlay]];
                
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_train_living" title:@"培训直播间" type:JHMyCenterMerchantPushTypeShopTrain]];
                
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_assissant" title:@"助理管理" type:JHMyCenterMerchantPushTypeShopAssistant]];
                
    //            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_chat_setting" title:@"会话设置" type:JHMyCenterMerchantPushTypeChatSetting]];
                
                
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_fans_setting" title:@"粉丝团设置" type:JHMyCenteBusinessFansSettingManager]];
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_activityEntry" title:@"活动报名" type:JHMyCenteBusinessActivityEntryManager]];
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"my_center_fudaai_icon" title:@"福袋" type:JHMyCenteBusinessActivityFuDai]];
                if (model.buttonArray.count > 12) {
                    model.cellHeight = 267.f + 70.f;
                }
            }
            if (!(user.hasOpenLiving && user.hasOpenRecyle && user.hasOpenExcellent)) {
                ///开通新服务 直播  回收 优店任何一个没有开通 都显示开通新服务
                JHMyCenterMerchantCellModel *model = [JHMyCenterMerchantCellModel new];
                model.cellType = JHMyCenterMerchantCellTypeOpenNewService;
                model.cellHeight = 90.f;
                [self.livingData addObject:model];
            }
        }
    }
    if (self.storeData.count == 0) {///商城的数据
        {///订单管理
            JHMyCenterMerchantCellModel *model = [JHMyCenterMerchantCellModel new];
            model.cellType = JHMyCenterMerchantCellTypeOrder;
            model.cellHeight = 122.f;
            
            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_wait_pay" title:@"待付款" type:JHMyCenterMerchantPushTypeOrderWillPay  contentType:JHMyCenterContentTypeStore]];
            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_wait_send" title:@"待发货" type:JHMyCenterMerchantPushTypeOrderWillSendGoods  contentType:JHMyCenterContentTypeStore]];
            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_sended" title:@"已发货" type:JHMyCenterMerchantPushTypeOrderDidSentGoods  contentType:JHMyCenterContentTypeStore]];
            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_after_sale" title:@"退款售后" type:JHMyCenterMerchantPushTypeOrderAfterSale  contentType:JHMyCenterContentTypeStore]];
            [self.storeData addObject:model];
        }
        if(user.hasOpenRecyle)
        {
            /// 回收店铺 因为助理不在这个页面 所以不考虑助理号 用户开通回收业务才会展示回收订单管理
            JHMyCenterMerchantCellModel *model = [JHMyCenterMerchantCellModel new];
            model.cellType = JHMyCenterMerchantCellTypeRecyle;
            model.cellHeight = user.hasOpenRecyle ? 174.f : 122.f;

            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_wait_pay" title:@"待付款" type:JHMyCenterMerchantPushTypeRecyleWillPay  contentType:JHMyCenterContentTypeStore]];
            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_wait_send" title:@"待发货" type:JHMyCenterMerchantPushTypeRecyleWillSend  contentType:JHMyCenterContentTypeStore]];
            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_wait_send" title:@"待收货" type:JHMyCenterMerchantPushTypeRecyleDidSend  contentType:JHMyCenterContentTypeStore]];
            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_mycenter_sale_return" title:@"待确认价格" type:JHMyCenterMerchantPushTypeRecyleWillConfirmPrice  contentType:JHMyCenterContentTypeStore]];
            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_mycenter_arbitration" title:@"仲裁查看" type:JHMyCenterMerchantPushTypeRecyleArbitration  contentType:JHMyCenterContentTypeStore]];
            [self.storeData addObject:model];
        }
        {
            ///资金管理
            JHMyCenterMerchantCellModel *model = [JHMyCenterMerchantCellModel new];
            model.cellType = JHMyCenterMerchantCellTypeMoney;
            model.cellHeight = 123.f;
            [self.storeData addObject:model];
        }
        {
            /// 店铺工具
            JHMyCenterMerchantCellModel *model = [JHMyCenterMerchantCellModel new];
            model.cellType = JHMyCenterMerchantCellTypeShop;
            model.cellHeight = 194.f;
            [self.storeData addObject:model];
//            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_person_compete" title:@"我的参拍" type:JHMyCenterMerchantPushTypeCompeteDayData]];
//            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_business_college" title:@"商学院" type:JHMyCenterMerchantPushTypeMerchantCollege]];
            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"mycenter_serviceManager_iocn" title:@"客服管理" type:JHMyCenterMerchantPushTypeShopServiceData]];
            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_order_comment" title:@"评价管理" type:JHMyCenterMerchantPushTypeShopOrderComment]];
            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_order_export_record" title:@"订单导出记录" type:JHMyCenterMerchantPushTypeShopOrderOut]];
            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_flaw_order" title:@"问题单" type:JHMyCenterMerchantPushTypeShopOrderQuestion]];
            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_wish" title:@"宝友心愿单" type:JHMyCenterMerchantPushTypeShopOrderWish]];
            if (user.hasOpenChat) {
                ///开通IM服务 展示会话设置icon
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_chat_setting" title:@"会话设置" type:JHMyCenterMerchantPushTypeChatSetting]];
                model.cellHeight = 194.f;
            }
            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_auth" title:@"资质信息" type:JHMyCenterMerchantPushTypeUserAuth]];
            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_goods_manager" title:@"商品管理" type:JHMyCenterMerchantPushTypeGoodsManageDayData]];
        }
        if (!(user.hasOpenLiving && user.hasOpenRecyle && user.hasOpenExcellent)) {
            ///开通新服务
            JHMyCenterMerchantCellModel *model = [JHMyCenterMerchantCellModel new];
            model.cellType = JHMyCenterMerchantCellTypeOpenNewService;
            model.cellHeight = 90.f;
            [self.storeData addObject:model];
        }
    }
}

- (void)reloadAssistantArray {
    if(self.dataArray.count == 0){
        User *user = [UserInfoRequestManager sharedInstance].user;
        /// 签约
        if(UserInfoRequestManager.sharedInstance.unionSignIsShow && !user.isAssistant)
        {
            JHMyCenterMerchantCellModel *model = [JHMyCenterMerchantCellModel new];
            model.cellType = JHMyCenterMerchantCellTypeUnionSign;
            model.cellHeight = 90.f;
            [self.dataArray addObject:model];
        }
        
        {
            JHMyCenterMerchantCellModel *model = [JHMyCenterMerchantCellModel new];
            model.cellType = JHMyCenterMerchantCellTypeOrder;
            model.cellHeight = 120.f;
            
            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"my_center_switch_order_0" title:@"待付款" type:JHMyCenterMerchantPushTypeOrderWillPay]];
            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"my_center_switch_order_1" title:@"待发货" type:JHMyCenterMerchantPushTypeOrderWillSendGoods]];
            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"my_center_switch_order_2" title:@"已发货" type:JHMyCenterMerchantPushTypeOrderDidSentGoods]];
            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"my_center_switch_order_3" title:@"退款售后" type:JHMyCenterMerchantPushTypeOrderAfterSale]];
            [self.dataArray addObject:model];
        }
        
        if(user.blRole_customize || user.blRole_customizeAssistant)
        {/// 定制
            JHMyCenterMerchantCellModel *model = [JHMyCenterMerchantCellModel new];
            model.cellType = JHMyCenterMerchantCellTypeCustomize;
            model.cellHeight = 120.f;
            
            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"my_center_switch_customizeorder_2" title:@"待付款" type:JHMyCenterMerchantPushTypeCustomizeOrderWillPay]];
            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_person_customize_anchorwait" title:@"待收货" type:JHMyCenterMerchantPushTypeCustomizeOrderWillAccept]];
            
            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"my_center_switch_customizeorder_3" title:@"方案中" type:JHMyCenterMerchantPushTypeCustomizeOrderPlanning]];
            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"my_center_switch_customizeorder_4" title:@"制作中" type:JHMyCenterMerchantPushTypeCustomizeOrderMaking]];
            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"my_center_switch_customizeorder_5" title:@"待发货" type:JHMyCenterMerchantPushTypeCustomizeOrderWillSend]];
            [self.dataArray addObject:model];
            
        }

        if(user.blRole_restoreAnchor || user.blRole_restoreAssistant)
        {/// 回血
            JHMyCenterMerchantCellModel *model = [JHMyCenterMerchantCellModel new];
            model.cellType = JHMyCenterMerchantCellTypeResale;
            model.cellHeight = 188.f;
            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"my_center_switch_resale_0" title:@"待上架" type:JHMyCenterMerchantPushTypeReSaleWillSale]];
            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"my_center_switch_resale_1" title:@"最近出售" type:JHMyCenterMerchantPushTypeReSaleDidSale]];
            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"my_center_switch_resale_2" title:@"寄售原石" type:JHMyCenterMerchantPushTypeReSaleSendSale]];
            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"my_center_switch_resale_3" title:@"原石零钱" type:JHMyCenterMerchantPushTypeReSaleWallet]];
            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"my_center_switch_resale_4" title:@"寄回原石" type:JHMyCenterMerchantPushTypeReSaleReturn]];
            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"my_center_switch_resale_5" title:@"原石订单" type:JHMyCenterMerchantPushTypeReSaleOrder]];
            [self.dataArray addObject:model];
        }
        
        {/// 店铺工具
            JHMyCenterMerchantCellModel *model = [JHMyCenterMerchantCellModel new];
            model.cellType = JHMyCenterMerchantCellTypeShop;
            model.cellHeight = 267.f;
            [self.dataArray addObject:model];
            
            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"my_center_switch_shop_0" title:@"评价管理" type:JHMyCenterMerchantPushTypeShopOrderComment]];
            
            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"my_center_switch_shop_1" title:@"订单导出记录" type:JHMyCenterMerchantPushTypeShopOrderOut]];
            if(!user.blRole_communityShop){
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"my_center_switch_shop_2" title:@"代金券管理" type:JHMyCenterMerchantPushTypeShopCoupon]];
            }

            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"my_center_switch_shop_4" title:@"问题单" type:JHMyCenterMerchantPushTypeShopOrderQuestion]];
            
            if(!user.blRole_customize && !user.blRole_customizeAssistant)
            {
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"my_center_switch_shop_3" title:@"宝友心愿单" type:JHMyCenterMerchantPushTypeShopOrderWish]];
            }
            
            if(!user.blRole_communityShop) {
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"my_center_switch_shop_5" title:@"禁言管理" type:JHMyCenterMerchantPushTypeShopMute]];
                
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"my_center_switch_shop_6" title:@"直播回放记录" type:JHMyCenterMerchantPushTypeShopRePlay]];
                
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"my_center_switch_shop_7" title:@"培训直播间" type:JHMyCenterMerchantPushTypeShopTrain]];
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_activityEntry" title:@"活动报名" type:JHMyCenteBusinessActivityEntryManager]];
            }
            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"icon_merchant_fans_setting" title:@"粉丝团设置" type:JHMyCenteBusinessFansSettingManager]];
            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"my_center_fudaai_icon" title:@"福袋" type:JHMyCenteBusinessActivityFuDai]];

            if(model.buttonArray.count > 8) {
                model.cellHeight = 267;
            }
            else if(model.buttonArray.count > 4) {
                model.cellHeight = 190;
            }
            else {
                model.cellHeight = 120;
            }
        }
    }
}

- (NSMutableArray *)livingData {
    if (!_livingData) {
        _livingData = [NSMutableArray array];
    }
    return _livingData;
}

- (NSMutableArray *)storeData {
    if (!_storeData) {
        _storeData = [NSMutableArray array];
    }
    return _storeData;
}
@end



