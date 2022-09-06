//
//  NTESLiveActionView.h
//  TTjianbao
//
//  Created by chris on 16/3/29.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTESLiveViewDefine.h"

@protocol NTESLiveActionViewDelegate <NSObject>

- (void)onActionType:(NTESLiveActionType)type sender:(id)sender;

@end

#import "BaseView.h"

@interface NTESLiveActionView : BaseView

@property (nonatomic,weak) id<NTESLiveActionViewDelegate> delegate;

- (void)setActionType:(NTESLiveActionType)type disable:(BOOL)disable;

- (void)updateInteractButton:(NSInteger)count;

- (void)firstLineViewMoveToggle:(BOOL)isMoveUp;

- (void)updateFocusButton:(BOOL)isOn;

- (void)updateflashButton:(BOOL)isOn;

- (void)updateMirrorButton:(BOOL)isOn;

- (void)updateBeautify:(BOOL)isBeautify;

- (void)updateQualityButton:(BOOL)isHigh;

- (void)updateWaterMarkButton:(BOOL)isOn;

@end
