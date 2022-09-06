//
//  JHStoreSnapShootDetailModel.m
//  TTjianbao
//
//  Created by jiangchao on 2021/3/8.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreSnapShootDetailModel.h"

@implementation JHStoreSnapShootDetailModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"productAttrList" : @"productAttrs",
            };
}
@end
