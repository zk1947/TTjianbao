//
//  TTjianbao
//
//  Created by wangjianios on 2020/6/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBaseViewController.h"
#import "JHImagePickerPublishManager.h"
@class JHDraftBoxModel;
@class JHPublishTopicDetailModel;
@class JHPlateSelectData;
NS_ASSUME_NONNULL_BEGIN

/// 社区 - 发布页（内部区分动态、小视频）
@interface JHSQPublishViewController : JHBaseViewController

/// 图片资源
@property (nonatomic, strong) NSMutableArray <JHAlbumPickerModel *> *dataArray;

/// 1:image(动态)     2:video（小视频）
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *pageFrom;

///视频
@property (nonatomic, strong) AVAsset *asset;

///视频截取时间区间
@property (nonatomic, assign) CMTimeRange timeRange;

@property (nonatomic, strong) JHDraftBoxModel* draftBoxModel;

/// 话题进来
@property (nonatomic, strong) JHPublishTopicDetailModel *topic;

/// 板块进来
@property (nonatomic, strong) JHPlateSelectData *plate;

///编辑传入的数据(编辑不能改变 帖子类型)
@property (nonatomic, copy) NSString *itemType;

///编辑传入的ID
@property (nonatomic, copy) NSString *itemId;

@end

NS_ASSUME_NONNULL_END
