//
//  JHMessageSubListData.m
//  TTjianbao
//
//  Created by Jesse on 2020/2/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMessageSubListData.h"
#import "JHMsgSubListNormalForumModel.h"
#import "JHDiscoverChannelViewModel.h"
#import "JHQueryAnnounceContentModel.h"
#import "JHMsgSubListOrderTransportModel.h"
#import "JHMsgSubListLikeCommentModel.h"
//#import "User.h"
#import "JHSQApiManager.h"


@interface JHMessageSubListData ()
@end

@implementation JHMessageSubListData

- (void)requestByPageType:(NSString*)pageType finish:(JHFailure)finish
{
    if(!pageType)
    {
        NSLog(@"JHMessageSubListData：没有匹配请求类型");
        return;
    }
    //评论&点赞
    if([kMsgSublistTypeComment isEqualToString:pageType]
            || [kMsgSublistTypeLike isEqualToString:pageType])
    {
        [self requestLikeCommentDataByPageType:pageType finish:finish];
    }
    else //新增类型
    {
        NSLog(@"JHMessageSubListData：没有匹配请求类型->新增类型");
        JHMsgSubListReqModel* reqModel = [JHMsgSubListReqModel new];
        [reqModel setRequestSubpath:pageType];
        reqModel.pageNo = self.pageIndex;
        [JH_REQUEST asynGet:reqModel success:^(id respData) {
            //分发数据model
            [self distributeSubData:respData];
            finish([JHRespModel nullMessage]);
        } failure:^(NSString *errorMsg) {
            finish(errorMsg ? : @"fail");
        }];
    }
}

- (void)distributeSubData:(id)data
{
    NSArray* array = [JHMsgSubListModel convertData:data];
    if(array.count > 0)
    {
        JHMsgSubListModel* model = array.firstObject;
        if([model.showType isEqualToString:kMsgSublistShowTypeActivitySlogan])
        {
            NSArray* arr = [JHMsgSubListAnnounceModel convertData:data];
            [self makeDataArray:arr];
        }
        else if([model.showType isEqualToString:kMsgSublistShowTypeOrderTransport])
        {
            NSArray* arr = [JHMsgSubListOrderTransportModel convertData:data];
            [self makeDataArray:arr];
        }
        else if([model.showType isEqualToString:kMsgSublistShowTypeForumFollow])
        {
            NSArray* arr = [JHMsgSubListNormalForumModel convertData:data];
            [self makeDataArray:arr];
        }
        else //model.showType maybe is nil
        {
            NSArray* arr = [JHMsgSubListNormalModel convertData:data];
            [self makeDataArray:arr];
        }
    }
}

//与现有消息中心格格不入
- (void)requestLikeCommentDataByPageType:(NSString*)pageType finish:(JHFailure)finish
{
    JHMsgSubListLikeCommentReqModel* likeComment = [JHMsgSubListLikeCommentReqModel new];
    //首页还是N页
    if(self.pageIndex == 0)
        likeComment.last_id = @"0";
    else
    {
        JHMsgSubListLikeCommentModel* m = self.nakeArray.lastObject;
        likeComment.last_id = m.article.commentId;
    }
    //评论和点赞
    if([kMsgSublistTypeLike isEqualToString:pageType])
        likeComment.type = 3;
    else
        likeComment.type = 1;
    [JH_REQUEST asynGet:likeComment success:^(id respData) {

        NSArray* arr = [JHMsgSubListLikeCommentModel convertData:respData];
        [self makeDataArray:arr];
        finish([JHRespModel nullMessage]);
    } failure:^(NSString *errorMsg) {
        finish(errorMsg ? : @"fail");
    }];
}

//获取数据=>排序
- (void)makeDataArray:(NSArray*)arr
{
    self.list = [NSArray new];
    self.list = arr;
    
//    self.pageSize = [arr count];//返回数组个数
    if (self.pageIndex == 0)
        self.nakeArray = [NSMutableArray arrayWithArray:arr];
    else
        [self.nakeArray addObjectsFromArray:arr];
    //数据=>排序
    [self sortdataArray];
}
//获取数据后=>排序
- (void)sortdataArray
{
    self.sortedArrayByDate =[NSMutableArray array];
    NSMutableArray *timeArr = [NSMutableArray array];
    //1聚合时间>按时间分组
    [self.nakeArray enumerateObjectsUsingBlock:^(JHMsgSubListModel *model, NSUInteger idx, BOOL *stop) {
        [timeArr addObject:model.createDate];
    }];
    NSSet *set = [NSSet setWithArray:timeArr]; //时间去重
    NSArray *userArray = [set allObjects];
    NSSortDescriptor *sd1 = [NSSortDescriptor sortDescriptorWithKey:nil ascending:NO];//yes升序排列，no,降序排列
    NSArray *descendingDateArr = [userArray sortedArrayUsingDescriptors:[NSArray arrayWithObjects:sd1, nil]];
    //2按时间聚合,创建新数组【内含JHMsgSubListShowModel子类】
    [descendingDateArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        JHMsgSubListShowModel *show = [[JHMsgSubListShowModel alloc]init];
        [self.sortedArrayByDate addObject:show];
    }];
    //3新数组赋值,效率有点低了
    [self.nakeArray enumerateObjectsUsingBlock:^(JHMsgSubListModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        for (NSString *str in descendingDateArr) {
            if([str isEqualToString:model.createDate]) {
                JHMsgSubListShowModel *showModel = [self.sortedArrayByDate objectAtIndex:[descendingDateArr indexOfObject:str]];
                showModel.dateTime = str;
                [showModel.groupArray addObject:model];
            }
        }
    }];
}
 //社区互动消息-点赞列表-清除
- (void)requestClearLike:(JHActionBlock)finish
{
    JHMsgSubListClearLikeModel* like = [JHMsgSubListClearLikeModel new];
    [JH_REQUEST asynGet:like success:^(id respData) {
        finish(([JHRespModel nullMessage]));
    } failure:^(NSString *errorMsg) {
        finish(errorMsg);
    }];
}
 //社区互动消息-评论列表-清除
- (void)requestClearComment:(JHActionBlock)finish
{
    JHMsgSubListClearCommentModel* comment = [JHMsgSubListClearCommentModel new];
    [JH_REQUEST asynGet:comment success:^(id respData) {
        finish(([JHRespModel nullMessage]));
    } failure:^(NSString *errorMsg) {
        finish(errorMsg);
    }];
}

- (void)followUserWithIndexpath:(NSIndexPath*)indexpath finish:(JHFailure)finish
{
    JHMsgSubListNormalForumModel* model = (JHMsgSubListNormalForumModel*)(self.sortedArrayByDate[indexpath.section].groupArray[indexpath.row]);
    if ([model.isFollow isEqualToString:kMsgSublistForumFollowNo])
    {
        [JHDiscoverChannelViewModel focusRecommentUserWithUserId:model.fromId fans_count:0 success:^(RequestModel * _Nonnull request) {

            [self followUser:kMsgSublistForumFollowYes model:model];
            finish([JHRespModel nullMessage]);
        } failure:^(RequestModel * _Nonnull request) {
            finish(@"关注失败！");
        }];
    }
    else
    {
        [JHDiscoverChannelViewModel cancleFocusRecommentUserWithUserId:model.fromId fans_count:0 success:^(RequestModel * _Nonnull request) {

            [self followUser:kMsgSublistForumFollowNo model:model];
            finish([JHRespModel nullMessage]);
        } failure:^(RequestModel * _Nonnull request) {
            finish(@"取消关注失败");
        }];
    }
}

- (void)followUser:(NSString*)follow model:(JHMsgSubListNormalForumModel*)model
{
    for(JHMsgSubListShowModel* showModel in self.sortedArrayByDate)
        {
            for (JHMsgSubListNormalForumModel* forumModel in showModel.groupArray)
            {
                if ([forumModel.thirdType isEqualToString: kMsgSublistForumTypeFollow])
                {
                    if ([forumModel.fromId isEqualToString:model.fromId])
                    {
                        forumModel.isFollow = follow;
//                        break; //直接break可以减少循环次数;难道是为了列表中有相同用户时,状态全部更新？？
                    }
                }
            }
        }
}

- (void)getUserBridge:(NSIndexPath*)indexpath response:(JHResponse)response
{
    JHMsgSubListNormalForumModel* model = (JHMsgSubListNormalForumModel*)(self.sortedArrayByDate[indexpath.section].groupArray[indexpath.row]);
    NSString *url = [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/user/userBridge/%@"), model.fromId];
    
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {

        UserRole * userRole = [UserRole mj_objectWithKeyValues: respondObject.data];
        if (userRole.role==1) //主播
        {
            response(@"1", userRole.user_id);
        }
        else if (userRole.role==9) { // 定制师主页
            response(@"9", userRole.user_id);
        }
        else
        {
            response(@"0", userRole.user_id);
        }
    } failureBlock:^(RequestModel *respondObject) {
        response([JHRespModel nullMessage], respondObject.message);
    }];
}

- (void)queryAnnounceContentById:(NSString *)announceId finish:(JHResponse)finish
{///app/mc/auth/msg/announce/content
    JHQueryAnnounceContentReqModel* queryContent = [JHQueryAnnounceContentReqModel new];
    queryContent.announceId = announceId;
    [JH_REQUEST asynGet:queryContent success:^(id respData) {
        
        finish(respData, [JHRespModel nullMessage]);
    } failure:^(NSString *errorMsg) {
        
        finish([JHRespModel nullMessage], errorMsg);
    }];
}

- (void)updateCommentNum:(NSString*)commentNum likeNum:(NSNumber*)likeNum isLike:(BOOL)isLike indexPath:(NSIndexPath*)indexPath
{
    JHMsgSubListLikeCommentModel* data = (JHMsgSubListLikeCommentModel*)(self.sortedArrayByDate[indexPath.section].groupArray[indexPath.row]);
    if(commentNum)
    {
        NSInteger count = [data.article.replyCount integerValue] + [commentNum integerValue];
        data.article.replyCount = [NSString stringWithFormat:@"%zd", count];
    }
    else if(likeNum)
    {
        data.article.isLike = isLike;
        data.article.likeNum = [NSString stringWithFormat:@"%@", likeNum];
    }
}

//删除
- (void)deleteCommentData:(NSIndexPath*)indexpath action:(JHActionBlock)action
{
    JHMsgSubListLikeCommentModel* data = (JHMsgSubListLikeCommentModel*)(self.sortedArrayByDate[indexpath.section].groupArray[indexpath.row]);
    [JHSQApiManager deletePostDetailCommentWithCommentId:data.article.commentId reasonId:nil completeBlock:^(RequestModel * _Nullable respObj, BOOL hasError) {
        if (hasError) {
            action(respObj.message);
        }
        else {
            action(nil);
        }
    }];
}
//点赞
- (void)requestLikeData:(NSIndexPath*)indexPath action:(JHActionBlock)action
{
    JHMsgSubListLikeCommentModel* data = (JHMsgSubListLikeCommentModel*)(self.sortedArrayByDate[indexPath.section].groupArray[indexPath.row]);
    JHPostData* post = [JHPostData new];
    if(data.replyArticle)
        post.item_type = 4;
    else
        post.item_type = 3;
    post.item_id = data.article.commentId; //应该用commentId
    post.like_num = [data.article.likeNum integerValue];
    JH_WEAK(self)
    if (data.article.isLike)
    {
        [JHSQApiManager sendUnLikeRequest:post block:^(RequestModel * _Nullable respObj, BOOL hasError) {
            JH_STRONG(self)
            [self updateCommentNum:nil likeNum:respObj.data[@"like_num_int"] isLike:NO indexPath:indexPath];
            action(respObj);
        }];
    }
    else
    {
        [JHSQApiManager sendLikeRequest:post block:^(RequestModel * _Nullable respObj, BOOL hasError) {
            JH_STRONG(self)
            [self updateCommentNum:nil likeNum:respObj.data[@"like_num_int"] isLike:YES indexPath:indexPath];
            action(respObj);
        }];
    }
    
    [JHGrowingIO trackPublicEventId:@"community_comment_praise_click" paramDict:@{@"from":@"messageCenterCommentList", @"is_praise":data.article.isLike ? @"1": @"0", @"comment_id":data.replyArticle.commentId ? : @""}];
}

//评论
- (void)requestCommentData:(NSIndexPath*)indexPath action:(JHActionBlock)action
{
    //discard
}

- (void)requestCommentData:(NSIndexPath*)indexPath content:(NSString*)content action:(JHActionBlock)action
{
    JHMsgSubListLikeCommentModel* data = (JHMsgSubListLikeCommentModel*)(self.sortedArrayByDate[indexPath.section].groupArray[indexPath.row]);
    @weakify(self);
    if(data.replyArticle)
    {
        NSDictionary * params = @{@"at_user_id":data.article.publisher.user_id,
                                  @"at_user_name":data.article.publisher.user_name,
                                  @"comment_id":data.article.commentId,
                                  @"content":content
        };
        [JHSQApiManager submitCommentReplay:params completeBlock:^(RequestModel *respObj, BOOL hasError) {
            @strongify(self);
            if (!hasError) {
                [self updateCommentNum:@"1" likeNum:nil isLike:NO indexPath:indexPath];
                action(@"1");
            }
            else {
                [UITipView showTipStr:respObj.message ? : @"评论失败"];
            }
        }];
    }
    else
    {
        NSDictionary * params = @{
                                    @"comment_id":data.article.commentId,
                                    @"content":content
                                    };
        [JHSQApiManager submitCommentReplay:params completeBlock:^(RequestModel *respObj, BOOL hasError) {
            @strongify(self);
            if (!hasError) {
                [self updateCommentNum:@"1" likeNum:nil isLike:NO indexPath:indexPath];
                action(@"1");
            }
            else {
                [UITipView showTipStr:respObj.message ? : @"评论失败"];
            }
        }];
    }
}

@end
