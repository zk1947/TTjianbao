//
//  NTESPreviewInnerView.h
//  TTjianbao
//
//  Created by Simon Blue on 17/3/21.
//  Copyright © 2017年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTESAnchorLiveViewController.h"

@class ChannelMode;
@protocol NTESPreviewInnerViewDelegate <NSObject>

@optional

- (void)onCloseLiving;
- (void)onStartLiving:(NSString*)liveTitle;
- (void)onRotate:(NIMVideoOrientation)orientation;
- (void)onCameraRotate;
- (BOOL)interactionDisabled;
- (ChannelMode *)channelModel;

@end

#import "BaseView.h"

@interface NTESPreviewInnerView : BaseView
@property (nonatomic,weak) id<NTESPreviewInnerViewDelegate> delegate;
/**
 0 直播鉴定 1 直播卖货
 */
@property (nonatomic, assign) NSInteger type;
- (instancetype)initWithChatroom:(NSString *)chatroomId
                           frame:(CGRect)frame;
- (void)switchToWaitingUI;

- (void)switchToLinkingUI;

- (void)switchToEndUI;

- (NTESFiterStatusModel *)getFilterModel;

- (void)updateBeautifyButton:(BOOL)isOn;
- (NSString *)titleString;
-(void)setTitleString:(NSString *)titleString;
@end
