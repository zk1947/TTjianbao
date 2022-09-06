//
//  JHStoneResaleListViewController.h
//  TTjianbao
//
//  Created by jiang on 2019/11/29.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HGPageViewController.h"
#import "JHLivePlayerManager.h"
#define JHNotificationNameChangeStoneCellSize @"JHNotificationNameChangeStoneCellSize"

NS_ASSUME_NONNULL_BEGIN

@interface JHStoneResaleListViewController : HGPageViewController
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, copy)NSString *groupId;
@property (nonatomic, assign)JHStoneMainListType type;

@property (nonatomic, copy) NSDictionary *paramDic;

- (void)loadNewData;
- (void)loadData;
-(void)shutdownPlayStream;
-(void)doDestroyLastCell;
@end

NS_ASSUME_NONNULL_END

