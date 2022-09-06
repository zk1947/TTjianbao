//
//  JHMakeRedpacketModel.m
//  TTjianbao
//
//  Created by Jesse on 2020/1/8.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMakeRedpacketModel.h"
#import "NSString+Common.h"

@implementation JHMakeRedpacketModel

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"payWayList" : [PayWayMode class]
    };
}
@end

@implementation JHMakeRedpacketReqModel

 - (instancetype)init
{
    if(self = [super init])
    {
        self.takeCondition = 0;
//        self.wishes = kDefaultWishes;
    }
    return self;
}

- (NSString *)uriPath
{
    return @"/app/red-packet/send";
}

@end

@implementation JHMakeRedpacketPageModel

- (NSString *)maxAmountOfMoney
{
    _maxAmountOfMoney = [_maxAmountOfMoney priceString];
    return _maxAmountOfMoney;
}

- (NSString *)minAmountOfMoney
{
    _minAmountOfMoney = [_minAmountOfMoney priceString];
    return _minAmountOfMoney;
}
@end

@implementation JHMakeRedpacketPageReqModel

- (NSString *)uriPath
{
    return @"/app/red-packet/pre-sendNew";
}

@end

@implementation JHGetRedpacketDetailPageModel

- (NSString *)uriPath
{
    return @"/app/red-packet/list-take";
}

@end
