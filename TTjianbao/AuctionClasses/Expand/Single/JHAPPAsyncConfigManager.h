//
//  JHAPPAsyncConfigManager.h
//  TTjianbao
//
//  Created by bailee on 2019/7/24.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#define kNotificationChannelDidUpdated @"kNotificationChannelDidUpdated"

NS_ASSUME_NONNULL_BEGIN
@interface JHChannelUpdateModel : NSObject
@property (nonatomic, assign) NSInteger data;
@property (nonatomic, assign) NSInteger ver_code;
@end

@interface JHAPPAsyncConfigManager : NSObject

+ (JHAPPAsyncConfigManager *)shareInstance;

@property (nonatomic, strong) JHChannelUpdateModel *curChannleVerModel;
- (void)updateAsyncConfig;
- (BOOL)haveNewChannel;
- (void)didShowNewChannel;

@end

NS_ASSUME_NONNULL_END
