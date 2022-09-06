//
//  JHStoneResaleLiveCollectionViewCell.h
//  TTjianbao
//
//  Created by jiang on 2019/12/1.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHLiveRoomMode.h"
//回血直播间cell高度（固定高度）
#define ResaleRoomBigCellImageRate (355./225.f)
#define kResaleRoomTableCellHeight ((ScreenW - 20)/ResaleRoomBigCellImageRate)
@interface JHStoneResaleLiveCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong) JHLiveRoomMode* liveRoomMode;
@property(nonatomic, copy) JHActionBlock clickAvatar;
@property(nonatomic, copy) JHActionBlocks clickFollow;
@property(nonatomic, copy)  UIView * content;
@end
