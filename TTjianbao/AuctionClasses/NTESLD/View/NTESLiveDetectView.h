//
//  NTESLDView.h
//  NTESLiveDetectPublicDemo
//
//  Created by Ke Xu on 2019/10/14.
//  Copyright © 2019 Ke Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NTESLiveDetectViewDelegate <NSObject>

- (void)backBarButtonPressed;

- (void)playActionMusic:(AVAudioPlayer *)player;
@end

@interface NTESLiveDetectView : UIView

//@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIImageView *cameraImage;

@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;

@property (nonatomic, weak) id<NTESLiveDetectViewDelegate> LDViewDelegate;

- (void)showActionTips:(NSString *)actions;

- (void)changeTipStatus:(NSDictionary *)infoDict;

@end

NS_ASSUME_NONNULL_END

