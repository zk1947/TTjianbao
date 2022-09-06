//
//  NSObject+UnRecognizedSelHandler.m
//  TTjianbao
//
//  Created by wuyd on 2019/9/24.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "NSObject+UnRecognizedSelHandler.h"
#import <objc/runtime.h>
#import "AppDelegate.h"

static NSString *_errorFunctionName;
void dynamicMethodIMP(id self, SEL _cmd) {
#ifdef DEBUG
    NSString *error = [NSString stringWithFormat:@"捕获到异常崩溃信息：errorClass->:%@\n errorFuction->%@\n UnRecognized Selector", NSStringFromClass([self class]), _errorFunctionName];
    NSLog(@"%@", error);
#else
    NSLog(@"应用异常，可以上报到服务器");
#endif
    
}

#pragma mark -
#pragma mark - 方法替换
//static inline void change_method(Class _originalClass, SEL _originalSel, Class _newClass, SEL _newSel) {
//    Method methodOriginal = class_getInstanceMethod(_originalClass, _originalSel);
//    Method methodNew = class_getInstanceMethod(_newClass, _newSel);
//    method_exchangeImplementations(methodOriginal, methodNew);
//}

@implementation NSObject (UnRecognizedSelHandler)

//+ (void)load {
//    change_method([self class], @selector(methodSignatureForSelector:), [self class], @selector(yd_methodSignatureForSelector:));
//
//    change_method([self class], @selector(forwardInvocation:), [self class], @selector(yd_forwardInvocation:));
//}

- (NSMethodSignature *)yd_methodSignatureForSelector:(SEL)aSelector {
    if (![self respondsToSelector:aSelector]) {
        _errorFunctionName = NSStringFromSelector(aSelector);
        NSMethodSignature *methodSignature = [self yd_methodSignatureForSelector:aSelector];
        if (class_addMethod([self class], aSelector, (IMP)dynamicMethodIMP, "v@:")) {
            //方法参数的获取存在问题
            NSLog(@"添加临时方法");
        }
        if (!methodSignature) {
            methodSignature = [self yd_methodSignatureForSelector:aSelector];
        }
        
        return methodSignature;
        
    } else {
        return [self yd_methodSignatureForSelector:aSelector];
    }
}

- (void)yd_forwardInvocation:(NSInvocation *)anInvocation {
    SEL selector = [anInvocation selector];
    if ([self respondsToSelector:selector]) {
        [anInvocation invokeWithTarget:self];
    } else {
        [self yd_forwardInvocation:anInvocation];
    }
}

@end
