//
//  JHLaunchGuideView.h
//  TTjianbao
//  Description:app launch guide
//  Created by Jesse on 11/5/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JHLaunchGuideViewDelegate <NSObject>

- (void)setupHomeViewController;

@end

@interface JHLaunchGuideView : UIView

@property (nonatomic, weak) id<JHLaunchGuideViewDelegate>delegate;

- (void)showView;
- (void)showAlertFromFirstLaunch:(BOOL)fromFirstLaunch;
@end

NS_ASSUME_NONNULL_END
