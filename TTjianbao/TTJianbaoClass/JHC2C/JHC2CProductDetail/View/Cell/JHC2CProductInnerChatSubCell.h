//
//  JHC2CProductInnerChatSubCell.h
//  TTjianbao
//
//  Created by jingxuelong on 2021/6/28.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHPostDetailEnum.h"

NS_ASSUME_NONNULL_BEGIN

@class JHCommentModel;
static NSString *const kJHC2CProductInnerChatSubCell = @"kJHC2CProductInnerChatSubCellIdentifer";

@interface JHC2CProductInnerChatSubCell : UITableViewCell
///帖子作者id
@property (nonatomic, copy) NSString *postAuthorId;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) JHCommentModel *commentModel;
@property (nonatomic, copy) void(^actionBlock)(NSIndexPath *selectIndexPath, JHC2CProductInnerChatSubCell *cell, JHPostDetailActionType actionType);
- (void)updateLikeButtonStatus:(JHCommentModel *)comment;
@end

NS_ASSUME_NONNULL_END
