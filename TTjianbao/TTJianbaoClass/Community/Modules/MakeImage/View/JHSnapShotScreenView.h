//
//  JHSnapShotScreenView.h
//  TTjianbao
//
//  Created by wangjianios on 2021/3/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHPostDetailModel;

@interface JHSnapShotScreenView : UIView

+ (JHSnapShotScreenView *)makeImageWithModel:(JHPostDetailModel *)model complete:(void (^) (UIImage *image, UIView *currentView))complete;

@end

NS_ASSUME_NONNULL_END
