//
//  UITapImageView.h
//  TTjianbao
//
//  Created by wuyd on 2019/8/22.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITapImageView : UIImageView

- (void)addTapBlock:(void(^)(id obj))tapAction;
- (void)setImageWithUrl:(NSURL *)imgUrl placeholderImage:(UIImage *)placeholderImage tapBlock:(void(^)(id obj))tapAction;

@end

NS_ASSUME_NONNULL_END
