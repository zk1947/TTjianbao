//
//  JHCustomizeChooseCategoryTitleBackgroundCellModel.h
//  TTjianbao
//
//  Created by user on 2020/12/5.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JXCategoryTitleCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeChooseCategoryTitleBackgroundCellModel : JXCategoryTitleCellModel
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
