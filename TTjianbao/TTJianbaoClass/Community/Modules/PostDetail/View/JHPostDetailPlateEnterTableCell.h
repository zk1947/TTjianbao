//
//  JHPostDetailPlateEnterTableCell.h
//  TTjianbao
//
//  Created by lihui on 2020/9/1.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
/// 社区详情页 - 板块入口cell

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHPostDetailModel;

static NSString * const kPostDetailPlateEnterCellIdentifer = @"JHPostDetailPlateEnterTableCellIdentifer";

@interface JHPostDetailPlateEnterTableCell : UITableViewCell

@property (nonatomic, strong) JHPostDetailModel *detailModel;

@end

NS_ASSUME_NONNULL_END
