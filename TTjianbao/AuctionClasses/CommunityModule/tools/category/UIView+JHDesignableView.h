//
//  UIView+JHDesignableView.h
//  TTjianbao
//
//  Created by mac on 2019/5/13.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
IB_DESIGNABLE
@interface UIView (JHDesignableView)
@property(nonatomic,assign) IBInspectable CGFloat cornerRadius;
@property(nonatomic,assign) IBInspectable CGFloat borderWidth;
@property(nonatomic,assign) IBInspectable UIColor *borderColor;
@end

NS_ASSUME_NONNULL_END
