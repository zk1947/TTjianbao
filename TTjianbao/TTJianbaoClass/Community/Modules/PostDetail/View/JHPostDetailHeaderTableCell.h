//
//  JHPostDetailHeaderTableCell.h
//  TTjianbao
//
//  Created by lihui on 2020/8/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
/// 社区 - 展示帖子作者信息 关注状态 帖子描述信息的cell

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHPostDetailModel;
@class User;

static NSString * const kJHPostDetailHeaderCellIdentifer = @"kJHPostDetailHeaderTableCellIdentifer";

@interface JHPostDetailHeaderTableCell : UITableViewCell
///帖子信息
@property (nonatomic, strong) JHPostDetailModel *postDetailInfo;

@property (nonatomic, copy) void (^followBlock)(BOOL isFollow);
@property (nonatomic, copy) void (^iconEnterBlock)(void);

- (void)setUserInfo:(User *)userInfo content:(NSString *)content publishTime:(NSString *)publishTime;

@end

NS_ASSUME_NONNULL_END
