//
//  JHStoreDetailFunctionView.h
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
//  Describe : 功能区（店铺、客服、收藏、购买）

#import <UIKit/UIKit.h>
#import "JHStoreDetailFunctionViewModel.h"

NS_ASSUME_NONNULL_BEGIN


@interface JHStoreDetailFunctionView : UIView
///收藏按钮点击回调
@property (nonatomic, copy) JHFinishBlock collectButtonClickBlock;

/// 初始化
- (instancetype)initWithViewModel : (JHStoreDetailFunctionViewModel *)viewModel;
@end

NS_ASSUME_NONNULL_END
