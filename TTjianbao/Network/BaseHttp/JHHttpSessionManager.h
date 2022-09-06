//
//  JHHttpSessionManager.h
//  TTjianbao
//  Description:网络请求公参&加密等处理
//  Created by Jesse on 2020/8/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

//超时默认20 s
#define kDefaultTimeoutInterval 20

@interface JHHttpSessionManager : AFHTTPSessionManager

//获取AFHTTPSessionManager,添加公参,并且设置超时(bu设置默认为20 s)
- (void)setSessionManager:(RequestSerializerType)serializerType encryptParams:(NSDictionary*)params timeoutInterval:(NSTimeInterval)timeoutInterval;

@end

