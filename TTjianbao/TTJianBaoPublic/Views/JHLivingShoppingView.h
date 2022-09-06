//
//  JHLivingShoppingView.h
//  TTjianbao
//
//  Created by 王记伟 on 2020/12/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallListView.h"
#import "JXPageListView.h"

NS_ASSUME_NONNULL_BEGIN
@class JHMallCateModel;

@interface JHLivingShoppingView : JHMallListView <JXPageListViewListDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSString *text;
@property (copy, nonatomic) NSString *groupId;
@property (copy, nonatomic) NSString *channelName;




@end

NS_ASSUME_NONNULL_END
