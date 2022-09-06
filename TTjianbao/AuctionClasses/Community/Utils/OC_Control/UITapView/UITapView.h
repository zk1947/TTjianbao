//
//  UITapView.h
//  TTjianbao
//
//  Created by wuyd on 2019/8/23.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITapView : UIView

- (void)addTapBlock:(void(^)(id obj))tapAction;

- (void)addTapBlock2:(void(^)(id obj, BOOL isLeft))tapAction2;

@end

NS_ASSUME_NONNULL_END
