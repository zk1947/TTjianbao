//
//  JHGuestLoginNIMSDKManage.h
//  TTjianbao
//
//  Created by yaoyao on 2020/2/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>


NS_ASSUME_NONNULL_BEGIN

@interface JHGuesterLoginModel : NSObject
@property (nonatomic, copy) NSString *accid;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *img;
@property (nonatomic, copy) NSString *anonymousId;

@end

@interface JHBodyTypeModel : NSObject
@property (nonatomic, copy) NSDictionary *body;
@property (nonatomic, assign) NSInteger type;


@end


@interface JHGuestLoginNIMSDKManage : NSObject <NIMBroadcastManagerDelegate, NIMSystemNotificationManagerDelegate>

+ (instancetype)sharedInstance;

- (void)addObserveNIMBroad;
@property (nonatomic, strong) JHGuesterLoginModel *guesterInfo;

/// 游客登录 登录云信账号 用来接收广播消息
@property (nonatomic, assign) BOOL isGuesterLogin;

- (void)requestGuestNimInfo;

- (void)requestOpenApp;
@end

NS_ASSUME_NONNULL_END
