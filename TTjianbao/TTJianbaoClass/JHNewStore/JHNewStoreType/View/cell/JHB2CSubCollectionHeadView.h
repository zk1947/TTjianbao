//
//  JHB2CSubCollectionHeadView.h
//  TTjianbao
//
//  Created by zk on 2021/10/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHNewStoreTypePageViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHB2CSubCollectionHeadView : UICollectionReusableView

@property (nonatomic, strong) JHNewStoreTypeRightSectionModel *model;

///eventIndex 0-轮播 1-直播更多 2-直播间 3-二级分类列表  row-对应二级索引
@property(nonatomic, copy) void (^headViewTouchEventBlock)(NSInteger eventIndex,NSInteger row);
@end
NS_ASSUME_NONNULL_END
