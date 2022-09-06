//
//  JHJHIdentificationDetailsDelegate.h
//  TTjianbao
//
//  Created by miao on 2021/6/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JHIdentificationDetailsCell;

NS_ASSUME_NONNULL_BEGIN

@protocol JHJHIdentificationDetailsDelegate <NSObject>

/// 播放视频
/// @param cell 那个cell
- (void)playdentDetailsVideo:(JHIdentificationDetailsCell *)cell;
/// 滑动时停止播放视频
/// @param tableView tableView
- (void)endScrollToStopVideo:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
