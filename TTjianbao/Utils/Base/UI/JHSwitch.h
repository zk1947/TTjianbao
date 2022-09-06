//
//  JHSwitch.h
//  TTjianbao
//  Description:自定义switch大小、颜色
//  Created by Jesse on 2020/3/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHSwitch : UISwitch

//初始化设置宽高
- (instancetype)initWithSize:(CGSize)size;
//设置缩放后的左右偏移
- (CGFloat)leftRightOffset:(CGFloat)offset;
//设置缩放前后的上下偏移
- (CGFloat)topBottomOffset:(CGFloat)offset;

@end

NS_ASSUME_NONNULL_END
