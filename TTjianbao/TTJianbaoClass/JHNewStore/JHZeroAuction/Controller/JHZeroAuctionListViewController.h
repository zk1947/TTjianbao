//
//  JHZeroAuctionListViewController.h
//  TTjianbao
//
//  Created by zk on 2021/11/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "JHZeroAuctionRequestModel.h"
#import "JHZeroAuctionModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^HaveDataBlock)(BOOL noData, JHZeroAuctionModel *listModel);

@protocol JHZeroAuctionListViewControllerDelegate <NSObject>
- (void)JHStealTowerListViewControllerLeaveTop;
@end

@interface JHZeroAuctionListViewController : JHBaseViewController

@property (nonatomic, copy) HaveDataBlock haveDataBlock;

@property (nonatomic,   weak) id<JHZeroAuctionListViewControllerDelegate> delegate;

- (void)makeDeatilDescModuleScroll:(BOOL)canScroll;

- (void)loadData:(JHZeroAuctionRequestModel *)requestModel completion:(void (^ __nullable)(BOOL finished))completion;

@property (nonatomic,   copy) void(^goToBoutiqueDetailClickBlock)(BOOL isH5,NSString *showId, NSString *boutiqueName);

@end

NS_ASSUME_NONNULL_END
