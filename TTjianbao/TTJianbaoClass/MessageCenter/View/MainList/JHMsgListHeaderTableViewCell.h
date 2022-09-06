//
//  JHMsgListHeaderTableViewCell.h
//  TTjianbao
//  Description:重要分类cell
//  Created by mac on 2019/5/27.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHMsgCenterModel.h"

#define kMsgListHeaderCellHeight (10+100+10)  //xib

NS_ASSUME_NONNULL_BEGIN

@interface JHMsgListHeaderTableViewCell : UITableViewCell

@property (nonatomic, copy) JHActionBlock actionBlock;

- (void) updateData:(NSMutableArray*)array unread:(id)model;
@end

NS_ASSUME_NONNULL_END
