//
//  JHPopDownTimeView.h
//  TTjianbao
//
//  Created by yaoyao on 2019/3/30.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHPopDownTimeView : BaseView
@property (nonatomic, assign) BOOL isSelected;
- (void)setWaitNum:(NSInteger)num waitSecond:(NSInteger)second;
@end

NS_ASSUME_NONNULL_END
