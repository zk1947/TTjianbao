//
//  JHAllowanceListCell.h
//  TTjianbao
//
//  Created by apple on 2020/2/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"

#import "JHAllowanceListModel.h"

NS_ASSUME_NONNULL_BEGIN
/// 津贴 列表 cell
@interface JHAllowanceListCell : JHWBaseTableViewCell

@property (nonatomic, strong) JHAllowanceListModel *model;

@end

NS_ASSUME_NONNULL_END
