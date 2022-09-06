//
//  JHPlayerControlView.h
//  TTjianbao
//
//  Created by yaoyao on 2019/4/12.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZFPlayerControlView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHPlayerControlView : ZFPortraitControlView <ZFPlayerMediaControl>
@property (nonatomic, copy, nullable) void(^sliderValueChange)(CGFloat value);
@property (nonatomic, copy, nullable) void(^doubleTapBack)(void);
@property (nonatomic, copy, nullable) void(^singleTapBack)(BOOL isAppear);

@property (nonatomic, copy, nullable) void(^hiddenCover)(BOOL isHidden);
/// 封面图
@property (nonatomic, strong) UIImageView *coverImageView;

- (void)showCoverViewWithUrl:(NSString *)coverUrl;

@end

NS_ASSUME_NONNULL_END
