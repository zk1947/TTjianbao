//
//  JHPublishReportRecommendCollectionViewCell.h
//  TTjianbao
//
//  Created by wangjianios on 2021/3/4.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"
@class JHReportRecommendLabelModel;

NS_ASSUME_NONNULL_BEGIN

@interface JHPublishReportRecommendCollectionViewCell : JHWBaseTableViewCell

@property (nonatomic, strong) NSMutableArray <JHReportRecommendLabelModel *> *recommendArray;

@property (nonatomic, assign) BOOL lineHidden;

@end

NS_ASSUME_NONNULL_END
