//
//  JHDispatch.m
//  TTjianbao
//
//  Created by user on 2020/11/11.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHDispatch.h"
#import "YYDispatchQueuePool.h"

@interface JHDispatch ()
@property (nonatomic, strong)  YYDispatchQueuePool *queuePool;
@end

@implementation JHDispatch

+ (void)ui:(void (^)(void))block {
    if ([NSThread isMainThread]) {
        block();
    } else {
        dispatch_queue_t queue = dispatch_get_main_queue();
        dispatch_async(queue, ^{
            block();
        });
    }
}

+ (void)async:(dispatch_block_t)block {
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_async(queue, ^{
        block();
    });
}

+ (void)async:(long)priority name:(NSString*)name execute:(dispatch_block_t)block {
    dispatch_queue_t queue = dispatch_get_global_queue(priority,0);
    dispatch_async(queue, ^{
        NSThread.currentThread.name = name;
        if (block) {block();}
    });
}

+ (void)after:(NSTimeInterval)delay execute:(dispatch_block_t)block {
    int64_t          delta = (int64_t)(delay * NSEC_PER_SEC);
    dispatch_time_t  when  = dispatch_time(DISPATCH_TIME_NOW, delta);
    dispatch_queue_t queue = dispatch_get_main_queue();
    dispatch_after(when,queue,block);
}

+ (void)after:(NSTimeInterval)delay priority:(long)priority name:(NSString*)name execute:(dispatch_block_t)block {
    int64_t          delta = (int64_t)(delay * NSEC_PER_SEC);
    dispatch_time_t  when  = dispatch_time(DISPATCH_TIME_NOW, delta);
    dispatch_queue_t queue = dispatch_get_global_queue(priority,0);
    dispatch_after(when, queue, ^{
        NSThread.currentThread.name = name;
        if (block) {block();}
    });
}

+ (instancetype)shared {
    Class exceptClass = [JHDispatch class];

    if ([[[self class] superclass] isSubclassOfClass:exceptClass]) {
        @throw [NSException exceptionWithName:@"call singleton from unexcept class"
                                       reason:@"不要在子类上调用该单例方法"
                                     userInfo:@{@"except class":NSStringFromClass(exceptClass)
                                                , @"actual class":NSStringFromClass([self class])}];
    }

    static JHDispatch     *instance;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        instance = [[[exceptClass class] alloc] init];
        instance.queuePool = [[YYDispatchQueuePool alloc] initWithName:@"file.read" queueCount:5 qos:NSQualityOfServiceBackground];
    });


    return instance;
} /* application */

- (dispatch_queue_t)queue {
    dispatch_queue_t queue = [self.queuePool queue];
    return queue;
}
+ (dispatch_queue_t)queue {
    return [[self shared] queue];
}

@end
