//
//  JHNimNotificationModel.h
//  TTjianbao
//
//  Created by jiang on 2019/12/9.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHNimNotificationBody.h"
#import "JHStoneMessageModel.h"
#import "NTESLiveViewDefine.h"

NS_ASSUME_NONNULL_BEGIN
@interface JHNimNotificationModel : NSObject
@property(assign,nonatomic)NTESLiveCustomNotificationType  type;
@property(strong,nonatomic)JHStoneMessageModel  *body;
@end
NS_ASSUME_NONNULL_END
