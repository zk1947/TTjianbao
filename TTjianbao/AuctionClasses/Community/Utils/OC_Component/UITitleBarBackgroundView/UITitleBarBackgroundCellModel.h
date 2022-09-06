//
//  UITitleBarBackgroundCellModel.h
//  TTjianbao
//
//  Created by wuyd on 2020/3/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JXCategoryTitleCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UITitleBarBackgroundCellModel : JXCategoryTitleCellModel

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
