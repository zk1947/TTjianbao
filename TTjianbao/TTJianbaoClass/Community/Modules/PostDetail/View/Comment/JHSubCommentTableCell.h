//
//  JHSubCommentTableCell.h
//  TTjianbao
//
//  Created by lihui on 2020/8/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHPostDetailEnum.h"

NS_ASSUME_NONNULL_BEGIN

@class JHCommentModel;

static NSString *const kSubCommentCellIdentifer = @"kJHSubCommentTableCellIdentifer";

@interface JHSubCommentTableCell : UITableViewCell
///帖子作者id
@property (nonatomic, copy) NSString *postAuthorId;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) JHCommentModel *commentModel;
@property (nonatomic, copy) void(^actionBlock)(NSIndexPath *selectIndexPath, JHSubCommentTableCell *cell, JHPostDetailActionType actionType);
- (void)updateLikeButtonStatus:(JHCommentModel *)comment;
@end

NS_ASSUME_NONNULL_END
