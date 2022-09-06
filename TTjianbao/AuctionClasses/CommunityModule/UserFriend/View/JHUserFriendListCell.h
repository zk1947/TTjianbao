//
//  JHUserFriendListCell.h
//  TTjianbao
//
//  Created by wuyd on 2019/9/24.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "YDBaseTableViewCell.h"
@class CUserFriendData;

NS_ASSUME_NONNULL_BEGIN

static NSString * const kCellId_JHUserFriendListCell = @"JHUserFriendListCellIdentifier";

@interface JHUserFriendListCell : YDBaseTableViewCell

+ (CGFloat)cellHeight;

//关注或取消关注后 将是否关注返回给VC，更新isFollow - ***不需要调用
@property (nonatomic, copy) void(^didFollowRequestBlock)(NSInteger isFollow);

@property (nonatomic, strong) CUserFriendData *curData;

@end

NS_ASSUME_NONNULL_END
