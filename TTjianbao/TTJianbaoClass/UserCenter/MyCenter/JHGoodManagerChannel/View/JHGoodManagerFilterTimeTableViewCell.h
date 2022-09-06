//
//  JHGoodManagerFilterTimeTableViewCell.h
//  TTjianbao
//
//  Created by user on 2021/8/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHGoodManagerFilterTimeTableViewCell : UITableViewCell
@property (nonatomic, copy) dispatch_block_t timePickerDidClickedBlock;
- (void)resetAllStatus;
@end

NS_ASSUME_NONNULL_END
