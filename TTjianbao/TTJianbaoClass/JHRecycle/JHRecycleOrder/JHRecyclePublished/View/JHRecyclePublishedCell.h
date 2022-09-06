//
//  JHRecyclePublishedCell.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHRecyclePublishedModel;
@interface JHRecyclePublishedCell : UITableViewCell
@property (nonatomic, copy) void(^reloadDataBlock)(void);
@property (nonatomic, strong) JHRecyclePublishedModel *model;

/** 计时器跳动,刷新cell的时间*/
- (void)refreshTimerUI;

@end

NS_ASSUME_NONNULL_END
