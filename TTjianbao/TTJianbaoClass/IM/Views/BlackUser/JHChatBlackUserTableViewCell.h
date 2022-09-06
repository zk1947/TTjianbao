//
//  JHChatBlackUserTableViewCell.h
//  TTjianbao
//
//  Created by zk on 2021/7/14.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHChatBlackUserModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol  JHChatBlackUserTableViewCellDelegate <NSObject>

- (void)gotoPersonPage:(JHChatBlackUserModel *)model;
- (void)deleteCell:(JHChatBlackUserModel *)model;

@end

@interface JHChatBlackUserTableViewCell : UITableViewCell

@property (nonatomic, weak) id delegate;

@property (nonatomic, strong) JHChatBlackUserModel *model;

@end

NS_ASSUME_NONNULL_END
