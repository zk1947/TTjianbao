//
//  JHGraphic0rderInforView.h
//  TTjianbao
//
//  Created by miao on 2021/6/28.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface JHGraphic0rderInforView : UIView

/// 复制订单号
@property (nonatomic, copy) dispatch_block_t copyOrderNumberBlock;

/// 刷新视图
/// @param titles 订单信息
- (void)updateGraphic0rderInforView:(NSArray <NSString *> *)titles;

@end

NS_ASSUME_NONNULL_END
