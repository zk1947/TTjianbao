//
//  JHDispatch.h
//  TTjianbao
//
//  Created by user on 2020/11/11.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHDispatch : NSObject
/**
 *  在ui线程执行block, 如果已经在UI线程则直接执行block,否则同async方法
 *
 *  @param block 需要执行的代码
 */
+ (void)ui:(void (^)(void))block;

/**
 *  封装dispatch_async,其中 queue = dispatch_get_main_queue
 *
 *  @param block 需要执行的代码
 */
+ (void)async:(dispatch_block_t)block;
/**
 *  @note 队列优先级:
 *      - DISPATCH_QUEUE_PRIORITY_HIGH
 *      - DISPATCH_QUEUE_PRIORITY_DEFAULT
 *      - DISPATCH_QUEUE_PRIORITY_LOW
 *      - DISPATCH_QUEUE_PRIORITY_BACKGROUND
 */
+ (void)async:(long)priority name:(NSString*)name execute:(dispatch_block_t)block;
/**
 *  封装dispatch_after,其中 queue = dispatch_get_main_queue
 *
 *  @param delay 延迟时间,单位s
 *  @param block 需要执行的代码
 */
+ (void)after:(NSTimeInterval)delay execute:(dispatch_block_t)block;

/**
 *   封装dispatch_after
 *
 *  @param delay    延迟时间,单位s
 *  @param priority Dispatch队列优先级
 *  @param block    需要执行的代码
 *  @note 队列优先级:
 *      - DISPATCH_QUEUE_PRIORITY_HIGH
 *      - DISPATCH_QUEUE_PRIORITY_DEFAULT
 *      - DISPATCH_QUEUE_PRIORITY_LOW
 *      - DISPATCH_QUEUE_PRIORITY_BACKGROUND
 */
+ (void)after:(NSTimeInterval)delay priority:(long)priority name:(NSString*)name execute:(dispatch_block_t)block;

+ (dispatch_queue_t)queue;
@end

NS_ASSUME_NONNULL_END
