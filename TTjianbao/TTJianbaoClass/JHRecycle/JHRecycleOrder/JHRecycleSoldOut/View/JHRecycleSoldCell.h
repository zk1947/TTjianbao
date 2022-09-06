//
//  JHRecycleSoldCell.h
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHRecycleSoldModel;
@interface JHRecycleSoldCell : UITableViewCell

@property (nonatomic, strong) JHRecycleSoldModel *model;
/** 刷新单条数据*/
@property (nonatomic, copy) void(^reloadCellDataBlock)(BOOL iSdelete);

/** 计时器跳动,刷新cell的时间*/
- (void)refreshTimerUI;
@end

NS_ASSUME_NONNULL_END
