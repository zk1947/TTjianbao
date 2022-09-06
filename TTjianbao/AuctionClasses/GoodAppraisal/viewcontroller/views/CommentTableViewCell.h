//
//  CommentTableViewCell.h
//  TTjianbao
//
//  Created by jiangchao on 2019/1/10.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApprailsalCommentMode.h"

typedef void (^CommentTableViewCellClickAction)(BOOL isLaud,  NSInteger index);
@interface CommentTableViewCell : UITableViewCell
@property(strong,nonatomic)ApprailsalCommentMode* appraisalComment;
@property(strong,nonatomic)ApprailsalCommentMode* appraisalReportComment;
@property(assign,nonatomic) NSInteger cellIndex;
- (float)getAutoCellHeight;
@property(nonatomic,strong) CommentTableViewCellClickAction cellClick;

@property (strong, nonatomic)  UIImageView *likeImageView;
@property (strong, nonatomic)  UILabel *likeCountLabel;
- (void)beginAnimation:(ApprailsalCommentMode*)mode;
@end


