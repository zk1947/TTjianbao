//
//  JHNewStoreHomeCategoryMallCollectionViewCell.h
//  TTjianbao
//
//  Created by user on 2021/3/30.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHMallCategoryModel;

@interface JHNewStoreHomeCategoryMallCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) JHMallCategoryModel *cateModel;
+ (CGSize)viewSize;
@end

NS_ASSUME_NONNULL_END

