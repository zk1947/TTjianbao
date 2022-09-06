//
//  JHCustomerPublishModel.m
//  TTjianbao
//
//  Created by user on 2020/11/11.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerPublishModel.h"


@implementation JHCustomerEditCerPublishModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"ID" : @"id",
        @"desc": @"description"
    };
}
@end


@implementation JHCustomerEditOpusPicsPublishModel
@end


@implementation JHCustomerEditOpusPublishModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"ID" : @"id",
        @"desc": @"description"
    };
}
// 返回容器类中的所需要存放的数据类型 (以 Class 或 Class Name 的形式)。
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
        @"opusImgs" : [JHCustomerEditOpusPicsPublishModel class]
    };
}
@end

