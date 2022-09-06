//
//  JHPublishReportFalseCell.h
//  TTjianbao
//
//  Created by wangjianios on 2021/3/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHPublishReportFalseCell : JHWBaseTableViewCell

///不估价理由回调
@property (nonatomic, copy) void (^clickBlock) (NSString *reason);

///不估价理由
@property (nonatomic, strong) NSMutableArray *reasonArray;

- (void)reset;

@end

NS_ASSUME_NONNULL_END
