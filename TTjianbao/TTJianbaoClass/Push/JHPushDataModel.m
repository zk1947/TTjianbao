//
//  JHPushDataModel.m
//  TTjianbao
//
//  Created by jesee on 27/4/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPushDataModel.h"
#import "UserInfoRequestManager.h"

#define kPushReqPrefix @"/mc/anon/msg/push/"
#define kUserDeviceTokenKey @"JHUserDeviceTokenKey"

@implementation JHPushDataModel

//上报push到达
+ (void)report:(NSString*)pushIds
{
    JHPushReportModel* model = [JHPushReportModel new];
    model.pushIds = pushIds;
    [JH_REQUEST asynPost:model success:^(id respData) {
        
    } failure:^(NSString *errorMsg) {
        NSLog(@"push report fail :%@", errorMsg);
    }];
}

//上报push点击
+ (void)requestPushClicked:(NSString*)pushId
{
    JHPushClickModel* model = [JHPushClickModel new];
    model.pushId = pushId;
    [JH_REQUEST asynPost:model requestSerializerTypes:RequestSerializerTypeHttp success:^(id respData) {
        
    } failure:^(NSString *errorMsg) {
        NSLog(@"requestPushClicked fail :%@", errorMsg);
    }];
}

#pragma mark - token
+ (NSString*)userDeviceToken
{
    NSString * token = [JHUserDefaults objectForKey:kUserDeviceTokenKey];
    if(!token)
        token = @"notGetDeviceToken";
    return token;
}

+ (void)saveUserDeviceToken:(NSData *)deviceToken
{
//    NSString * deviceString = [[deviceToken description]stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
//    deviceString = [deviceString stringByReplacingOccurrencesOfString:@" " withString:@""];
//
    NSString * deviceString = nil;//[[NSString alloc] initWithData:deviceToken encoding:kCFStringEncodingUTF8];
    //iOS13以后
    if(!deviceString)
    {
        deviceString = [self getHexStringForData:deviceToken];
    }
    if(deviceString)
    {
        [JHUserDefaults setObject:deviceString forKey:kUserDeviceTokenKey];
//        [JHKeyChainExt saveExtValue:[deviceToken description]];
    }
}

//iOS13:Data转换成16进制字符串（NSData -> HexString)
+ (NSString *)getHexStringForData:(NSData *)data {
    NSUInteger len = [data length];
    char *chars = (char *) [data bytes];
    NSMutableString *hexString = [[NSMutableString alloc]init];
    for (NSUInteger i = 0; i < len; i++) {
        [hexString appendString:[NSString stringWithFormat:@"%0.2hhx", chars[i]]];
    }
    return hexString;
}
@end

/**POST /mc/anon/msg/push/report
*上报push到达 pushIds 逗号隔开
 */
@implementation JHPushReportModel

- (instancetype)init
{
    if(self = [super init])
    {
        self.deviceToken = [JHPushDataModel userDeviceToken];
    }
    return self;
}

- (NSString *)uriPath
{
    return [NSString stringWithFormat:@"%@report",kPushReqPrefix];
}
@end

/**POST /mc/anon/msg/push/click
*上报push点击
 */
@implementation JHPushClickModel

- (instancetype)init
{
    if(self = [super init])
    {
        self.deviceToken = [JHPushDataModel userDeviceToken];
    }
    return self;
}

- (NSString *)uriPath
{//~/mc/anon/msg/push/click
    return [NSString stringWithFormat:@"%@click",kPushReqPrefix];
}
@end
