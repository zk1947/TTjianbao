//
//  JHTopicSearchResultCell.h
//  TTjianbao
//
//  Created by wuyd on 2019/7/31.
//  Copyright © 2019 Netease. All rights reserved.
//  话题选择 - 搜索结果cell
//

#import "YDBaseTableViewCell.h"
@class CTopicData;

NS_ASSUME_NONNULL_BEGIN

static NSString * const kCellId_JHTopicSearchResultCell = @"JHTopicSearchResultCellIdentifier";

@interface JHTopicSearchResultCell : YDBaseTableViewCell

+ (CGFloat)cellHeight;

@property (nonatomic, strong) CTopicData *curData;

@end

NS_ASSUME_NONNULL_END
