//
//  JHStoreHomeListCell.h
//  TTjianbao
//
//  Created by wuyd on 2019/11/21.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//  默认<专题>样式Cell
//

#import "YDBaseTableViewCell.h"
@class CStoreHomeListData;

NS_ASSUME_NONNULL_BEGIN

static NSString *const kCellId_JHStoreHomeListCell = @"JHStoreHomeListCellIdentifier";

@interface JHStoreHomeListCell : YDBaseTableViewCell

@property (nonatomic, copy) void(^selectedBlock)(CStoreHomeListData *data);
@property (nonatomic, copy) void(^countDownEndBlock)(CStoreHomeListData *data);

@property (nonatomic, assign) BOOL isLastCell; //是否是当前页最后一条数据
@property (nonatomic, strong) CStoreHomeListData *curData;

+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
