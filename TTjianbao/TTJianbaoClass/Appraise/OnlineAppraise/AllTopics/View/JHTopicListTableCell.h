//
//  JHTopicListTableCell.h
//  TTjianbao
//
//  Created by lihui on 2020/12/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
///全部鉴定师部分 - 鉴定师信息展示的cell

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHOnlineAppraiseModel;
static NSString *const kJHTopicListTableCellIdentifer = @"kJHTopicListTableCellIdentifer";

@interface JHTopicListTableCell : UITableViewCell

@property (nonatomic, strong) JHOnlineAppraiseModel *appraiseModel;


@end

NS_ASSUME_NONNULL_END
