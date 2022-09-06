//
//  JHGoodManagerFilterCagetoryTableViewCell.h
//  TTjianbao
//
//  Created by user on 2021/8/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHGoodManagerFilterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHGoodManagerFilterCagetoryTableViewCell : UITableViewCell
@property (nonatomic, copy) dispatch_block_t didSelectBlock;
- (void)setViewModel:(JHGoodManagerFilterModel *)cagetory;
- (void)setTitleLabelBackgroundColorSelect:(BOOL)select;
- (void)resetAllTitleLabelStatus;
@end

NS_ASSUME_NONNULL_END
