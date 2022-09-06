//
//  JHAppraiseVideoViewController.h
//  TTjianbao
//
//  Created by yaoyao on 2019/4/11.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHBaseViewExtController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHAppraiseVideoViewController : JHBaseViewExtController
@property (nonatomic, strong)NSString *cateId;
@property (nonatomic, strong)NSString *appraiseId;
@property (nonatomic, strong)NSString *anchorId;
@property (nonatomic, copy)void(^likeChangedBlock)(NSString *likeNum);
@property (nonatomic, copy)void(^likeChangedStatusBlock)(NSString *likeNum, BOOL isLike);

@property (nonatomic, copy) NSString *commentId; ///评论id：互动消息页跳转过来时需要的参数

@property (nonatomic, copy) NSString *from;

/// 播放起点
@property (nonatomic, assign) NSTimeInterval seekTime;
@end

NS_ASSUME_NONNULL_END
