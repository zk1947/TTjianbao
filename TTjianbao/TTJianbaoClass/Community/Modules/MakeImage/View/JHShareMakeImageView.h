//
//  JHShareMakeImageView.h
//  TTjianbao
//
//  Created by wangjianios on 2021/3/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHPostDetailModel;

@interface JHShareMakeImageView : UIView

+ (void)showWithModel:(JHPostDetailModel *)model;

@end

NS_ASSUME_NONNULL_END
