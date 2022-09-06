//
//  JHPublishReportCateCollectionViewCell.h
//  TTjianbao
//
//  Created by wangjianios on 2021/3/4.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"

NS_ASSUME_NONNULL_BEGIN

@class JHReportCateModel;

@interface JHPublishReportCateCollectionViewCell : JHWBaseTableViewCell

@property (nonatomic, strong) NSMutableArray <JHReportCateModel *> *cateArray;

@property (nonatomic, copy) dispatch_block_t selectBlock;

@end

NS_ASSUME_NONNULL_END
