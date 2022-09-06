//
//  JHMallSpecialAreaCollectionViewCell.h
//  TTjianbao
//
//  Created by jiang on 2020/4/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHMallSpecialAreaModel.h"
#import "JHMallOperationModel.h"
#import <SVGAPlayer.h>
#define imageRate (float)124/118
NS_ASSUME_NONNULL_BEGIN
static NSString *const kCellId_JHMallSpecialAreaId = @"kCellId_JHMallSpecialAreaIdentifier";
@interface JHMallSpecialAreaCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong) JHOperationImageModel *specialAreaMode;

///svga 播放器
@property (nonatomic, strong) SVGAPlayer *player;

@end

NS_ASSUME_NONNULL_END
