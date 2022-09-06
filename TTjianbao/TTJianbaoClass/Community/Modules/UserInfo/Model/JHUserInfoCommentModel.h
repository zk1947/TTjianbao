//
//  JHUserInfoCommentModel.h
//  TTjianbao
//
//  Created by lihui on 2020/7/1.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHSQModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHUserInfoCommentModel : NSObject
///主评论 对帖子的评论 base_comment
@property (nonatomic, strong) JHCommentModel *comment;
///对帖子 或者 对帖子的评论 进行的评论 main
@property (nonatomic, strong) JHCommentModel *mainInfo;
///被评论的文章
@property (nonatomic, strong) JHPostData *postData;
@end

NS_ASSUME_NONNULL_END
