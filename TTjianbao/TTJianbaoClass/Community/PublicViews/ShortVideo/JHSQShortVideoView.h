//
//  JHSQShortVideoView.h
//  TTjianbao
//
//  Created by wuyd on 2020/6/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHVideoInfo;

NS_ASSUME_NONNULL_BEGIN

@interface JHSQShortVideoView : UIView

@property (nonatomic, copy) dispatch_block_t clickPlayBlock;

@property (nonatomic, strong) JHVideoInfo *videoInfo;

+ (CGFloat)viewHeight;

@end

NS_ASSUME_NONNULL_END
