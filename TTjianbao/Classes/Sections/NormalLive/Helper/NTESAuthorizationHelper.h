//
//  NTESAuthorizationHelper.h
//  LiveStream_IM_Demo
//
//  Created by Netease on 17/3/20.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NTESAuthorizationHelper : NSObject

//相册权限
+ (void)requestAblumAuthorityWithCompletionHandler:(void (^)(NSError *))handler;

//照相机\麦克风权限
+ (BOOL)requestMediaCapturerAccessWithHandler:(void (^)(NSError *))handler;

@end
