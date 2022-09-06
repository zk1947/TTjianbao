//
//  JHNewStroeRankCategoryView.h
//  TTjianbao
//
//  Created by lihui on 2021/2/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JXCategoryTitleView.h"
#import "JHNewStoreCategoryCell.h"
#import "JHNewStoreCategoryCellModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHNewStroeRankCategoryView : JXCategoryTitleView

//数据源
@property (nonatomic, strong) NSArray <NSString *>*dataList;
///标题颜色 默认白色
@property (nonatomic, strong) UIColor *normalTitleColor;
///选中标题颜色 默认白色
@property (nonatomic, strong) UIColor *selectTitleColor;
///左侧指示图标
@property (nonatomic, copy) NSString *leftIndicatorImage;
///右侧指示图标
@property (nonatomic, copy) NSString *rightIndicatorImage;
///cell的背景色 默认为透明色
@property (nonatomic, strong) UIColor *cellBackgroundColor;

@end

NS_ASSUME_NONNULL_END
