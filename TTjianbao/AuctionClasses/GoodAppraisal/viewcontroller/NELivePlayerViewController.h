//
//  NELivePlayerVC.h
//  NELivePlayerDemo
//
//  Created by Netease on 2017/11/15.
//  Copyright © 2017年 netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseViewExtController.h"
#import "NELivePlayerControlView.h"
#import "JHVideoPlayControlView.h"
#import <NELivePlayerFramework/NELivePlayerFramework.h>

typedef void(^NTESLivePlayerShutdownHandler)(void);

@interface NELivePlayerViewController : JHBaseViewExtController

- (instancetype)initWithURL:(NSURL *)url andDecodeParm:(NSMutableArray *)decodeParm;
- (void)startPlay:(NSString *)streamUrl inView:(UIView *)view  andControlView:(JHVideoPlayControlView*)controlView;
- (void)startPlay:(NSString *)streamUrl inView:(UIView *)view  andTimeEndBlock:(JHFinishBlock)block;
@property (nonatomic, strong) NELivePlayerController *player; //播放器sdk
- (void)shutdown;
- (void)shutdown:(NTESLivePlayerShutdownHandler)handler;
@property (nonatomic,strong) NTESLivePlayerShutdownHandler shutdownHandler;
@property (nonatomic,assign)  BOOL viewDisAppear;
- (void)doInitPlayerNotication;
-(void)removePlayerNotication;
- (void)controlViewOnClickQuit:(NELivePlayerControlView *)controlView;

@end
