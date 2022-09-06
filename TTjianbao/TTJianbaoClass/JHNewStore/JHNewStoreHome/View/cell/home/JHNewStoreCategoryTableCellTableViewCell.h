//
//  JHNewStoreCategoryTableCellTableViewCell.h
//  TTjianbao
//
//  Created by user on 2021/2/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHMallCategoryModel;

@interface JHNewStoreCategoryTableCellTableViewCell : UITableViewCell
@property (nonatomic, copy) NSArray <JHMallCategoryModel *>*categoryInfos;
+ (CGFloat)viewHeight;
@end

NS_ASSUME_NONNULL_END
