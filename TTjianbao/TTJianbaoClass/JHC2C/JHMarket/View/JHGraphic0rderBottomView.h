//
//  JHGraphic0rderBottomView.h
//  TTjianbao
//
//  Created by miao on 2021/7/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JHGraphicalBottomModel;

typedef void(^ClickBlock)(JHGraphicalBottomModel * _Nullable model);

NS_ASSUME_NONNULL_BEGIN

@interface JHGraphic0rderBottomView : UIView

/// button 的点击
@property (copy, nonatomic) ClickBlock buttonBlock;
/// 刷新数据
/// @param buttons buttons
- (void)updateGraphicBottom:(NSArray <JHGraphicalBottomModel *> *)buttons;

@end

NS_ASSUME_NONNULL_END
