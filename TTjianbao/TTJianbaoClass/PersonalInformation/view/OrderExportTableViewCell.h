//
//  OrderExportTableViewCell.h
//  TTjianbao
//
//  Created by jiang on 2019/8/27.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExportOrderMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface OrderExportTableViewCell : UITableViewCell
@property(strong,nonatomic)ExportOrderMode * mode;
@property(strong,nonatomic)NSIndexPath * indexPath;
@property (nonatomic, copy) JHActionBlock buttonClick;
@end

NS_ASSUME_NONNULL_END
