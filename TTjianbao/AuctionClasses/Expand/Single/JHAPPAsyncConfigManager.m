//
//  JHAPPAsyncConfigManager.m
//  TTjianbao
//
//  Created by bailee on 2019/7/24.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHAPPAsyncConfigManager.h"


#define kJHChannelUpdateKey  @"kJHChannelUpdateKey"

@implementation JHChannelUpdateModel
- (instancetype)init {
    self = [super init];
    if (self) {
        _ver_code = 0;
        _data = 0;
    }
    return self;
}
@end


@interface JHAPPAsyncConfigManager ()
@property (nonatomic, strong) JHChannelUpdateModel *latestChannleVerModel;
@end

static JHAPPAsyncConfigManager *appAsyncConfigManager;
@implementation JHAPPAsyncConfigManager

+ (JHAPPAsyncConfigManager *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        appAsyncConfigManager = [[JHAPPAsyncConfigManager alloc]init];
    });
    return appAsyncConfigManager;
}

//+ (instancetype)allocWithZone:(struct _NSZone *)zone {
//    return [self shareInstance];
//}
//
//- (instancetype)init {
//    return [JHAPPAsyncConfigManager shareInstance];
//}
//
//+ (id)copyWithZone:(struct _NSZone *)zone{
//    return [self shareInstance];
//}

- (void)updateAsyncConfig {
    NSDictionary *jsonDic = [[NSUserDefaults standardUserDefaults] objectForKey:kJHChannelUpdateKey];
    self.curChannleVerModel = [JHChannelUpdateModel mj_objectWithKeyValues:jsonDic];
    
    [HttpRequestTool postWithURL:COMMUNITY_FILE_BASE_STRING(@"/common/syncConfig") Parameters:@{@"channel_last_update_time":@(self.curChannleVerModel.ver_code)} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        NSLog(@"%@",respondObject.data);
        JHChannelUpdateModel* newModel = [JHChannelUpdateModel mj_objectWithKeyValues:respondObject.data[@"channel_last_update_time"]];
        self.latestChannleVerModel = newModel;
        if (self.curChannleVerModel && newModel.ver_code > self.curChannleVerModel.ver_code) {
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationChannelDidUpdated object:nil];
        } else {
        //首次安装
            [self didShowNewChannel];
        }
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}

- (void)didShowNewChannel {
    if ([self haveNewChannel]) {
        self.curChannleVerModel = self.latestChannleVerModel;
        NSDictionary *channelVersionDic = [self.latestChannleVerModel mj_keyValues];
        [[NSUserDefaults standardUserDefaults] setObject:channelVersionDic forKey:kJHChannelUpdateKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.latestChannleVerModel = nil;
    }
}

- (BOOL)haveNewChannel {
    return self.latestChannleVerModel?YES:NO;
}

@end
