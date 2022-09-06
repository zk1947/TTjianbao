//
//  JHCustomerFeeEditCell.h
//  TTjianbao
//
//  Created by wangjianios on 2020/9/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseListView.h"
#import "JHCustomerFeeEditModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomerFeeEditCell : JHWBaseTableViewCell

@property (nonatomic, strong) JHCustomerFeeEditModel *model;

@property (nonatomic, copy) dispatch_block_t resetBlock;

@end

NS_ASSUME_NONNULL_END

