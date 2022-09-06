//
//  JHGuestLoginNIMSDKManage.m
//  TTjianbao
//
//  Created by yaoyao on 2020/2/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHGuestLoginNIMSDKManage.h"
#import "JHRedPacketGuideModel.h"
#import "JHAppAlertViewManger.h"
#import "NTESLiveViewDefine.h"

///获取登录网易的游客accid和token
#define JHRequestPathGetWyAccidAndToken FILE_BASE_STRING(@"/manage/getWyAccidAndToken")
#define JHRequestPathOpenApp FILE_BASE_STRING(@"/app/opt/event/open-app")

@implementation JHGuesterLoginModel
@end

@implementation JHBodyTypeModel


@end

@implementation JHGuestLoginNIMSDKManage
static JHGuestLoginNIMSDKManage *instance;

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JHGuestLoginNIMSDKManage alloc] init];
        [instance addObserveNIMBroad];
    });
    return instance;
}


- (void)requestGuestNimInfo {
    if (![JHRootController isLogin]) {
        [HttpRequestTool getWithURL:JHRequestPathGetWyAccidAndToken Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
               self.guesterInfo = [JHGuesterLoginModel mj_objectWithKeyValues:respondObject.data];
               [self loginIM];
               
           } failureBlock:^(RequestModel * _Nullable respondObject) {
               
           }];
    }else {
        [self requestOpenApp];
    }
   
}

- (void)loginIM {
    [JHRootController loginIM:self.guesterInfo.accid token:self.guesterInfo.token completion:^(NSError * _Nullable error) {
        if (!error) {
            self.isGuesterLogin = YES;
            [self requestOpenApp];
        }else {
            [self requestOpenApp];
        }
    }];
}

- (void)addObserveNIMBroad {
    [[NIMSDK sharedSDK].broadcastManager addDelegate:self];
    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
}

- (void)requestOpenApp {
    
    [HttpRequestTool postWithURL:JHRequestPathOpenApp Parameters:nil requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];
}

- (void)onReceiveBroadcastMessage:(NIMBroadcastMessage *)broadcastMessage {

    NSString *content  = broadcastMessage.content;
    JHBodyTypeModel *model = [JHBodyTypeModel mj_objectWithKeyValues:[content mj_JSONObject]];
   
    [self handleMessage:model];
    
    NSLog(@"%@",content);
}

- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification {
    NSString *content  = notification.content;
    JHBodyTypeModel *model = [JHBodyTypeModel mj_objectWithKeyValues:[content mj_JSONObject]];
    [self handleMessage:model];
    NSLog(@"%@",content);

}

- (void)handleMessage:(JHBodyTypeModel *)model {
    switch (model.type) {
        case JHSystemMsgTypeBigRedPacketMsg:
        case JHSystemMsgTypeBigRedPacketMsgPoint:
        {
            JHRedPacketGuideModel *redModel = [JHRedPacketGuideModel mj_objectWithKeyValues:model.body];
            if (redModel) {
                JHAppAlertModel *m = [JHAppAlertModel new];
                m.type = JHAppAlertTypeBigRedPacket;
                m.localType = JHAppAlertLocalTypeHome;
                m.body = redModel;
                m.typeName = AppAlertSuperRedPacket;
                [JHAppAlertViewManger addModelArray:@[m]];
            }
            
        }
            
            break;
        case JHSystemMsgTypeBigRedPacketDeleteMsg: {
            JHRedPacketGuideModel *redModel = [JHRedPacketGuideModel mj_objectWithKeyValues:model.body];
            if (redModel) {
                JHAppAlertModel *m = [JHAppAlertModel new];
                m.type = JHAppAlertTypeBigRedPacket;
                m.body = redModel;
                m.typeName = AppAlertSuperRedPacket;
                [JHAppAlertViewManger cancleShowRedPacketWithModelArray:@[m]];
            }
        }
            break;
            
        case JHSystemMsgTypePraiseChange:
        case JHSystemMsgTypeCommentChange:
        case JHSystemMsgTypeAtComment:
        case JHSystemMsgTypeAtDynamic: {
            NSString *type = @"1";
            switch (model.type) {
                case JHSystemMsgTypeCommentChange:
                {
                    type = @"1";
                }
                    break;
                    
                case JHSystemMsgTypePraiseChange:
                {
                    type = @"2";
                }
                    break;
                    
                case JHSystemMsgTypeAtComment:
                {
                    type = @"3";
                }
                    break;
                case JHSystemMsgTypeAtDynamic:
                {
                    type = @"4";
                }
                    break;
                    
                default:
                    break;
            }
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:model.body];
            [dic setValue:type forKey:@"type"];
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSocilHomeMessageChange object:dic];
        }
            break;
            
        case JHSystemMsgTypeStoreLiving:
        {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:model.body];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_APPRAISE_STORE_SYSTEM_MESSAGE object:dic];
        }
            break;
               
           default:
        {
        }
               break;
    }
}

@end
