//
//  JHMessageSubListData.h
//  TTjianbao
//  Description:消息中心-分类列表-数据管理
//  Created by Jesse on 2020/2/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHMsgSubListNormalModel.h"
#import "JHMsgSubListAnnounceModel.h"
#import "JHMsgSubListLikeCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMessageSubListData : NSObject

@property (nonatomic, assign) NSInteger pageIndex;
//@property (nonatomic, assign) NSInteger pageSize; //判断是否显示加载更多
@property (nonatomic, strong) NSMutableArray* nakeArray;
//按时间排序、分组后的数据
@property (nonatomic, strong) NSMutableArray <JHMsgSubListShowModel*>*sortedArrayByDate;
//根据类型请求页面数据
- (void)requestByPageType:(NSString*)pageType finish:(JHFailure)finish;
//关注与取消
- (void)followUserWithIndexpath:(NSIndexPath*)indexpath finish:(JHFailure)finish;
- (void)getUserBridge:(NSIndexPath*)indexpath response:(JHResponse)response;
//根据公告id查询富文本内容
- (void)queryAnnounceContentById:(NSString *)announceId finish:(JHResponse)finish;
//社区评论>点赞
- (void)requestLikeData:(NSIndexPath*)data action:(JHActionBlock)action;
//社区评论>评论
- (void)requestCommentData:(NSIndexPath*)data action:(JHActionBlock)action;
- (void)requestCommentData:(NSIndexPath*)indexPath content:(NSString*)content action:(JHActionBlock)action;
//社区评论>删除
- (void)deleteCommentData:(NSIndexPath*)indexpath action:(JHActionBlock)action;
//社区互动消息-点赞列表-清除
- (void)requestClearLike:(JHActionBlock)finish;
 //社区互动消息-评论列表-清除
- (void)requestClearComment:(JHActionBlock)finish;

@property (strong, nonatomic) NSArray<JHMsgSubListLikeCommentModel *> *list;

@end

NS_ASSUME_NONNULL_END
