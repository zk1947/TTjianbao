//
//  JHStoneResaleBigCollectionViewCell.h
//  TTjianbao
//
//  Created by jiang on 2019/11/29.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHLiveRoomMode.h"
#import "JHMainViewStoneResaleModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface JHStoneResaleBigCollectionViewCell : UICollectionViewCell
@property (nonatomic, assign) BOOL resaleFlag;//是否是个人转售
@property(nonatomic,strong) JHMainViewStoneResaleModel* mode;
@property(nonatomic, copy) JHActionBlock clickAvatar;
@property(nonatomic, copy) JHActionBlocks clickFollow;
@property(nonatomic, copy)  UIView * content;
@end

NS_ASSUME_NONNULL_END
