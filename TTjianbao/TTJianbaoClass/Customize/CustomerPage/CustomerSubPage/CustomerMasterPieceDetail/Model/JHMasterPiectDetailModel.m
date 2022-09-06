//
//  JHMasterPiectDetailModel.m
//  TTjianbao
//
//  Created by user on 2020/12/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMasterPiectDetailModel.h"

@implementation JHMasterPiectDetailModel
+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{
        @"ID" : @"id",
        @"desc":@"description"
    };
}
@end
