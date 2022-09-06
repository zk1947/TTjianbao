//
//  JXCategoryTitleBackgroundView.h
//  JXCategoryView
//
//  Created by jiaxin on 2019/8/16.
//  Copyright © 2019 jiaxin. All rights reserved.
//

#import "JXCategoryTitleView.h"
#import "JXCategoryTitleBackgroundCellModel.h"
#import "JXCategoryTitleBackgroundCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JXCategoryTitleBackgroundView : JXCategoryTitleView
///默认Title背景颜色
@property (nonatomic, strong) UIColor *normalBackgroundColor;

///默认Title背景Border颜色
@property (nonatomic, strong) UIColor *normalBorderColor;

///选中Title背景颜色
@property (nonatomic, strong) UIColor *selectedBackgroundColor;

///选中Title背景Border颜色
@property (nonatomic, strong) UIColor *selectedBorderColor;

///Border宽度
@property (nonatomic, assign) CGFloat borderLineWidth;

///Border圆角
@property (nonatomic, assign) CGFloat backgroundCornerRadius;

///背景宽度
@property (nonatomic, assign) CGFloat backgroundWidth;

///背景高度
@property (nonatomic, assign) CGFloat backgroundHeight;

@end

NS_ASSUME_NONNULL_END
