//
//  JHPublishReportRecommendCell.h
//  TTjianbao
//
//  Created by wangjianios on 2021/3/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHPublishReportRecommendCell : JHWBaseTableViewCell

@property (nonatomic, copy) void (^switchBlock) (BOOL isRecommend);

@property (nonatomic, assign) BOOL lineHidden;

@property (nonatomic, assign) BOOL isRecommend;
@end

NS_ASSUME_NONNULL_END
