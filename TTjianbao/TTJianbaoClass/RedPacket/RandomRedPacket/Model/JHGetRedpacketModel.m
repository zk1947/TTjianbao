//
//  JHGetRedpacketModel.m
//  TTjianbao
//
//  Created by Jesse on 2020/1/8.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHGetRedpacketModel.h"

@implementation JHGetRedpacketModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"resultCode" : @"code"
    };
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"takeList" : [JHGetRedpacketDetailModel class]
    };
}

@end

@implementation JHGetRedpacketDetailModel

@end

