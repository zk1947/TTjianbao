//
//  JHLivePlayerManager.h
//  TTjianbao
//
//  Created by jiang on 2019/9/4.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NELivePlayerFramework/NELivePlayerFramework.h>
NS_ASSUME_NONNULL_BEGIN

@interface JHLivePlayerManager : NSObject
@property (nonatomic, strong) NELivePlayerController * __nullable player;
+ (instancetype)sharedInstance;
- (void)startPlay:(NSString *)streamUrl inView:(UIView *)view andTimeEndBlock:(JHFinishBlock)block;

///拉流带动画
- (void)startPlay:(NSString *)streamUrl inView:(UIView *)view andTimeEndBlock:(JHFinishBlock)block isAnimal:(BOOL)isAnimal isLikeImageView:(BOOL)isLikeImageView;

- (void)startPlayIgnoreNetwork:(NSString *)streamUrl inView:(UIView *)view andPlayFailBlock:(JHFinishBlock)failBlock;

- (void)startPlay:(NSString *)streamUrl inView:(UIView *)view andPlayFailBlock:(JHFinishBlock)failBlock;

///拉流带动画
- (void)startPlay:(NSString *)streamUrl inView:(UIView *)view andPlayFailBlock:(JHFinishBlock)failBlock isAnimal:(BOOL)isAnimal;

/// 轮播拉流
/// @param streamUrl 地址
/// @param view 流 展示容器
/// @param failBlock 失败
/// @param playOutTimeBlock 成功 N秒后
/// @param timeInterval 成功 N秒后
- (void)startPlay:(NSString *)streamUrl
           inView:(UIView *)view
    playFailBlock:(JHFinishBlock)failBlock
 playOutTimeBlock:(dispatch_block_t __nullable)playOutTimeBlock
     timeInterval:(NSTimeInterval)timeInterval
         isAnimal:(BOOL)isAnimal
isLikeImageView:(BOOL)isLikeImageView;

- (void)shutdown;

@end

NS_ASSUME_NONNULL_END
