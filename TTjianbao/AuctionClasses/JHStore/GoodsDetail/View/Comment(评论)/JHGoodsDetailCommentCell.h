//
//  JHGoodsDetailCommentCell.h
//  TTjianbao
//
//  Created by wuyd on 2019/11/29.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//  command+v 自 JHAudienceCommentTableViewCell
//

#import "YDBaseTableViewCell.h"
#import "JHAudienceCommentMode.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^CommentTableViewCellClickAction)( UIButton* button, BOOL isLaud,  NSInteger index);

static NSString *const kCellId_GoodsDetailCommentListIdentifer = @"GoodsDetailCommentListIdentifer";

@interface JHGoodsDetailCommentCell : UICollectionViewCell

@property (nonatomic, strong) JHAudienceCommentMode* audienceCommentMode;
@property (nonatomic, assign) NSInteger cellIndex;
@property (nonatomic, strong) CommentTableViewCellClickAction cellClick;
@property (nonatomic, strong) UIImageView *likeImageView;
@property (nonatomic, strong) UILabel *likeCountLabel;
@property (nonatomic, assign) BOOL  isCanReply;

- (void)reloadCell:(JHAudienceCommentMode*)mode;

@end

NS_ASSUME_NONNULL_END
