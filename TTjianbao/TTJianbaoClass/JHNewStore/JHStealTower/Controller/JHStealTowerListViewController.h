//
//  JHStealTowerListViewController.h
//  TTjianbao
//
//  Created by zk on 2021/8/2.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "JHStealTowerRequestModel.h"
#import "JHStealTowerModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HaveDataBlock)(BOOL noData, JHStealTowerModel *listModel);

@protocol JHStealTowerListViewControllerDelegate <NSObject>
- (void)JHStealTowerListViewControllerLeaveTop;
@end

@interface JHStealTowerListViewController : JHBaseViewController

@property (nonatomic, copy) HaveDataBlock haveDataBlock;

@property (nonatomic,   weak) id<JHStealTowerListViewControllerDelegate> delegate;

- (void)makeDeatilDescModuleScroll:(BOOL)canScroll;

- (void)loadData:(JHStealTowerRequestModel *)requestModel completion:(void (^ __nullable)(BOOL finished))completion;

@property (nonatomic,   copy) void(^goToBoutiqueDetailClickBlock)(BOOL isH5,NSString *showId, NSString *boutiqueName);

@end

NS_ASSUME_NONNULL_END
