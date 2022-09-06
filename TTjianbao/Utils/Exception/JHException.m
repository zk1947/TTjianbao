//
//  JHException.m
//  TTjianbao
//
//  Created by Jesse on 2019/12/3.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHException.h"

@implementation JHException

+ (void)setupExceptionHandler
{
    NSSetUncaughtExceptionHandler (&uncaughtExceptionHandler);
}

void uncaughtExceptionHandler(NSException *exception)
{
    NSLog(@"JHException ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~CRASH:\n %@", exception);
    NSLog(@"##########################################");//可以保存在本地
//    NSLog(@"JHException ~~~~~~~~~~~~~~~~~~~Stack Trace:\n %@", [exception callStackSymbols]);
}

@end
