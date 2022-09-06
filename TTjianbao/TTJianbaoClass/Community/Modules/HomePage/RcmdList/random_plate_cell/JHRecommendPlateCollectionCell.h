//
//  JHRecommendPlateCollectionCell.h
//  TTjianbao
//
//  Created by lihui on 2020/11/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
///社区推荐页 - 推荐版块cell部分 355新增

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const kRecommendPlateCollectionIdentifer = @"kJHRecommendPlateCollectionCellIdentifer";
@class JHPlateListData;
@interface JHRecommendPlateCollectionCell : UICollectionViewCell

///需要展示的版块信息 每组数据最多有3条
@property (nonatomic, copy) NSArray <JHPlateListData *>*plateInfos;

@end

NS_ASSUME_NONNULL_END
