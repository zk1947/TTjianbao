//
//  JHMsgListTableViewCell.h
//  TTjianbao
//  Description:分类cell
//  Created by mac on 2019/5/27.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHMsgCenterModel.h"

#define kMsgListCellHeight (74.5+0.5) //xib

NS_ASSUME_NONNULL_BEGIN

@interface JHMsgListTableViewCell : UITableViewCell

@property (nonatomic, strong) JHMsgCenterModel *model;
@end

NS_ASSUME_NONNULL_END
