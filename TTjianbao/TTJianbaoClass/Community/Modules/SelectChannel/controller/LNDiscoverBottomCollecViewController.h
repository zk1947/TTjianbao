//
//  LNDiscoverBottomCollecViewController.h
//  TTjianbao
//
//  Created by jingxin on 2019/5/12.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "NELivePlayerViewController.h"
#import "JHDiscoverChannelModel.h"
#import "JXCategoryView.h"

@interface LNDiscoverBottomCollecViewController : JHBaseViewExtController <JXCategoryListContentViewDelegate>

@property (nonatomic, strong) JHDiscoverChannelModel* channelModel;

- (instancetype)initWithChannelType:(JHDiscoverChannelType)type;
- (void)addTimer;
- (void)destoryTimer;
- (void)refreshStatics:(BOOL)isDisAppear;
//- (void)loadNewData;

- (void)tabBarSelected;
@end
