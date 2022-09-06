//
//  JHGoodsDetailCommentFooter.h
//  TTjianbao
//
//  Created by lihui on 2020/3/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const kFooterId_CommentFooterIdentifer = @"CommentFooterIdentifer";

@interface JHGoodsDetailCommentFooter : UICollectionReusableView

@property (nonatomic, copy) void(^findAllBlock)(void);

@property (nonatomic, copy) NSString *totalCommentCountStr;     ///评论总数字段
@property (nonatomic, assign) NSInteger totalCommentCount;      ///评论总数个数
@property (nonatomic, copy) NSArray *commentList;               ///评论数据

- (void)setTotalCommentStr:(NSString *)totalCommentStr ComentList:(NSArray*)commentList totalCommentCount:(NSInteger)totalComentCount;


@end

NS_ASSUME_NONNULL_END
