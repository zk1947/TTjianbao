//
//  JHSendOrderProccessGoodCell.h
//  TTjianbao
//
//  Created by Jesse on 2019/11/14.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMode.h"

NS_ASSUME_NONNULL_BEGIN

#define kJHSendOrderProccessGoodCellHeight 142

@interface JHSendOrderProccessGoodCell : UITableViewCell

- (void)setData:(OrderMode*)model;//设置显示数据
@end

NS_ASSUME_NONNULL_END
