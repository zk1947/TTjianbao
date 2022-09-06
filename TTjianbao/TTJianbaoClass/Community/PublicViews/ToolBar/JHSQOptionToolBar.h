//
//  JHSQOptionToolBar.h
//  TTjianbao
//
//  Created by wuyd on 2020/6/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  工具栏：版块标签、分享、评论、点赞
//

#import <UIKit/UIKit.h>
#import "JHPostCellHeader.h"

@class JHSQBasePostCell;
@class JHPostData;

NS_ASSUME_NONNULL_BEGIN

@interface JHSQOptionToolBar : UIView

@property (nonatomic, strong) JHPostData *postData;

@property (nonatomic, strong) UIButton *commentButton; //评论
@property (nonatomic, strong) UIButton *likeButton; //点赞

@property (nonatomic, copy) dispatch_block_t clickShareBlock;
@property (nonatomic, copy) dispatch_block_t clickCommentBlock;

@property (nonatomic, copy) dispatch_block_t clickLikeForGrowingIOBlock;
@property (nonatomic, copy) dispatch_block_t clickUnLikeForGrowingIOBlock;

/** 当前所属控制器类型 */
@property (nonatomic, assign) JHPageType pageType;

+ (CGFloat)toolBarHeight;

@end

NS_ASSUME_NONNULL_END
