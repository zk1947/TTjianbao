//
//  JHTitleImageBackgroundView.h
//  TTjianbao
//
//  Created by lihui on 2020/7/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JXCategoryTitleImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHTitleImageBackgroundView : JXCategoryTitleImageView

@property (nonatomic, strong) UIColor *normalBackgroundColor;
@property (nonatomic, strong) UIColor *normalBorderColor;
@property (nonatomic, strong) UIColor *selectedBackgroundColor;
@property (nonatomic, strong) UIColor *selectedBorderColor;
@property (nonatomic, assign) CGFloat borderLineWidth;
@property (nonatomic, assign) CGFloat backgroundCornerRadius;
@property (nonatomic, assign) CGFloat backgroundWidth;
@property (nonatomic, assign) CGFloat backgroundHeight;

@end

NS_ASSUME_NONNULL_END
