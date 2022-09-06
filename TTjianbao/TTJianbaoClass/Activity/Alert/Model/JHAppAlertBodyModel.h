//
//  JHAppAlertBodyModel.h
//  TTjianbao
//
//  Created by apple on 2020/5/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHAppAlertBodyModel : NSObject

@end

/// 活动弹框  html url
@interface JHAppAlertBodyActivityModel : NSObject

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) BOOL isLiveRoom;

@property (nonatomic, copy) NSString *activityId;

@property (nonatomic, copy) NSString *taskDay;
@property (nonatomic, copy) NSString *taskName;
@end

NS_ASSUME_NONNULL_END
