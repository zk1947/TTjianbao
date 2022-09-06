//
//  NSObject+LSDefaultsCrash.m
//  TTjianbao
//
//  Created by wuyd on 2019/9/24.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "NSObject+LSDefaultsCrash.h"
#import "objc/runtime.h"

@implementation NSObject (LSDefaultsCrash)

+ (void)load {
    SEL originalSelector = @selector(doesNotRecognizeSelector:);
    SEL swizzledSelector = @selector(yd_doesNotRecognizeSelector:);
    
    Method originalMethod = class_getClassMethod(self, originalSelector);
    Method swizzledMethod = class_getClassMethod(self, swizzledSelector);
    
    if(class_addMethod(self, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))){
        class_replaceMethod(self, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

+ (void)yd_doesNotRecognizeSelector:(SEL)aSelector {
    //处理 _LSDefaults 崩溃问题
    if([[self description] isEqualToString:@"_LSDefaults"] && (aSelector == @selector(sharedInstance))){
        NSLog(@"\n----------"
              @"\n捕获到异常崩溃信息：_LSDefaults Crash"
              @"\n----------");
        return;
    }
    [self yd_doesNotRecognizeSelector:aSelector];
}

@end
