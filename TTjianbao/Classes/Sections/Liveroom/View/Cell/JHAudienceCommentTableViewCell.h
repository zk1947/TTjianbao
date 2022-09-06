//
//  CommentTableViewCell.h
//  TTjianbao
//
//  Created by jiangchao on 2019/1/10.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHAudienceCommentMode.h"

typedef void (^CommentTableViewCellClickAction)( UIButton* button, BOOL isLaud,  NSInteger index);
@interface JHAudienceCommentTableViewCell : UITableViewCell
@property(strong,nonatomic)JHAudienceCommentMode* audienceCommentMode;
@property(assign,nonatomic) NSInteger cellIndex;
@property(nonatomic,strong) CommentTableViewCellClickAction cellClick;
@property (strong, nonatomic)  UIImageView *likeImageView;
@property (strong, nonatomic)  UILabel *likeCountLabel;
-(void)reloadCell:(JHAudienceCommentMode*)mode;
@property (assign, nonatomic)  BOOL  isCanReply;
@end




