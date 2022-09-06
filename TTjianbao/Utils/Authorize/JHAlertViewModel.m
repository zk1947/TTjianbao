//
//  JHAlertViewModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/8/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHAlertViewModel.h"

@implementation JHAlertViewModel
+ (JHAlertViewModel *)getAlertViewModelWithType : (JHAuthorizeClickType)type {
    JHAlertViewModel *model = [[JHAlertViewModel alloc] init];
    
    switch (type) {
            /// 关注主播-直播间
        case JHAuthorizeClickTypeAnchorFollow:
            model.titleText = @"接收开播提醒";
            model.subtitleText = @"不错过他的直播";
            model.detailText = @"关注的主播刚刚开播";
            break;
            /// 关注鉴定师- 直播间
        case JHAuthorizeClickTypeAppraisalFollow:
            model.titleText = @"打开鉴定开播提醒";
            model.subtitleText = @"不错过每一次鉴定连麦";
            model.detailText = @"关注的鉴定师已经开播";
            break;
            /// 收藏商品-商品详情页
        case JHAuthorizeClickTypeGoodsCollection:
            model.titleText = @"打开商品降价提醒";
            model.subtitleText = @"及时接收商品降价信息";
            model.detailText = @"收藏的商品已降价";
            break;
            /// 用户支付订单成功
        case JHAuthorizeClickTypePaymentSuccess:
            model.titleText = @"打开物流通知提醒";
            model.subtitleText = @"及时接收物流信息";
            model.detailText = @"商品已发货";
            break;
            /// 发布帖子成功
        case JHAuthorizeClickTypePostSendSuccess:
            model.titleText = @"打开评论提醒";
            model.subtitleText = @"及时接收宝友评论";
            model.detailText = @"收到一条新评论";
            break;
            /// 用户申请鉴定成功
        case JHAuthorizeClickTypeAppraisalSuccess:
            model.titleText = @"打开鉴定排队通知";
            model.subtitleText = @"不错过每一次鉴定连麦";
            model.detailText = @"鉴定排队即将到号";
            break;
            /// 发布商品成功
        case JHAuthorizeClickTypeGoodsUpdateSuccess:
            model.titleText = @"接收客户付费提醒";
            model.subtitleText = @"及时处理付款信息";
            model.detailText = @"买家刚刚付款，请查看";
            break;
            /// 用户支付图文鉴定订单成功- 发布商品、商品详情
        case JHAuthorizeClickTypeAppraisalPaymentSuccess:
            model.titleText = @"接收鉴定结果提醒";
            model.subtitleText = @"及时查看鉴定结果";
            model.detailText = @"鉴定结果已出炉";
            break;
        default:
            break;
    }
    
    return model;
}
@end
