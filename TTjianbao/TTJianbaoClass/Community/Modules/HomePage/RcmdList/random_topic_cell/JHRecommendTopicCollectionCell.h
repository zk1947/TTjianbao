//
//  JHRecommendTopicCollectionCell.h
//  TTjianbao
//
//  Created by lihui on 2021/2/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
///社区首页 - 热门话题

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHTopicInfo;

static NSString *const kJHRecommendTopicCollectionCellIdentifer = @"kJHRecommendTopicCollectionCellIdentifer";


@interface JHRecommendTopicCollectionCell : UICollectionViewCell

///需要展示的版块信息 每组数据最多有3条
@property (nonatomic, copy) NSArray <JHTopicInfo *>*topicArray;


@end

NS_ASSUME_NONNULL_END
