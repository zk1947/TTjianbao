//
//  JHUCOnSaleTableViewCell.h
//  TTjianbao
//  Description:UserCenter在售原石
//  Created by Jesse on 2019/11/30.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHOnSaleTableViewCell.h"
#import "JHUCOnSaleListModel.h"
#import "JHLastSaleTableViewCell.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHUCOnSaleTableViewCell : JHOnSaleTableViewCell

- (void)updateCell:(JHUCOnSaleListModel*)model;

@end

NS_ASSUME_NONNULL_END
