//
//  JHSuccessTipView.h
//  TTjianbao
//
//  Created by 张坤 on 2021/3/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^JHSuccessTipViewBlock)(UIButton *btn); /// 倒计时结束
@interface JHSuccessTipView : BaseView
@property(nonatomic, copy) JHSuccessTipViewBlock successTipViewBlock;

- (instancetype)initWithTitle:(NSString *)title des:(NSString *)des imageStr:(NSString *)imageStr btnTitle:(NSString *)btnTitle;
@end

NS_ASSUME_NONNULL_END
