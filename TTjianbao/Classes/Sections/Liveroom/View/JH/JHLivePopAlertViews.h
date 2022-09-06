//
//  JHLivePopAlertViews.h
//  TTjianbao
//
//  Created by yaoyao on 2018/12/10.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTESLiveViewDefine.h"
#import "NTESLiveActionView.h"
#import "NTESVideoQualityView.h"

#import "BaseView.h"

@interface JHLivePopAlertViews : BaseView

+ (JHLivePopAlertViews *)moreListAlert;
+ (JHLivePopAlertViews *)hdAlert;

@property (nonatomic, weak) id<NTESLiveActionViewDelegate> delegate;
@property (nonatomic, weak) id<NTESVideoQualityViewDelegate> qualityDelegate;

- (void)showAlert;
- (void)hiddenAlert;
@end

