//
//  JHCommentListTableViewCell.h
//  TTjianbao
//
//  Created by lihui on 2020/6/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHUserInfoCommentModel;

NS_ASSUME_NONNULL_BEGIN

static NSString *const kCommentListIdentifer = @"kCommentListIdentifer";

typedef NS_ENUM(NSInteger, JHCommentListCellType) {
    ///用户评论了别人的帖子
    JHCommentListCellTypeAsCritic = 1,
    ///用户作为作者回复别人评论
    JHCommentListCellTypeAsAuthor = 2,
};

@interface JHCommentListTableViewCell : UITableViewCell

///评论类型
@property (nonatomic, assign) JHCommentListCellType cellType;

@property (nonatomic, strong) JHUserInfoCommentModel *commentModel;

@property (nonatomic, strong) NSIndexPath *indexPath;

///删除回调
@property (nonatomic, copy) void(^deleteBlock)(NSInteger index);


@end

NS_ASSUME_NONNULL_END
