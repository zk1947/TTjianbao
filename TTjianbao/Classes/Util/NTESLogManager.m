//
//  NTESLogManager.m
//  NIM
//
//  Created by Xuhui on 15/4/1.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "NTESLogManager.h"
#import "NTESLogViewController.h"
#import <NIMSDK/NIMSDK.h>
#import "NTESBundleSetting.h"

@interface NTESLogFileManager : DDLogFileManagerDefault

@end

@interface NTESLogManager () {
    DDFileLogger *_fileLogger;
}

@end

@implementation NTESLogManager

+ (instancetype)sharedManager
{
    static NTESLogManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[NTESLogManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if(self) {
         setenv("XcodeColors", "YES", 1);
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
        _fileLogger = [[DDFileLogger alloc] initWithLogFileManager:[NTESLogFileManager new]];
        _fileLogger.rollingFrequency = 60 * 60 * 24; // 24 hour rolling
        _fileLogger.logFileManager.maximumNumberOfLogFiles = 7;
        [DDLog addLogger:_fileLogger];
    }
    return self;
}

- (void)start
{
    DDLogInfo(@"App Started SDK Version %@\nBundle Setting: %@",[[NIMSDK sharedSDK] sdkVersion],[NTESBundleSetting sharedConfig]);
}

- (UIViewController *)demoLogViewController {
    NSString *filepath = _fileLogger.currentLogFileInfo.filePath;
    NTESLogViewController *vc = [[NTESLogViewController alloc] initWithFilepath:filepath];
    vc.title = @"Demo Log";
    return vc;
}

- (UIViewController *)sdkLogViewController
{
    NSString *filepath = [[NIMSDK sharedSDK] currentLogFilepath];
    NTESLogViewController *vc = [[NTESLogViewController alloc] initWithFilepath:filepath];
    vc.title = @"SDK Log";
    return vc;
}

@end


@implementation NTESLogFileManager

- (NSString *)logsDirectory
{
    NSString *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSString *path = [doc stringByAppendingPathComponent:@"JHLiveLog"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

@end
