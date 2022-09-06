//
//  JHMessageLikesTableViewCell.h
//  TTjianbao
//  Descripiton:点赞cell<社区>
//  Created by jesee on 22/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMessagesTableViewCell.h"
#import "JHMsgSubListLikeCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMessageLikesTableViewCell : JHMessagesTableViewCell

//@property (strong, nonatomic)  UIButton* subBgView; //「子背景」作者的帖子图片+作者+帖子内容
@property (strong, nonatomic)  UIView* subBgView; //「子背景」作者的帖子图片+作者+帖子内容

//评论显示时,需要重置subBgView约束
- (void)resetSubviewConstraints;

@end

NS_ASSUME_NONNULL_END
