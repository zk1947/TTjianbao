//
//  JHMallLivingListView.h
//  TTjianbao
//
//  Created by lihui on 2020/12/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallListView.h"
#import "JXPageListView.h"

@class JHMallCateModel;
NS_ASSUME_NONNULL_BEGIN

@interface JHMallLivingListView : JHMallListView <JXPageListViewListDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) JHMallCateModel *channelModel;
@property (nonatomic, assign) BOOL isFirstRequest;

@end

NS_ASSUME_NONNULL_END
