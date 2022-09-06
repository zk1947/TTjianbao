//
//  JHStoneDetailHeader.h
//  TTjianbao
//
//  Created by wuyd on 2019/12/23.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//  原石详情页header
//

#import "BaseView.h"
#import "TTjianbaoHeader.h"

#import "UITapImageView.h"
#import "CStoneDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

#define kStoneDetailHeaderH    (ScreenWidth)

@interface JHStoneDetailHeader : BaseView

@property (nonatomic, strong) UIImageView *mPlayIcon;

/// 自动播放
@property (nonatomic, assign) BOOL autoPlay;

/// 静音
@property (nonatomic, assign) BOOL isMute;

@property (nonatomic, copy) dispatch_block_t muteBlock;

///点击播放block
@property (nonatomic, copy) void(^playClickBlock)(void);

///scroll view滑动停止后，返回当前是否是视频页索引
@property (nonatomic, copy) void(^didEndScrollingBlock)(BOOL isVideoIndex);

///含有视频资源时返回给控制层
@property (nonatomic, copy) void(^playClickVideoBlock)(CAttachmentListData *videoData, UITapImageView *videoContainer);

@property (nonatomic, strong) NSMutableArray<CAttachmentListData *> *dataList;

- (void)endPlay; //播放结束时调用

@end

NS_ASSUME_NONNULL_END
