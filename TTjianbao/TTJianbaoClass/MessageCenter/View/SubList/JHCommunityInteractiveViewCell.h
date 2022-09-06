//
//  JHCommunityInteractiveViewCell.h
//  TTjianbao
//  Description:【使用范围】社区互动cell<宝友关注>
//  Created by Jesse on 2020/2/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHMessagesTableViewCell.h"
#import "JHMsgSubListNormalForumModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHCommunityInteractiveViewCell : JHMessagesTableViewCell

@property (nonatomic, copy) JHActionBlocks forumHeadImageActive;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end

@interface JHCommunityInteractiveButtonViewCell : JHCommunityInteractiveViewCell

@property (nonatomic, copy) JHActionBlocks forumCareActive;
@end

NS_ASSUME_NONNULL_END
