//
//  NSObject+Cast.m
//  TTjianbao
//
//  Created by user on 2020/10/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "NSObject+Cast.h"

@implementation NSObject (Cast)
+ (instancetype)cast:(id)object {
    if (!object) {
        return nil;
    }
    if ([object isKindOfClass:self]) {
        return object;
    }
    NSLog(@"Warning !! 类型转换失败. 无法将%@转换为%@", NSStringFromClass([object class]), NSStringFromClass(self));
    return nil;
}

+ (BOOL)has:(id)object {
    if (!object) {
        return NO;
    }
    return [object isKindOfClass:self];
}

- (BOOL)isEmpty {
    id aItem = self;
    if ([(aItem) isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if (([(aItem) respondsToSelector:@selector(length)])
        && ([((id)(aItem)) length] == 0)) {
        return YES;
    }
//    if (([aItem respondsToSelector:@selector(count)])
//        && ([((id)(aItem)) count] == 0)) {
//        return YES;
//    }
    return NO;
}
@end
