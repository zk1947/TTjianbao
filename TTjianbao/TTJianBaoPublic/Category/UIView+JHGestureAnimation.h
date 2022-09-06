//
//  UIView+JHGestureAnimation.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/8/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSUInteger, DraggingType) {
    DraggingTypeNormal,
    DraggingTypeLeft,
    DraggingTypeRight,
};

@interface UIView (JHGestureAnimation)

- (void)addPanGestureWithType : (DraggingType)type;
@end

NS_ASSUME_NONNULL_END
