//
//  CSQOrderModel.m
//  TTjianbao
//
//  Created by wuyd on 2019/8/9.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "CSQOrderModel.h"

@implementation CSQOrderModel

//返回一个 Dict，将 Model 属性名映射到 JSON 的 Key。
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"orderCode" : @"order_code",
             @"orderId" : @"ttjb_order_id"
             };
}

@end
