//
//  JHNewUserCommentTableViewCell.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHNewShopUserCommentModel.h"

NS_ASSUME_NONNULL_BEGIN
@class JHNewUserCommentTableViewCell;

@protocol JHNewUserCommentTableViewCellDelegate <NSObject>
- (void)clickUnfoldButtonAction:(JHNewUserCommentTableViewCell *)commentCell;

@end

@interface JHNewUserCommentTableViewCell : UITableViewCell
@property (nonatomic, weak) id<JHNewUserCommentTableViewCellDelegate> delegate;
@property (nonatomic, strong) JHNewShopUserCommentListModel *commentListModel;

@end

NS_ASSUME_NONNULL_END
