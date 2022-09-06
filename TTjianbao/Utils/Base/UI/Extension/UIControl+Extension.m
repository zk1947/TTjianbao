//
//  UIControl+Extension.m
//  TTjianbao
//
//  Created by Jesse on 2020/3/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "UIControl+Extension.h"
#import <objc/runtime.h>

//是否使用??开关 0: 关 1:开
#define kOpenCaptureResponerSwitch 0

static char * const kEventIntervalKey = "kEventIntervalKey";
static char * const kEventUnavailableKey = "kEventUnavailableKey";

@interface UIControl ()

@property (nonatomic, assign) BOOL eventUnavailable;
@end

@implementation UIControl (Extension)

+ (void)load
{
#if kOpenCaptureResponerSwitch
    Method method = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method customMethod = class_getInstanceMethod(self, @selector(customSendAction:to:forEvent:));
    method_exchangeImplementations(method, customMethod);
#endif
}

#pragma mark - Action functions
- (void)customSendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    /*屏蔽一下冲突
     *1,与growing SDK有冲突<前缀为:growingHook
     *2,与FLEX SDK有冲突<前缀为:_flex_swizzle
     */
    if ([self hasntConflict:action])
    {
        if([self dontCapture:action])
        {
            [self customSendAction:action to:target forEvent:event];
        }
        else if (self.eventUnavailable == NO)
        {
            self.eventUnavailable = YES;
            [self customSendAction:action to:target forEvent:event];
            [self performSelector:@selector(setEventUnavailable:) withObject:@(NO) afterDelay:self.eventInterval];
        }
    }
}
//不冲突
- (BOOL)hasntConflict:(SEL)action
{
    BOOL ret = YES;
    if ([NSStringFromSelector(action) hasPrefix:@"growingHook"]
        || [NSStringFromSelector(action) hasPrefix:@"_flex_swizzle"])
    {
        ret = NO;
    }
    return ret;
}

//不拦截:一般是系统底层方法
- (BOOL)dontCapture:(SEL)action
{
    BOOL ret = NO;
    if ([NSStringFromSelector(action) containsString:@"buttonDown"]
        || [NSStringFromSelector(action) containsString:@"buttonUp"])
    {
        ret = YES;
    }
    return ret;
}

#pragma mark - Setter & Getter functions
- (NSTimeInterval)eventInterval
{
    return [objc_getAssociatedObject(self, kEventIntervalKey) doubleValue];
}

- (void)setEventInterval:(NSTimeInterval)eventInterval
{
    objc_setAssociatedObject(self, kEventIntervalKey, @(eventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)eventUnavailable
{
    return [objc_getAssociatedObject(self, kEventUnavailableKey) boolValue];
}

- (void)setEventUnavailable:(BOOL)eventUnavailable
{
    objc_setAssociatedObject(self, kEventUnavailableKey, @(eventUnavailable), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
