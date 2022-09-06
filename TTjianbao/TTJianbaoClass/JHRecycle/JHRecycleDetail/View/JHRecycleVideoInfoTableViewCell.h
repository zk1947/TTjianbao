//
//  JHRecycleVideoInfoTableViewCell.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
//  宝贝信息-视频

#import "JHRecycleDetailBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHRecycleVideoInfoTableViewCell : JHRecycleDetailBaseTableViewCell
@property (nonatomic, strong) UIImageView *videoView;
@property (nonatomic, copy) NSString *videoUrl;
@property (nonatomic, copy) void(^playCallback)(JHRecycleVideoInfoTableViewCell *videoCell);

@end

NS_ASSUME_NONNULL_END
