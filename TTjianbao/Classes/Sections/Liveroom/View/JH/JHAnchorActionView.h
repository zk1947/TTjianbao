//
//  JHAnchorActionView.h
//  TTjianbao
//
//  Created by yaoyao on 2018/12/24.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTESLiveViewDefine.h"
#import "NTESLiveActionView.h"
#import "NTESVideoQualityView.h"
#import "BaseView.h"

extern CGFloat const ButtonHeight;
extern NSInteger const ButtonCount;

@interface JHAnchorActionView : BaseView

@property (nonatomic, weak) id<NTESLiveActionViewDelegate> delegate;
@property (nonatomic, strong) UIButton *pxBtn;
- (void)updateQuality;

@property (nonatomic, strong) UIButton *sendRedpacketBtn;
@property (nonatomic, strong) UIButton *guessBtn;
@property (nonatomic, strong) UIButton *muteBtn;
@property (nonatomic, strong) UIButton *camaraBtn;
@property (nonatomic, strong) UIButton *lightBtn;
@property (nonatomic, strong) UIButton *muteListBtn;

@end

@interface JHSaleAnchorActionView : BaseView

@property (nonatomic, weak) id<NTESLiveActionViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray * btnArray;

/**
 showtype  2  助理  1主播
 canshow  是否显示开播提醒按钮
 */

- (void)resetActionView:(NSInteger)showtype andShowSendLivingTip:(BOOL)canshow;
@end
