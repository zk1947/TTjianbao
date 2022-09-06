//
//  JHChatOrderInfoModel.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatOrderInfoModel.h"
@implementation JHChatCustomOrderModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.type = JHChatCustomTypeOrder;
    }
    return self;
}
- (NSString *)encodeAttachment
{
    return [self mj_JSONString];
}
@end

@implementation JHChatOrderInfoListModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"orderInfos" : [JHChatOrderInfoModel class],
    };
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"orderInfos" : @"customerOrderVo",
    };
}
@end

@implementation JHChatOrderInfoModel
- (instancetype)init {
    self = [super init];
    if (self) {
        self.orderId = @"";
    }
    return self;
}


- (NSString *)iconUrl {
    return _iconUrl ?: _goodsUrl;
}
- (NSString *)title {
    return _title ?: _goodsTitle;
}
- (NSString *)price {
    return _price ?: _orderAmount;
}
- (NSString *)orderId {
    return _orderId.length > 0 ? _orderId : _orderCode;
}
- (NSString *)orderState {
    return _orderState ?: _orderStatusDesc;
}
- (NSString *)orderStatusDescBuyer {
    return _orderStatusDescBuyer ?: _orderState;
}
-(NSString *)orderStatusDescSeller {
    return _orderStatusDescSeller ?: _orderState;
}
- (NSString *)orderDate {
    return _orderDate ?: _payTime;
}

@end
