//
//  JHAlertViewModel.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/8/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef enum : NSUInteger {
    /// 关注主播-直播间
    JHAuthorizeClickTypeAnchorFollow,
    /// 关注鉴定师- 直播间
    JHAuthorizeClickTypeAppraisalFollow,
    /// 收藏商品-商品详情页
    JHAuthorizeClickTypeGoodsCollection,
    /// 用户支付订单成功
    JHAuthorizeClickTypePaymentSuccess,
    /// 发布帖子成功
    JHAuthorizeClickTypePostSendSuccess,
    /// 用户申请鉴定成功
    JHAuthorizeClickTypeAppraisalSuccess,
    /// 发布商品成功
    JHAuthorizeClickTypeGoodsUpdateSuccess,
    /// 用户支付图文鉴定订单成功- 发布商品、商品详情
    JHAuthorizeClickTypeAppraisalPaymentSuccess,

} JHAuthorizeClickType;

@interface JHAlertViewModel : NSObject
@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *subtitleText;
@property (nonatomic, copy) NSString *detailText;

+ (JHAlertViewModel *)getAlertViewModelWithType : (JHAuthorizeClickType)type;
@end
NS_ASSUME_NONNULL_END
