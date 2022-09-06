//
//  UIView+SGFrame.h
//  TTjianbao
//
//  Created by YJ on 2020/12/5.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIView (SGFrame)

@property (nonatomic, assign) CGFloat SG_x;
@property (nonatomic, assign) CGFloat SG_y;
@property (nonatomic, assign) CGFloat SG_width;
@property (nonatomic, assign) CGFloat SG_height;
@property (nonatomic, assign) CGFloat SG_centerX;
@property (nonatomic, assign) CGFloat SG_centerY;
@property (nonatomic, assign) CGPoint SG_origin;
@property (nonatomic, assign) CGSize SG_size;

+ (instancetype)SG_loadViewFromXib;

@end
