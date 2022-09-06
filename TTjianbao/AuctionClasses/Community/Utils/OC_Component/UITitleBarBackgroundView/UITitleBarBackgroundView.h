//
//  UITitleBarBackgroundView.h
//  TTjianbao
//
//  Created by wuyd on 2020/3/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  cell带背景色的 JXCategoryTitleView
//

#import "JXCategoryTitleView.h"
#import "UITitleBarBackgroundCell.h"
#import "UITitleBarBackgroundCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UITitleBarBackgroundView : JXCategoryTitleView

@property (nonatomic, strong) UIColor *normalBgColor;
@property (nonatomic, strong) UIColor *normalBorderColor;
@property (nonatomic, strong) UIColor *selectedBgColor;
@property (nonatomic, strong) UIColor *selectedBorderColor;
@property (nonatomic, assign) CGFloat borderLineWidth;
@property (nonatomic, assign) CGFloat bgCornerRadius;
@property (nonatomic, assign) CGFloat bgWidth;
@property (nonatomic, assign) CGFloat bgHeight;

@end

NS_ASSUME_NONNULL_END
