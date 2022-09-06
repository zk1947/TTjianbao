//
//  JHBuyAppraiseTVBoxView.h
//  TTjianbao
//
//  Created by wangjianios on 2020/12/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHBuyAppraiseTVBoxView : UIView

///忽略页面变换
@property (nonatomic, assign) BOOL ignoreChange;

/// 直播或者回放载体
@property (nonatomic, weak) UIView *livingContentView;

/// 直播或者回放封面
@property (nonatomic, weak) UIImageView *coverImageView;

/// 播放状态 View
@property (nonatomic, weak) UIImageView *playStatusView;


@property (nonatomic, copy) dispatch_block_t switchPlayBlock;

@property (nonatomic, copy) dispatch_block_t switchToHeaderBlock;

+ (instancetype)shareInstance;

@end

NS_ASSUME_NONNULL_END
