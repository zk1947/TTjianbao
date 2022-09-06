//
//  JHDotButtonView.h
//  TTjianbao
//
//  Created by yaoyao on 2019/12/1.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHDoteNumberLabel.h"
#import "BaseView.h"


typedef NS_ENUM(NSInteger, JHDotButtonType) {
    JHDotButtonTypeNone,
    JHDotButtonTypeCicle,
    JHDotButtonTypeLeftCorner,
};
NS_ASSUME_NONNULL_BEGIN

@interface JHDotButtonView : UIControl
@property (nonatomic, strong) JHDoteNumberLabel *dotLabel;
@property (nonatomic, strong) UIButton *button;


///0任意图片按钮 红点在右上角 1 btn圆圈 红点在右上角  2 左边圆角 右边直角 红点在左上角
@property (nonatomic, assign) JHDotButtonType type;

@end

NS_ASSUME_NONNULL_END
