//
//  JHSQApiManager.h
//  TTjianbao
//
//  Created by wuyd on 2020/4/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//  社区首页所有接口
//

#import <Foundation/Foundation.h>
//#import "JHSQDataModel.h" //旧数据
//#import "JHInterestUserListModel.h" //旧数据
#import "JHSQModel.h" //新数据
#import "JHPlateListModel.h"
#import "BannerMode.h"
#import "JHHotWordModel.h"
#import "JHHotListModel.h"
#import "JHSearchRespModel.h"
#import "JHPlateSelectModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHSQApiManager : NSObject

#pragma mark - 下面两个方法是老版本的（暂时不删，后面统一删）
///获取社区关注列表数据
//+ (void)getFollowListData:(JHSQDataModel *)model block:(HTTPCompleteBlock)block;

///获取感兴趣的人列表数据
//+ (void)getInterestUserList:(JHInterestUserListModel *)model block:(HTTPCompleteBlock)block;


#pragma mark - 3.3.0 新方法

///获取热搜词 <直接返回列表数组<JHHotWordModel *>>
+ (void)getHotWords:(HTTPCompleteBlock)block;

///获取首页广告  <直接返回了列表数组<BannerCustomerModel *>>
+ (void)getBannerList:(HTTPCompleteBlock)block;

///获取首页-版块列表数据 <直接返回了列表数组<JHPlateListData *>>
+ (void)getPlateList:(HTTPCompleteBlock)block;

///获取首页-公告栏列表数据 <直接返回了列表数组<JHPlateListData *>>
+ (void)getNoticeList:(HTTPCompleteBlock)block;

///获取首页-推荐列表-feed流数据 <返回JHSQModel对象>
+ (void)getPostList:(JHSQModel *)model block:(HTTPCompleteBlock)block;

///获取收藏-内容列表-feed流数据 <返回JHSQModel对象>
+ (void)getCollectPostList:(JHSQModel *)model block:(HTTPCompleteBlock)block;
///获取搜索-内容列表-feed流数据 <返回JHSQModel对象>
+ (void)getSearchPostList:(JHSearchRespModel*)resModel block:(HTTPCompleteBlock)block;

///获取收藏统计信息
+ (void)getCollectStats:(HTTPCompleteBlock)block;

///新收藏商品数量 接口
+ (void)getNewCollectCount:(HTTPCompleteBlock)block;
/// 获取C2C 商品收藏数量
+ (void)getC2CCollectCount :(HTTPCompleteBlock)block;
///点赞
+ (void)sendLikeRequest:(JHPostData *)data block:(HTTPCompleteBlock)block;

///取消点赞
+ (void)sendUnLikeRequest:(JHPostData *)data block:(HTTPCompleteBlock)block;

///发评论 <返回JHCommentData对象>
+ (void)sendComment:(NSDictionary *)comments postData:(JHPostData *)data block:(HTTPCompleteBlock)block;

/// 获取首页-热帖列表
/// @param dateString 日期
/// @param block 网络请求回调
+ (void)getHotPostList:(NSString *)dateString completeBlock:(HTTPCompleteBlock)block;

/// 收藏和取消收藏
/// @param data data description
/// @param block block description
+ (void)collectRequest:(JHPostData *)data block:(HTTPCompleteBlock)block;

/// 精华  和取消精华
/// @param data data description
/// @param block block description
+ (void)contentlevelRequest:(JHPostData *)data block:(HTTPCompleteBlock)block;

/// 公告和取消公告
/// @param data data description
/// @param block block description
+ (void)noticeRequest:(JHPostData *)data block:(HTTPCompleteBlock)block;


/// 置顶和取消置顶
/// @param data data description
/// @param block block description
+ (void)topRequest:(JHPostData *)data block:(HTTPCompleteBlock)block;


/// 禁言
/// @param data data description
/// @param block block description
+ (void)muteRequest:(JHPostData *)data reasonId:(NSString * __nullable)reasonId timeType:(NSInteger)timeType block:(HTTPCompleteBlock _Nullable)block;

/// 封号
/// @param data data description
/// @param block block description
+ (void)banRequest:(JHPostData *)data reasonId:(NSString * __nullable)reasonId block:(HTTPCompleteBlock)block;

/// 警告
/// @param data data description
/// @param block block description
+ (void)waringRequest:(JHPostData *)data reasonId:(NSString * __nullable)reasonId;

/// 作为版主删除帖子
/// @param data data description
/// @param block block description
+ (void)deleteRequestAsPlator:(JHPostData *)data reasonId:(NSString * __nullable)reasonId block:(HTTPCompleteBlock)block;

/// 作为作者删除帖子
/// @param data 帖子数据结构
/// @param block block description
+ (void)deleteRequestAsAuthor:(JHPostData *)data reasonId:(NSString * __nullable)reasonId block:(HTTPCompleteBlock)block;

///获取发布页选择板块列表
+ (void)getPlateSelectList:(JHPlateSelectModel *)model block:(HTTPCompleteBlock)block;


#pragma mark - 3.4.0添加的
/// 获取帖子详情信息
/// @param data 帖子数据
/// @param block block description
+ (void)getPostDetailInfo:(NSString *)itemType
                   itemId:(NSString *)itemId
                    block:(HTTPCompleteBlock)block;

/// 获取最热评论
/// @param itemId 帖子id
/// @param itemType 帖子类型
/// @param block block description
+ (void)getHotCommentList:(NSString *)itemId
                 itemType:(NSInteger)itemType
             completation:(HTTPCompleteBlock)block;


/// 获取全部评论
/// @param itemId 帖子id
/// @param itemType 帖子类型
/// @param page 分页
/// @param lastId 上一组数据的最后一个数据的id
/// @param filterIds filterIds description
/// @param block block description
+ (void)getAllCommentList:(NSString *)itemId
                 itemType:(NSInteger)itemType
                     page:(NSInteger)page
                   lastId:(NSString *)lastId
                filterIds:(NSString *)filterIds
             completation:(HTTPCompleteBlock)block;


/// 发布列表评论
/// @param commentInfos 评论的内容
/// @param itemId itemId description
/// @param itemType itemType description
/// @param block block description
+ (void)submitCommentWithCommentInfos:(NSDictionary *)commentInfos
                               itemId:(NSString *)itemId
                             itemType:(NSInteger)itemType
                        completeBlock:(HTTPCompleteBlock)block;

//@"at_user_id":@(at_user_id),
//@"at_user_name":at_user_name,

/// 回复评论
/// @param params 如果是需要传的参数
/// @param block block description
+ (void)submitCommentReplay:(NSDictionary *)params
              completeBlock:(HTTPCompleteBlock)block;



/// 获取帖子详情的评论列表
/// @param itemType itemType description
/// @param itemId itemId description
/// @param lastId lastId description
/// @param sortNum sortNum description
/// @param page page从2开始
/// @param filterIds filterIds description
/// @param block block description
+ (void)requestPostDetailCommentListWithItemType:(NSString *)itemType
                                          itemId:(NSString *)itemId
                                          lastId:(NSString *)lastId
                                         sortNum:(NSInteger)sortNum
                                            page:(NSInteger)page
                                       filterIds:(NSString *)filterIds
                                   completeBlock:(HTTPCompleteBlock)block;

/// 请求帖子详情里面的回复列表
/// @param commentId 评论id
/// @param lastId 评论列表里面的最后一个评论id
/// @param page 当前页数
/// @param filterIds filterIds description
/// @param block block description
+ (void)requestPostDetailReplyListWithCommentId:(NSString *)commentId
                                         lastId:(NSInteger)lastId
                                           page:(NSInteger)page
                                      filterIds:(NSString *)filterIds
                                  completeBlock:(HTTPCompleteBlock)block;


/// 删除评论
/// @param comment_id 评论id
/// @param block block description
+ (void)deletePostDetailCommentWithCommentId:(NSString *)comment_id
                                      reasonId:(NSString * __nullable)reasonId
                               completeBlock:(HTTPCompleteBlock)block;

/// 删除评论   C2C 发帖者删除
/// @param comment_id 评论id
/// @param block block description
+ (void)deletePublishPostDetailCommentWithCommentId:(NSString *)comment_id
                                      reasonId:(NSString * __nullable)reasonId
                               completeBlock:(HTTPCompleteBlock)block;


/// 禁言
/// @param userId 被禁言的用户id
/// @param block block description
+ (void)muteRequestWithUserId:(NSString *)userId
                       reasonId:(NSString * __nullable)reasonId
                     timeType:(NSInteger)timeType
                        block:(HTTPCompleteBlock)block;

/// 封号
/// @param itemId itemId description
/// @param itemType itemType description
/// @param userId 被禁言的用户id
/// @param block block description
+ (void)banRequest:(NSString *)itemId
          itemType:(NSInteger)itemType
            userId:(NSString *)userId
            reasonId:(NSString * __nullable)reasonId
             block:(HTTPCompleteBlock)block;



/// 警告
/// @param itemId itemId description
/// @param itemType itemType description
/// @param userId userId description
/// @param block block description
+ (void)warningRequest:(NSString *)itemId
              itemType:(NSInteger)itemType
                userId:(NSString *)userId
                reasonId:(NSString * __nullable)reasonId
                 block:(HTTPCompleteBlock)block;

/// 搜索
/// @param channelId channelId description
/// @param keyword 搜索关键词
/// @param type type description
/// @param page 页数
/// @param block block description
+ (void)searchInfoWithChannelId:(NSInteger)channelId
                        keyword:(NSString *)keyword
                           type:(NSString *)type
                           page:(NSInteger)page
                  completeBlock:(HTTPCompleteBlock)block;

///获取用户最新发的审核中的帖子信息接口
+ (void)getPostDetailInfoPublishByNow:(HTTPCompleteBlock)block;

@end

NS_ASSUME_NONNULL_END
