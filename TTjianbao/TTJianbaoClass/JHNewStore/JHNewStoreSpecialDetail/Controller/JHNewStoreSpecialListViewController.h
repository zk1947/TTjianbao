//
//  JHNewStoreSpecialListViewController.h
//  TTjianbao
//
//  Created by liuhai on 2021/2/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagerView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHNewStoreSpecialListViewController : UIViewController<JXPagerViewListViewDelegate>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSString *showId; //专场id
@property (nonatomic, copy) NSString *showName;//专场名称
@property (nonatomic, copy) NSString *store_from;//来源
@property (nonatomic, assign) long specialTabId;
@property (nonatomic, copy) NSString *specialTabName;
@property (nonatomic, strong) JHActionBlock hotSellOffsetYBlock;
/// 刷新数据
/// @param sortType 0 综合排序，1 价格升序，2 价格降序
- (void)loadFirstData:(int)sortType;

@end

NS_ASSUME_NONNULL_END
