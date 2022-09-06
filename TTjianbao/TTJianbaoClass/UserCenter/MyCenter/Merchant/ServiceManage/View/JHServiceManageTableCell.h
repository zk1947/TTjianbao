//
//  JHServiceManageTableCell.h
//  TTjianbao
//
//  Created by zk on 2021/7/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHServiceManageModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JHServiceManageTableCellDelegate <NSObject>

- (void)selectCell:(JHServiceManageItemModel *)model;

@end

@interface JHServiceManageTableCell : UITableViewCell

@property (nonatomic, weak) id delegate;

@property (nonatomic, strong) JHServiceManageItemModel *model;

/**
 1- 添加 可编辑
 2- 审核通过、审核拒绝 选中可编辑，非选中的不可编辑
 3- 审核中 均不可编辑
 */
@property (nonatomic, assign) int editIndex;//是否可编辑

@end

NS_ASSUME_NONNULL_END
