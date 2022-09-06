//
//  JHRecommendTopicTableCell.h
//  TTjianbao
//
//  Created by lihui on 2021/2/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
///社区首页 - 热门话题

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHTopicInfo;

@interface JHRecommendTopicTableCell : UITableViewCell

///需要展示的热门话题数据
@property (nonatomic, copy) NSArray <JHTopicInfo *>*topicArray;
///换一批
@property (nonatomic, copy) dispatch_block_t changeBlock;

+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
