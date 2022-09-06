//
//  JHBusinessModelTitleConfig.m
//  TTjianbao
//
//  Created by miao on 2021/7/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessModelTitleConfig.h"


 NSString *const JHStraightHairConfigKey = @"straightHairConfigKey";
 NSString *const JHDeliveryConfigKey = @"deliveryConfigKey";

@implementation JHBusinessModelTitleConfig

+ (NSDictionary *)businessModelTitleConfig {
    return @{
        // 提交订单页
        @"submitOrderPage":@{JHStraightHairConfigKey:@"源头好物·极速发货·假一赔三·售后无忧",
                             JHDeliveryConfigKey:@"专业鉴定·先鉴后发·假一赔三·售后无忧"
        },
        
        // 订单列表订单状态
        @"receivingListOrderStatus":@{JHStraightHairConfigKey:@"待收货",
                             JHDeliveryConfigKey:@"待平台收货"
        },
        // 订单详情页待付款
        @"orderDetailCommitment":@{JHStraightHairConfigKey:@"您所购买的商品由商家直发，源头好物，极速发货，假一赔三，售后无忧。",
                             JHDeliveryConfigKey:@""
        },
        
    };
}

@end
