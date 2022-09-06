//
//  MallAttentionTableViewCell.h
//  TTjianbao
//
//  Created by jiang on 2019/8/22.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHLiveRoomMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface MallAttentionTableViewCell : UITableViewCell
@property(nonatomic,strong) NSMutableArray<JHLiveRoomMode *> * attentionModes;
@end

NS_ASSUME_NONNULL_END
