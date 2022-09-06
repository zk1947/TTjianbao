//
//  JHLivePlayer.h
//  TTjianbao
//
//  Created by jiang on 2020/2/24.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NELivePlayerFramework/NELivePlayerFramework.h>
NS_ASSUME_NONNULL_BEGIN

@interface JHLivePlayer : UIView
@property (nonatomic, strong) NELivePlayerController * __nullable player;
@property (nonatomic, strong) JHFinishBlock didPlayBlock;
+ (instancetype)sharedInstance;
- (void)startPlay:(NSString *)streamUrl inView:(UIView *)view;
- (void)doDestroyPlayer;
//静音
- (void)setMute: (BOOL)isMute;
@end

NS_ASSUME_NONNULL_END
