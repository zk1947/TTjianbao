//
//  JHProxy.m
//  TTjianbao
//
//  Created by jesee on 18/4/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHProxy.h"

@implementation JHProxy

//获取当前的方法签名
-(NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [self.target methodSignatureForSelector:sel];
}
//指定当前消息的处理者
-(void)forwardInvocation:(NSInvocation *)invocation
{
    [invocation invokeWithTarget:self.target];
}

@end
