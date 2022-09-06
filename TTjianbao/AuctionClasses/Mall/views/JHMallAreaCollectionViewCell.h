//
//  JHMallSpecialAreaTableViewCell.h
//  TaodangpuAuction
//
//  Created by 姜超 on 2020/4/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHMallSpecialAreaModel.h"
#define imageRate (float)124/118
NS_ASSUME_NONNULL_BEGIN
static NSString *const kCellId_JHMallSpecialAreaId = @"kCellId_JHMallSpecialAreaIdentifier";
@interface JHMallAreaCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong) JHMallSpecialAreaModel *specialAreaMode;

@end

NS_ASSUME_NONNULL_END
