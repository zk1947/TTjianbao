//
//  JHMallTrackView.h
//  TTjianbao
//
//  Created by lihui on 2020/12/7.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
///首页改版 - 关注页面特有的

#import "JHMallListView.h"
#import "JXPageListView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMallTrackView : JHMallListView <JXPageListViewListDelegate>
@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) JHMallCateModel *channelModel;
@end

NS_ASSUME_NONNULL_END
