//
//  JHSingleton.h
//  TTjianbao
//  Description:创建单例
//  Created by Jesse on 2019/12/5.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#ifndef JHSingleton_h
#define JHSingleton_h

#define kSingleInstance(name) [name shared##name]
// ## : 连接字符串和参数
#define singleton_h(name) + (instancetype)shared##name;

#if __has_feature(objc_arc) // ARC

#define singleton_m(name) \
static id kInstanceName; \
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
kInstanceName = [super allocWithZone:zone]; \
}); \
return kInstanceName; \
} \
\
+ (instancetype)shared##name \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
kInstanceName = [[self alloc] init]; \
});\
return kInstanceName; \
}

#else // 非ARC

#define singleton_m(name) \
static id kInstanceName; \
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return kInstanceName; \
} \
\
+ (instancetype)shared##name \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return kInstanceName; \
} \
\
- (oneway void)release \
{ \
\
} \
\
- (id)autorelease \
{ \
return kInstanceName; \
} \
\
- (id)retain \
{ \
return kInstanceName; \
} \
\
- (NSUInteger)retainCount \
{ \
return 1; \
} \
\
+ (id)copyWithZone:(struct _NSZone *)zone \
{ \
return kInstanceName; \
}

#endif

#endif /* JHSingleton_h */
