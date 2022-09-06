//
//  JHOffSaleTableViewCell.h
//  TTjianbao
//
//  Created by Jesse on 2019/11/30.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHCornerTableViewCell.h"
#import "JHOffSaleGoodsModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHOffSaleTableViewCell : JHCornerTableViewCell

- (void)updateCell:(JHOffSaleGoodsModel*)model;
@end

NS_ASSUME_NONNULL_END
