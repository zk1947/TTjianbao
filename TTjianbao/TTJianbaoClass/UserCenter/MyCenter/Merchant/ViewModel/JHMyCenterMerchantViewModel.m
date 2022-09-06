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
        
        if(user.type == JHUserTypeRoleCustomize || user.type == JHUserTypeRoleCustomizeAssistant)
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

        if(user.type == JHUserTypeRoleRestoreAnchor || user.type == JHUserTypeRoleRestoreAssistant)
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
            if(user.type != JHUserTypeRoleCommunityShop){
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"my_center_switch_shop_2" title:@"代金券管理" type:JHMyCenterMerchantPushTypeShopCoupon]];
            }

            [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"my_center_switch_shop_4" title:@"问题单" type:JHMyCenterMerchantPushTypeShopOrderQuestion]];
            
            if(user.type != JHUserTypeRoleCustomize && user.type != JHUserTypeRoleCustomizeAssistant)
            {
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"my_center_switch_shop_3" title:@"宝友心愿单" type:JHMyCenterMerchantPushTypeShopOrderWish]];
            }
            
            
            if(user.type != JHUserTypeRoleCommunityShop) {
                
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"my_center_switch_shop_5" title:@"禁言管理" type:JHMyCenterMerchantPushTypeShopMute]];
                
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"my_center_switch_shop_6" title:@"直播回放记录" type:JHMyCenterMerchantPushTypeShopRePlay]];
                
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"my_center_switch_shop_7" title:@"培训直播间" type:JHMyCenterMerchantPushTypeShopTrain]];
                
                if(user.type == JHUserTypeRoleSaleAnchor ||
                   user.type == JHUserTypeRoleCommunityAndSaleAnchor ||
                   user.type == JHUserTypeRoleRestoreAnchor||
                    user.type == JHUserTypeRoleCustomize){
                    [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"my_center_switch_shop_8" title:@"助理管理" type:JHMyCenterMerchantPushTypeShopAssistant]];
                }
            }
            
            if(user.type == JHUserTypeRoleSaleAnchor || user.type == JHUserTypeRoleCommunityShop || user.type == JHUserTypeRoleCommunityAndSaleAnchor || user.type == JHUserTypeRoleRestoreAnchor || user.type == JHUserTypeRoleCustomize) {
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"my_center_switch_shop_10" title:@"资质信息" type:JHMyCenterMerchantPushTypeUserAuth]];
            }
			if (user.type == JHUserTypeRoleSaleAnchor ||
                user.type == JHUserTypeRoleRestoreAnchor ||
                user.type == JHUserTypeRoleCustomize) {
                [model.buttonArray addObject:[JHMyCenterMerchantCellButtonModel creatWithMessageCount:0 icon:@"userCenter_business_fansSetting" title:@"粉丝团设置" type:JHMyCenteBusinessFansSettingManager]];
            }
            
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

@end



