//
//  JHAppraisePayView.h
//  TTjianbao
//
//  Created by jiangchao on 2021/6/8.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHAppraisePayView : BaseView
- (void)showAlert;
- (void)hiddenAlert;
@property(strong,nonatomic) NSString* orderId;
@property(copy,nonatomic) JHFinishBlock paySuccessBlock;
@property (nonatomic, copy) NSString *from;

/// 视图隐藏或者移除回调
@property(copy,nonatomic) JHFinishBlock hiddenBlock;

@end

NS_ASSUME_NONNULL_END
