//
//  JHPostMainCommentHeader.h
//  TTjianbao
//
//  Created by lihui on 2020/8/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
/// 社区 - 主评论UI

#import <UIKit/UIKit.h>
#import "JHPostDetailEnum.h"

NS_ASSUME_NONNULL_BEGIN

@class JHCommentModel;

static NSString *const kCommentSectionHeader = @"kJHPostMainCommentHeaderIdentifer";

@interface JHPostMainCommentHeader : UITableViewCell

///帖子作者id
@property (nonatomic, copy) NSString *postAuthorId;

@property (nonatomic, strong) JHCommentModel *mainComment;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, copy) void(^actionBlock)(NSIndexPath *selectIndexPath, JHPostMainCommentHeader *header, JHPostDetailActionType actionType);
- (void)updateLikeButtonStatus:(JHCommentModel *)comment;

@end

NS_ASSUME_NONNULL_END
