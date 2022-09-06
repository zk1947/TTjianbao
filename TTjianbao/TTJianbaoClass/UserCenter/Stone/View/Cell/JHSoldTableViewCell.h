//
//  JHSoldTableViewCell.h
//  TTjianbao
//  Description:已售原石
//  Created by Jesse on 2019/11/27.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHCornerTableViewCell.h"
#import "JHUCSoldListModel.h"

#define kSoldTableCellHeight (172+10) //已售原石默认高度

NS_ASSUME_NONNULL_BEGIN

@interface JHSoldTableViewCell : JHCornerTableViewCell

- (void)updateCell:(JHUCSoldListModel*)model;
@end

NS_ASSUME_NONNULL_END
