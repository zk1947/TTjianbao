//
//  JHMyCompeteGoodsTagView.h
//  TTjianbao
//
//  Created by miao on 2021/6/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHMyCompeteGoodsTagView : UIView

/// 刷新标签的视图
/// @param titles 标签数组
- (void)reloadCompeteGoodsTagView:(NSArray <NSString *> *)titles;

@end

NS_ASSUME_NONNULL_END
