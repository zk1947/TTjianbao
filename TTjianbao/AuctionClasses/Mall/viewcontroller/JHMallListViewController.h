//
//  JHMallListViewController.h
//  TTjianbao
//
//  Created by mac on 2019/8/22.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "HGPageViewController.h"
#import "JHLivePlayerManager.h"
#define JHNotificationNameChangeMallCellSize @"JHNotificationNameChangeMallCellSize"
#define JHNotificationNameScrollMallTopEnd @"JHNotificationNameScrollMallTopEnd"



NS_ASSUME_NONNULL_BEGIN

@interface JHMallListViewController : HGPageViewController
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic,assign)  BOOL groupWatchTrack;
@property (nonatomic, copy)NSString *groupId;
- (void)loadNewData;
-(void)refreshData;
- (void)loadData;
-(void)shutdownPlayStream;
-(void)doDestroyLastCell;

- (void)scrollToListShow;
@end

NS_ASSUME_NONNULL_END
