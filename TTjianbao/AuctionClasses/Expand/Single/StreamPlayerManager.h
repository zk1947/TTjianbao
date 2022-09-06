//
//  StreamPlayerManager.h
//  TaodangpuAuction
//
//  Created by jiang on 2019/8/23.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NELivePlayerControlView.h"
#import "JHVideoPlayControlView.h"
#import <NELivePlayerFramework/NELivePlayerFramework.h>
typedef void(^NTESLivePlayerShutdownHandler)(void);
NS_ASSUME_NONNULL_BEGIN

@interface StreamPlayerManager : NSObject
- (instancetype)initWithURL:(NSURL *)url andDecodeParm:(NSMutableArray *)decodeParm;
- (void)startPlay:(NSString *)streamUrl inView:(UIView *)view  andControlView:(JHVideoPlayControlView*)controlView;
- (void)startPlay:(NSString *)streamUrl inView:(UIView *)view  andTimeEndBlock:(complete)block;
@property (nonatomic, strong) NELivePlayerController *player; //播放器sdk
- (void)shutdown;
- (void)shutdown:(NTESLivePlayerShutdownHandler)handler;
@property (nonatomic,strong) NTESLivePlayerShutdownHandler shutdownHandler;
@property (nonatomic,assign)  BOOL viewDisAppear;
@end

NS_ASSUME_NONNULL_END
