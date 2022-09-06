//
//  JHBadgeControl.h
//  TTjianbao
//
//  Created by wuyd on 2020/4/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define kBadgeDotHeight     (7.0)
#define kBadgeHeightDefault (16.0)
#define kBadgeColorDefault  [UIColor colorWithRed:255/255.0 green:66/255.0 blue:0/255.0 alpha:1] //#FF4200

typedef NS_ENUM(NSUInteger, JHBadgeFlexMode) {
    JHBadgeFlexModeLeft = 0,    /*! 向左伸缩：<==● */
    JHBadgeFlexModeRight,       /*! 向右伸缩     : ●==> */
    JHBadgeFlexModeMiddle       /*! 左右伸缩 : <=●=> */
};

@interface JHBadgeControl : UIControl

+ (instancetype)defaultBadge;

@property (nonatomic, strong) UIFont *font;
@property (nonatomic,   copy, nullable) NSString *text;
@property (nonatomic, strong, nullable) NSAttributedString *attributedText;
@property (nonatomic, strong, nullable) UIImage *backgroundImage;

///记录Badge的偏移量
@property (nonatomic, assign) CGPoint offset;

///Badge伸缩的方向，默认 JHBadgeFlexModeRight
@property (nonatomic, assign) JHBadgeFlexMode flexMode;

@end

NS_ASSUME_NONNULL_END
