//
//  JHRecycleGoodsDetailPictsTableViewCell.h
//  TTjianbao
//
//  Created by user on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

///scroll view滑动停止后，返回当前是否是视频页索引
@interface JHRecycleGoodsDetailPictsTableViewCell : UITableViewCell
@property (nonatomic, copy) void(^bannerCycleScrollEndDeceleratingBlock)(BOOL isVideoIndex);
- (void)setViewModel:(id)viewModel;

@end

NS_ASSUME_NONNULL_END
