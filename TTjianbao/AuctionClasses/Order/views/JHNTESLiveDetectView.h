//
//  JHNTESLiveDetectView.h
//  TTjianbao
//
//  Created by 张坤 on 2021/3/27.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JHNTESLiveDetectViewDelegate <NSObject>

- (void)backBarButtonPressed;

@end

@interface JHNTESLiveDetectView : BaseView
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIImageView *cameraImage;

@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;

@property (nonatomic, weak) id<JHNTESLiveDetectViewDelegate> LDViewDelegate;

- (id)initWithFrame:(CGRect)frame;

- (void)showActionTips:(NSString *)actions;

- (void)changeTipStatus:(NSDictionary *)infoDict;
@end

NS_ASSUME_NONNULL_END
