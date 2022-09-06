//
//  JHMallCategoryCollectionCell.h
//  TTjianbao
//
//  Created by lihui on 2020/12/6.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
///直播购物首页 - 金刚位部分：分类listcell

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHMallCategoryModel;

@interface JHMallCategoryCollectionCell : UICollectionViewCell

@property (nonatomic, strong) JHMallCategoryModel *cateModel;

+ (CGSize)viewSize;
@end

NS_ASSUME_NONNULL_END
