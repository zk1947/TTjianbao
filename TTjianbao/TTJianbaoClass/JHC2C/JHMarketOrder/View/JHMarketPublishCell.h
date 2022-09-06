//
//  JHMarketPublishCell.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHIssueGoodsEditModel.h"

NS_ASSUME_NONNULL_BEGIN
@class JHMarketPublishModel;

typedef void(^IssueEditBlock)(JHIssueGoodsEditModel *model);

@interface JHMarketPublishCell : UITableViewCell
@property (nonatomic, strong) JHMarketPublishModel *publishModel;
/** 刷新单条数据*/
@property (nonatomic, copy) void(^reloadCellDataBlock)(BOOL iSdelete);
/** 计时器跳动,刷新cell的时间*/
- (void)refreshTimerUI;

@property (nonatomic, copy) IssueEditBlock issueEditBlock;

@end

NS_ASSUME_NONNULL_END
