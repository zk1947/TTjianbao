//
//  JHMallSmallCollectionViewCell.h
//  TaodangpuAuction
//
//  Created by mac on 2019/8/22.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHLiveRoomMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMallSmallCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong) JHLiveRoomMode* liveRoomMode;
@property(nonatomic, copy) JHActionBlock clickAvatar;
@property(nonatomic, copy)  UIView * content;
@property(nonatomic, copy) JHActionBlocks clickFollow;

@end

NS_ASSUME_NONNULL_END
