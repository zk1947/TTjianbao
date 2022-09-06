//
//  JHLaunchOptionsModel.m
//  TTjianbao
//
//  Created by jesee on 28/4/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLaunchOptionsModel.h"

@implementation JHLaunchOptionsModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"remoteNotification":@"UIApplicationLaunchOptionsRemoteNotificationKey"};
}
@end

@implementation JHLaunchOptionsNotifyModel

@end

@implementation JHApsModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"mutable_content":@"mutable-content"};
}
@end

@implementation JHApsAlertModel

@end
