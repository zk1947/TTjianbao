//
//  JHMallTableViewCell.h
//  TTjianbao
//
//  Created by jiangchao on 2019/1/23.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHLiveRoomMode.h"

@interface JHMallTableViewCell : UICollectionViewCell
@property(nonatomic,strong) JHLiveRoomMode* liveRoomMode;
@property(nonatomic, copy) JHActionBlock clickAvatar;
@property(nonatomic, copy) JHActionBlocks clickFollow;
@property(nonatomic, copy)  UIView * content;

@end


