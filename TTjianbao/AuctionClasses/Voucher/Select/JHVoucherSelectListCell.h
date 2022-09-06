//
//  JHVoucherSelectListCell.h
//  TTjianbao
//
//  Created by wuyd on 2020/3/2.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "YDBaseTableViewCell.h"
#import "JHVoucherListModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const kCellId_JHVoucherSelectListCell = @"JHVoucherSelectListCellIdentifier";

@interface JHVoucherSelectListCell : YDBaseTableViewCell

@property (nonatomic, copy) void(^cellClickBlock)(JHVoucherSelectListCell *curCCell, JHVoucherListData *data); //点击cell

@property (nonatomic, strong) JHVoucherListData *curData;

+ (CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
