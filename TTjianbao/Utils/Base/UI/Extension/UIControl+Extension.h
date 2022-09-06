//
//  UIControl+Extension.h
//  TTjianbao
//  Description:截获事件,解决点击问题
//  Created by Jesse on 2020/3/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (Extension)

@property (nonatomic, assign) NSTimeInterval eventInterval;
@end

NS_ASSUME_NONNULL_END
