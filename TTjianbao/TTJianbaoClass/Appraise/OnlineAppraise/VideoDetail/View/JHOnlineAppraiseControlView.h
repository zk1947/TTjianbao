//
//  JHOnlineAppraiseControlView.h
//  TTjianbao
//
//  Created by lihui on 2020/12/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ZFPlayer/ZFPlayerMediaControl.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHOnlineAppraiseControlView : UIView <ZFPlayerMediaControl>

///播放按钮
@property (nonatomic, strong) UIButton *playButton;

- (void)resetControlView;

- (void)showCoverViewWithUrl:(NSString *)coverUrl;

@end

NS_ASSUME_NONNULL_END
