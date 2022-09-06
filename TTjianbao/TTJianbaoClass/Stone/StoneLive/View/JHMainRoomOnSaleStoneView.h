//
//  JHMainRoomOnSaleStoneView.h
//  TTjianbao
//  Description:MainRoom在售(寄售)原石
//  Created by Jesse on 2019/11/30.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHSegmentPageView.h"
#import "JHMainLiveRoomTabSubviewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMainRoomOnSaleStoneView : JHSegmentPageView

@property (nonatomic, copy) NSString *channelId;

- (void)drawSubviewsWithPageType:(JHMainLiveRoomTabType)type;
@end

NS_ASSUME_NONNULL_END
