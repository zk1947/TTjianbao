//
//  JHAppraiseOrderTableViewCell.h
//  TTjianbao
//
//  Created by jiang on 2019/10/22.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTjianbaoBussiness.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHAppraiseOrderTableViewCell : UITableViewCell
@property(strong,nonatomic)OrderMode * orderMode;
@property (nonatomic, copy) JHActionBlock finishBlock;
@property (nonatomic, strong)NSIndexPath *indexPath;
@end

NS_ASSUME_NONNULL_END
