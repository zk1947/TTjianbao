//
//  JHBillTotalTableViewCell.h
//  TTjianbao
//
//  Created by apple on 2019/12/16.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHBillTotalTableViewCell : JHWBaseTableViewCell

@property (nonatomic, strong) UIButton *iconButton;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *moneyLabel;

@property (nonatomic, copy) dispatch_block_t tipActionBlock;

@end

NS_ASSUME_NONNULL_END
