//
//  JHStealTowerListCell.h
//  TTjianbao
//
//  Created by zk on 2021/8/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHStealTowerRequestModel.h"
#import "JHStealTowerModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HaveDataBlock)(BOOL noData, JHStealTowerModel *listModel);

@protocol JHStealTowerListCellDelegate <NSObject>
- (void)JHStealTowerListCellLeaveTopd;
@end

@interface JHStealTowerListCell : UITableViewCell

@property (nonatomic,   weak) id<JHStealTowerListCellDelegate> delegate;

@property (nonatomic, copy) HaveDataBlock haveDataBlock;

- (void)makeDeatilDescModuleScroll:(BOOL)canScroll;

- (void)loadData:(JHStealTowerRequestModel *)requestModel completion:(void (^ __nullable)(BOOL finished))completion;

@property (nonatomic,   copy) void(^goToBoutiqueDetailClickBlock)(BOOL isH5,NSString *showId, NSString *boutiqueName);

@end

NS_ASSUME_NONNULL_END
