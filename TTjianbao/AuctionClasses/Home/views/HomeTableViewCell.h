//
//  HomeTableViewCell.h
//  TTjianbao
//
//  Created by jiangchao on 2018/12/9.
//  Copyright © 2018 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHLiveRoomMode.h"

@interface HomeTableViewCell : UITableViewCell
@property(nonatomic,strong) JHLiveRoomMode* liveRoomMode;
@property(nonatomic, copy) JHActionBlock clickAvatar;
@end

