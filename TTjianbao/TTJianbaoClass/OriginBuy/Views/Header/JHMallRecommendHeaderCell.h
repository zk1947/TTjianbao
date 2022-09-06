//
//  JHMallRecommendHeaderCell.h
//  TTjianbao
//
//  Created by lihui on 2020/7/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "GKCycleScrollViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class JHLiveRoomMode;

@interface JHMallRecommendHeaderCell : GKCycleScrollViewCell
///拉流view
@property (nonatomic, strong) UIView *steamView;
@property (nonatomic, strong) JHLiveRoomMode *imageModel;

@end

NS_ASSUME_NONNULL_END
