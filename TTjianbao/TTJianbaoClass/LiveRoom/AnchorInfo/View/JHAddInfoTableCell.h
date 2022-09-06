//
//  JHAddInfoTableCell.h
//  TTjianbao
//
//  Created by lihui on 2020/7/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const kAddInfoIdentifer = @"JHAddInfoTableCellIdentifer";

@interface JHAddInfoTableCell : UITableViewCell

@property (nonatomic, copy) void(^editBlock)(void);

@end

NS_ASSUME_NONNULL_END
