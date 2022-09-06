//
//  JHStoneSoldSmallCollectionViewCell.h
//  TTjianbao
//
//  Created by jiang on 2019/12/4.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHLiveRoomMode.h"
#import "JHMainViewStoneResaleModel.h"
NS_ASSUME_NONNULL_BEGIN
#define StoneSmallCellImageRate (175/175)
@interface JHStoneSoldSmallCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong) JHMainViewStoneResaleModel* mode;
@property(nonatomic, copy)JHActionBlock clickAvatar;
@property(nonatomic, copy)  UIView * content;
@property(nonatomic, copy) JHActionBlocks clickFollow;
@end

NS_ASSUME_NONNULL_END
