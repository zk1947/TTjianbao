//
//  JHOnlineVideoDetailController.h
//  TTjianbao
//
//  Created by lihui on 2020/12/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
/// 在线鉴定首页 - 底部视频详情页部分

#import "JHBaseViewController.h"


NS_ASSUME_NONNULL_BEGIN

@class JHPostDetailModel;

@protocol JHOnlineVideoDetailControllerDelegate <NSObject>
///获取更多数据
- (void)requestMorePostData:(void(^)(NSArray <JHPostDetailModel *>*_Nullable postArray))completateBlock;
@end

@interface JHOnlineVideoDetailController : JHBaseViewController
@property (nonatomic, weak) id<JHOnlineVideoDetailControllerDelegate>delegate;
///当前选中的下标
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL isFollow;

///固定运营账号的id
@property (nonatomic, copy) NSString *operationUserId;

@property (nonatomic, copy) NSArray <JHPostDetailModel *>*postArray;
@property (nonatomic, copy) void(^backBlock)(NSInteger currentIndex);
@property (nonatomic, copy) void (^followBlock)(BOOL isFollow);

/// 播放起点
@property (nonatomic, assign) NSTimeInterval seekTime;

@end

NS_ASSUME_NONNULL_END
