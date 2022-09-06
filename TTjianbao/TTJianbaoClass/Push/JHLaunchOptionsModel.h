//
//  JHLaunchOptionsModel.h
//  TTjianbao
//
//  Created by jesee on 28/4/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JHLaunchOptionsNotifyModel, JHApsModel, JHApsAlertModel;

NS_ASSUME_NONNULL_BEGIN

@interface JHLaunchOptionsModel : JHRespModel

/*
UIApplicationLaunchOptionsRemoteNotificationKey =     {
    aps =         {
        alert =             {
            body = 3333;
            subtitle = 2222;
            title = 1111;
        };
        category = 323232;
        "mutable-content" = 1;
        sound = default;
    };
    pushId = 2332;
    xg =         {
        bid = 0;
        guid = 13762992723;
        msgid = 1803716484;
        token = 37d9f506481af79b44cf7de747f5fbed6a07cfb8c6a499e1d85f13a85a583894;
        ts = 1588235195;
    };
}
*/
@property (nonatomic, strong) JHLaunchOptionsNotifyModel *remoteNotification;
//其他...
@end

@interface JHLaunchOptionsNotifyModel : JHRespModel

@property (nonatomic, strong) JHApsModel *aps; //远程push通知
@property (nonatomic, strong) NSDictionary *xg;
@property (nonatomic, copy) NSString *pushId;

//其他...
@end

/**简化为两大类
 *1->{ "aps":{ "alert":{ "title":"I am title", "subtitle":"I am subtitle", "body":"I am body" }, "sound":"default", "badge":1 } }
 *2->{ "aps":{ "alert":"I am alert content", "sound":"default", "badge":1 } }
 *3->>现用的>>>{
     alert =             {
         body = 3333;
         subtitle = 2222;
         title = 1111;
     };
     category = 323232;
     "mutable-content" = 1;
     sound = default;
 }
 */
@interface JHApsModel : NSObject

//@property (nonatomic, strong) NSDictionary *alert; // 消息文本
@property (nonatomic, strong) JHApsAlertModel *alert; // 消息文本
//截获push前提:mutable-content": "1"
@property (nonatomic, copy) NSString *mutable_content;
@property (nonatomic, copy) NSString *sound; // 提示音
@property (nonatomic, copy) NSString *category; // iOS通知 category ？？
@property (nonatomic, copy) NSString *badge; // 角标数
//其他...
@end

@interface JHApsAlertModel : NSObject

@property (nonatomic, copy) NSString *title; // 标题
@property (nonatomic, copy) NSString *subtitle; // 二级标题
@property (nonatomic, copy) NSString *body; // 内容
//其他...
@end

NS_ASSUME_NONNULL_END
