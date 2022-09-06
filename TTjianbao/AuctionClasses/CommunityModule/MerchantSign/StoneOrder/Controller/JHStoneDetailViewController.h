//
//  JHStoneDetailViewController.h
//  TaodangpuAuction
//
//  Created by apple on 2019/11/7.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHTableViewController.h"

typedef NS_ENUM(NSUInteger, JHStoneDetailCellType) {
    JHStoneDetailCellTypeAdress = 0,
    JHStoneDetailCellTypeStoneInfo,
    JHStoneDetailCellTypeSaler,
    JHStoneDetailCellTypeBuyer,
    JHStoneDetailCellTypeProcess,
    JHStoneDetailCellTypeSplit,
};

@class JHOriginStoneModel;

NS_ASSUME_NONNULL_BEGIN

@interface JHStoneDetailViewController : JHTableViewController

@property (nonatomic, strong) JHOriginStoneModel *originStoneModel;

@end

NS_ASSUME_NONNULL_END
