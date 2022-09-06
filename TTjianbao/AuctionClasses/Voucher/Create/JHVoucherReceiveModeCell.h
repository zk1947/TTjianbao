//
//  JHVoucherReceiveModeCell.h
//  TTjianbao
//
//  Created by wuyd on 2020/3/7.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  领用方式
//

#import "YDBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const kCellId_JHVoucherReceiveModeCell = @"JHVoucherReceiveModeCellIdentifier";

@interface JHVoucherReceiveModeCell : YDBaseTableViewCell

@property (nonatomic, copy) void(^didSelectedBlock)(NSInteger index);

- (void)setTitle:(NSString *)title selectedIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
