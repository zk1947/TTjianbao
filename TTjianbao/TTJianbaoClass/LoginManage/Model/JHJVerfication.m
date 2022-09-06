//
//  JHJVerfication.m
//  TTjianbao
//
//  Created by Jesse on 2020/8/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHJVerfication.h"

//极光一键登录appKey
#define kJVAuthAppKey @"ce5736172f26bb361ebd777d"

@interface JHJVerfication ()

@end

@implementation JHJVerfication

+ (void)startJVerfication
{
    JVAuthConfig *config = [[JVAuthConfig alloc] init];
    config.appKey = kJVAuthAppKey;
//    config.advertisingId = [CommHelp deviceIDFA];
    [JVERIFICATIONService setupWithConfig:config];
    [JVERIFICATIONService setDebug:NO];

    [JVERIFICATIONService preLogin:3000 completion:^(NSDictionary *result) {

    }];
}

@end

@implementation JHJVerficationResult

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"joperator" : @"operator"};
}

@end
