//
//  JHPublishReportTureFalseCell.h
//  TTjianbao
//
//  Created by wangjianios on 2021/3/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHPublishReportTrueFalseCell : JHWBaseTableViewCell

/// 1=真·不估价     2=真·估价  0=伪
@property (nonatomic, assign) NSInteger type;

/// 1=真·不估价     2=真·估价  0=伪
@property (nonatomic, copy) void (^clickBlock) (NSInteger type);

@end

NS_ASSUME_NONNULL_END
