//
//  JHIMLoginManager.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHIMLoginManager.h"
#import "NTESLoginManager.h"

@interface JHIMLoginManager()<NIMLoginManagerDelegate>

@end

@implementation JHIMLoginManager
#pragma mark - Public
+ (instancetype)sharedManager
{
    static JHIMLoginManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JHIMLoginManager alloc] init];
    });
    return instance;
}
- (instancetype)init {
    if (self = [super init])
    {
        [self setManager];
        [NTESLoginManager sharedManager];
    }
    return self;
}
- (void)dealloc {
    [[[NIMSDK sharedSDK] loginManager] removeDelegate:self];
}

/// 登录
- (void)imLogin {
    if ([[NIMSDK sharedSDK] loginManager].isLogined) return;
    [self autoLogin];
}

#pragma mark - Private
- (void)setManager {
    [[[NIMSDK sharedSDK] loginManager] addDelegate:self];
    
}
// 自动登录
- (void)autoLogin {
    NTESLoginData *data = [[NTESLoginManager sharedManager] currentNTESLoginData];
    NSString *account = [data account];
    NSString *token = [data token];
    if ([account length] && [token length])
    {
        [[[NIMSDK sharedSDK] loginManager] autoLogin:account
                                               token:token];
    }
}
- (void)login {
    
}

#pragma mark - Delegate
/// 自动登录失败回调
- (void)onAutoLoginFailed:(NSError *)error {
    
}
- (void)onLogin:(NIMLoginStep)step {
    switch (step) {
        case NIMLoginStepSyncing:
            
            break;
        case NIMLoginStepSyncOK:
            
            break;
        default:
            break;
    }
}
@end
