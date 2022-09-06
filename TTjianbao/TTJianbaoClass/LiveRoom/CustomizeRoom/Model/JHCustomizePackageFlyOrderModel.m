//
//  JHCustomizePackageFlyOrderModel.m
//  TTjianbao
//
//  Created by user on 2021/1/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHCustomizePackageFlyOrderModel.h"


@implementation JHCreateCustomizeFeeListModel
@end

@implementation JHCreateCustomizeNormalRequestModel
+ (NSDictionary *)mj_objectClassInArray {
    return @{
        @"customizeFeeList" : [JHCreateCustomizeFeeListModel class]
    };
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"anewGoodsCateId" : @"newGoodsCateId"
    };
}
@end

@implementation JHCheckCustomizeOrderListModel
@end
