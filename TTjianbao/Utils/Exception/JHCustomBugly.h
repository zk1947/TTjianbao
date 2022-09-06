//
//  JHCustomBugly.h
//  TTjianbao
//
//  Created by yaoyao on 2020/2/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomBugly : NSObject

+ (void)buglySetUp;
//上报自定义错误
+ (void)customException:(NSException*)exception;
+ (void)customExceptionClass:(Class)class reason:(NSString*)reason;
+ (void)customExceptionClass:(Class)class reason:(NSString*)reason message:(NSDictionary*)dic;
@end

NS_ASSUME_NONNULL_END
