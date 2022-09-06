//
//  JHNimNotificationManager.h
//  TTjianbao
//
//  Created by jiang on 2019/12/7.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHMicWaitMode.h"

@interface JHNimNotificationManager : NSObject
@property(strong,nonatomic) JHMicWaitMode * micWaitMode;
@property(strong,nonatomic) JHMicWaitMode * customizeWaitMode;
@property(strong,nonatomic) JHMicWaitMode * recycleWaitMode;
+ (instancetype)sharedManager;
@end

