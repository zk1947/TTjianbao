//
//  JHMallMoreCategoryTitleCell.h
//  TTjianbao
//
//  Created by lihui on 2020/10/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHMallCateModel;

static NSString *kMallCateTitleIdentifer = @"kMallCateTitleIdentifer";

@interface JHMallMoreCategoryTitleCell : UICollectionViewCell

@property (nonatomic, strong) JHMallCateModel *cateModel;

@end

NS_ASSUME_NONNULL_END
