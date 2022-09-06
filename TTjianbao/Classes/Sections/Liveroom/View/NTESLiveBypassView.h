//
//  NTESLiveBypassView.h
//  TTjianbao
//
//  Created by chris on 16/7/26.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NTESMicConnector;

typedef NS_ENUM(NSInteger, NTESLiveBypassViewStatus){
    NTESLiveBypassViewStatusNone,
    NTESLiveBypassViewStatusPlaying,
    NTESLiveBypassViewStatusPlayingAndBypassingAudio,
    NTESLiveBypassViewStatusLoading,
    NTESLiveBypassViewStatusStreamingVideo,
    NTESLiveBypassViewStatusStreamingAudio,
    NTESLiveBypassViewStatusLocalVideo,
    NTESLiveBypassViewStatusLocalAudio,
    NTESLiveBypassViewStatusExitConfirm,
};

@protocol NTESLiveBypassViewDelegate <NSObject>

- (void)didConfirmExitBypassWithUid:(NSString *)uid;
- (void)switchMainScreenWithUid:(NSString *)uid;;

@end

@interface NTESLiveBypassView : UIView

@property (nonatomic, assign) BOOL isAnchor;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, weak) id<NTESLiveBypassViewDelegate> delegate;

@property (nonatomic, strong) UIView *localVideoDisplayView;

- (void)refresh:(NTESMicConnector *)connector status:(NTESLiveBypassViewStatus)status;

- (void)updateRemoteView:(NSData *)yuvData
                   width:(NSUInteger)width
                  height:(NSUInteger)height;

@end
