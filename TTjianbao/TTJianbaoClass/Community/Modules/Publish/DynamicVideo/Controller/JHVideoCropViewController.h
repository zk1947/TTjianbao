//
//  TTjianbao
//
//  Created by wangjianios on 2020/6/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
// git:https://github.com/wang82426107/SDVideoCamera
#import <AVFoundation/AVFoundation.h>
#import "JHBaseViewController.h"
@class JHPublishTopicDetailModel;
@class JHPlateSelectData;

@class JHAlbumPickerModel;
@interface JHVideoCropViewController : JHBaseViewController

/// 话题进来
@property (nonatomic, strong) JHPublishTopicDetailModel *topic;

/// 板块进来
@property (nonatomic, strong) JHPlateSelectData *plate;


// JHVideoCropViewController 是视频裁剪的主体功能类
- (instancetype)initWithVideoWithOutPutPath:(NSString*)outPutPath;

@property (nonatomic, copy) void(^selectVideoBlock)(AVURLAsset *tmpAsset,CMTimeRange tmpTimeRange);

@end
