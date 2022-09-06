//
//  JHStoreHomeListView.h
//  TTjianbao
//
//  Created by wuyd on 2020/2/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  分类导航标签下商品列表
//

#import <UIKit/UIKit.h>
#import "JXPageListView.h"
#import "CStoreChannelModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHStoreHomeListView : UIView <JXPageListViewListDelegate>
@property (nonatomic, strong) CStoreChannelData *curChannelData;

///页面离开时上报数据
- (void)uploadDataBeforePageLeave;

/// 返回顶部子 scrollView
- (void)setSubScrollView;


@end

NS_ASSUME_NONNULL_END
