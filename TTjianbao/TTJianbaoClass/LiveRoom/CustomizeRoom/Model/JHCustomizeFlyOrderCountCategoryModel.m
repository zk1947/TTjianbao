//
//  JHCustomizeFlyOrderCountCategoryModel.m
//  TTjianbao
//
//  Created by lihang on 2020/11/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeFlyOrderCountCategoryModel.h"

@implementation JHCustomizeFlyOrderCountCategoryModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"customizeFeeId" : @"id", @"customizeFeeName" : @"name"};
}
@end
