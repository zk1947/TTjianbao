//
//  JHMallRecommendHeader.h
//  TTjianbao
//
//  Created by lihui on 2020/7/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@class JHLiveRoomMode;

@interface JHMallRecommendHeader : BaseView

///存储图片的数组
@property (nonatomic, copy) NSArray <JHLiveRoomMode *>*liveRoomData;

///自动滚动或者 手动滑动到 cell的回调
@property (nonatomic, copy) void(^scrolledBlock)(UIView *steamView, JHLiveRoomMode *liveRoomSource);
///点击了第几个cell的回调
@property (nonatomic, copy) void (^didSelectBLock)(NSInteger index);

@property (nonatomic, copy) void (^willDraggBlock)(void);

///滚动下个view
- (void)scrollToNextPage;


@end

NS_ASSUME_NONNULL_END
