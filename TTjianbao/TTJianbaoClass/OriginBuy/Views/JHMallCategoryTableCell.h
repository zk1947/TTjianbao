//
//  JHMallCategoryTableCell.h
//  TTjianbao
//
//  Created by lihui on 2020/12/6.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
///直播购物首页 - 金刚位部分：分类

#import "JHMallBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class JHMallCategoryModel;

@interface JHMallCategoryTableCell : JHMallBaseTableViewCell

@property (nonatomic, copy) NSArray <JHMallCategoryModel *>*categoryInfos;

+ (CGFloat)viewHeight;

@end

NS_ASSUME_NONNULL_END
