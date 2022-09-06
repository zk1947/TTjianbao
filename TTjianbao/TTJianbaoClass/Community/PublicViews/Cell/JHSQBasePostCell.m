//
//  JHSQBasePostCell.m
//  TTjianbao
//
//  Created by wuyd on 2020/7/10.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSQBasePostCell.h"
#import "JHTrackingPostDetailModel.h"
@interface JHSQBasePostCell ()

@end

@implementation JHSQBasePostCell

- (void)setPostData:(JHPostData *)postData {
    _postData = postData;
    _toolBar.pageType = self.pageType;
    _userInfoView.pageType = self.pageType;
    _userInfoView.postData = postData;
    
    if(_postData) {
        User *user = [UserInfoRequestManager sharedInstance].user;
        for (JHOwnerInfo *info in _postData.plate_info.owners) {
            if ([OBJ_TO_STRING(info.user_id) isEqualToString:OBJ_TO_STRING(user.customerId)]) {
                _postData.isPlateOwner = YES;
            }
        }
    }
}

///。。。
- (void)baseMoreAction{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.postData.item_id forKey:@"item_id"];
    [params setValue:self.postData.publisher.user_id forKey:@"user_id"];
    switch (self.pageType) {
        case JHPageTypeSQHome:
            [JHAllStatistics jh_allStatisticsWithEventId:@"recommend_operation_enter" params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
            break;
            
        case JHPageTypeUserInfoLikeTab:
            [JHAllStatistics jh_allStatisticsWithEventId:@"profile_like_operation_enter" params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
            break;
            
        case JHPageTypeUserInfoPublishTab:
            [JHAllStatistics jh_allStatisticsWithEventId:@"profile_write_operation_enter" params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
            break;
        case JHPageTypeSQPlateList: ///版块列表点击。。。
        {
            [params setValue:self.postData.plate_info.ID forKey:@"plate_id"];
            [params setValue:JHFromSQPlateList forKey:@"page_from"];
            [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQPlateListMoreEnter params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
        }
            break;
        case JHPageTypeSQTopicList: ///话题列表点击。。。
        {
            [params setValue:JHFromSQPlateList forKey:@"page_from"];
            [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQTopicListMoreEnter params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
        }
            break;
        case JHPageTypeSQHomePostSearch:
        {
            ///369神策埋点:搜索结果页点击帖子
            [self clickPostTrack:self.postData indexPath:self.indexPath];
        }
            break;
        default:
            break;
    }
}

- (void)clickPostTrack:(JHPostData *)data indexPath:(NSIndexPath *)indexPath {
    ///369神策埋点:点击搜索结果
    [JHTracking trackEvent:@"searchResultClick" property:@{@"position_sort":@(indexPath.row),
                                                           @"resources_type":@"帖子",
                                                           @"resources_id":data.item_id,
                                                           @"resources_name":data.title,
                                                           @"key_word":data.queryWord

    }];
}

///点击头像
- (void)baseAvatarAction {
    [self sa_tracking:@"nrhdHeadClick" andOptionType:@""];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.postData.item_id forKey:@"item_id"];
    [params setValue:self.postData.publisher.user_id forKey:@"user_id"];
    switch (self.pageType) {
        case JHPageTypeSQHome:
            [JHAllStatistics jh_allStatisticsWithEventId:@"recommend_user_enter" params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
            break;
            
        case JHPageTypeUserInfoLikeTab:
            [JHAllStatistics jh_allStatisticsWithEventId:@"profile_like_user_enter" params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
            break;
            
        case JHPageTypeUserInfoPublishTab:
            [JHAllStatistics jh_allStatisticsWithEventId:@"profile_write_user_enter" params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
            break;
        case JHPageTypeSQPlateList:  ///版块列表点击了头像
        {
            [params setValue:self.postData.plate_info.ID forKey:@"plate_id"];
            [params setValue:JHFromSQPlateList forKey:@"page_from"];
            [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQPlateUserIconEnter params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
        }
            break;
        case JHPageTypeSQTopicList: ///话题列表点击头像
        {
            [params setValue:JHFromSQPlateList forKey:@"page_from"];
            [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQTopicUserIconEnter params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
        }
            break;
        case JHPageTypeSQHomePostSearch:
        {
            ///369神策埋点:搜索结果页点击帖子
            [self clickPostTrack:self.postData indexPath:self.indexPath];
        }
            break;
        default:
            break;
    }
}

///点击评论
- (void)baseCommentAction {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.postData.item_id forKey:@"item_id"];
    [params setValue:self.postData.publisher.user_id forKey:@"user_id"];
    switch (self.pageType) {
        case JHPageTypeSQHome:
            [JHAllStatistics jh_allStatisticsWithEventId:@"recommend_list_comment_click" params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
            break;
            
        case JHPageTypeUserInfoLikeTab:
            [JHAllStatistics jh_allStatisticsWithEventId:@"profile_like_list_comment_click" params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
            break;
            
        case JHPageTypeUserInfoPublishTab:
            [JHAllStatistics jh_allStatisticsWithEventId:@"profile_write_list_comment_click" params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
            break;
        case JHPageTypeSQPlateList:  ///版块评论
        {
            [params setValue:self.postData.plate_info.ID forKey:@"plate_id"];
            [params setValue:JHFromSQPlateList forKey:@"page_from"];
            [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQPlateListCommentClick params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
        }
            break;
        case JHPageTypeSQTopicList: ///话题列表点击评论
        {
            [params setValue:JHFromSQPlateList forKey:@"page_from"];
            [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQTopicListCommentClick params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
        }
            break;
        case JHPageTypeSQHomePostSearch:
        {
            ///369神策埋点:搜索结果页点击帖子
            [self clickPostTrack:self.postData indexPath:self.indexPath];
        }
            break;
        default:
            break;
    }
}

///点击点赞
- (void)baseLikeAction{
    [self sa_tracking:@"nrhdLike" andOptionType:@"点赞"];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.postData.item_id forKey:@"item_id"];
    [params setValue:self.postData.publisher.user_id forKey:@"user_id"];
    switch (self.pageType) {
        case JHPageTypeSQHome:
            [JHAllStatistics jh_allStatisticsWithEventId:@"recommend_list_like_click" params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
            break;
            
        case JHPageTypeUserInfoPublishTab:
            [JHAllStatistics jh_allStatisticsWithEventId:@"profile_write_list_like_click" params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
            break;
            
        case JHPageTypeUserInfoLikeTab:
            [JHAllStatistics jh_allStatisticsWithEventId:@"profile_like_list_like_click" params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
            break;
        case JHPageTypeSQPlateList:  ///板块点赞
        {
            [params setValue:self.postData.plate_info.ID forKey:@"plate_id"];
            [params setValue:JHFromSQPlateList forKey:@"page_from"];
            [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQPlateListLikeClick params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
        }
            break;
        case JHPageTypeSQTopicList:  ///话题点赞
        {
            [params setValue:JHFromSQPlateList forKey:@"page_from"];
            [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQTopicListLikeClick params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
        }
            break;
        case JHPageTypeSQHomePostSearch:
        {
            ///369神策埋点:搜索结果页点击帖子
            [self clickPostTrack:self.postData indexPath:self.indexPath];
        }
            break;
        default:
            break;
    }
}

///点击取消点赞
- (void)baseUnLikeAction {
    [self sa_tracking:@"nrhdLike" andOptionType:@"取消点赞"];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.postData.item_id forKey:@"item_id"];
    [params setValue:self.postData.publisher.user_id forKey:@"user_id"];
    switch (self.pageType) {
        case JHPageTypeSQHome:
            [JHAllStatistics jh_allStatisticsWithEventId:@"recommend_list_cancel_like_click" type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
            break;
            
        case JHPageTypeUserInfoPublishTab:
            [JHAllStatistics jh_allStatisticsWithEventId:@"profile_write_list_cancel_like_click" type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
            break;
            
        case JHPageTypeUserInfoLikeTab:
            [JHAllStatistics jh_allStatisticsWithEventId:@"profile_like_list_cancel_like_click" type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
            break;
        case JHPageTypeSQHomePostSearch:
        {
            ///369神策埋点:搜索结果页点击帖子
            [self clickPostTrack:self.postData indexPath:self.indexPath];
        }
            break;
            
        default:
            break;
    }
}

///点击分享
- (void)baseShareAction{
    [self sa_tracking:@"nrhdShare" andOptionType:@"微信"];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.postData.item_id forKey:@"item_id"];
    [params setValue:self.postData.publisher.user_id forKey:@"user_id"];
    switch (self.pageType) {
        case JHPageTypeSQHome:
            [JHAllStatistics jh_allStatisticsWithEventId:@"recommend_list_share_click" params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
            break;
            
        case JHPageTypeUserInfoPublishTab:
            [JHAllStatistics jh_allStatisticsWithEventId:@"profile_write_list_share_click" params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
            break;
            
        case JHPageTypeUserInfoLikeTab:
            [JHAllStatistics jh_allStatisticsWithEventId:@"profile_like_list_share_click" params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
            break;
        case JHPageTypeSQPlateList:  ///版块分享
        {
            [params setValue:self.postData.plate_info.ID forKey:@"plate_id"];
            [params setValue:JHFromSQPlateList forKey:@"page_from"];
            [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQPlateListShareClick params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
        }
            break;
        case JHPageTypeSQTopicList:  ///话题分享
        {
            [params setValue:JHFromSQPlateList forKey:@"page_from"];
            [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQTopicListShareClick params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
        }
            break;
        case JHPageTypeSQHomePostSearch:
        {
            ///369神策埋点:搜索结果页点击帖子
            [self clickPostTrack:self.postData indexPath:self.indexPath];
        }
            break;
        default:
            break;
    }
}

///点击动态全文
- (void)baseFullTextAction {
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.postData.item_id forKey:@"item_id"];
    [params setValue:self.postData.publisher.user_id forKey:@"user_id"];
    switch (self.pageType) {
        case JHPageTypeSQHome:
            [JHAllStatistics jh_allStatisticsWithEventId:@"recommend_Twitter_enter" type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
            break;
            
        case JHPageTypeUserInfoPublishTab:
            [JHAllStatistics jh_allStatisticsWithEventId:@"profile_write_Twitter_enter" type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
            break;
            
        case JHPageTypeUserInfoLikeTab:
            [JHAllStatistics jh_allStatisticsWithEventId:@"profile_like_Twitter_enter" type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
            break;
            
        case JHPageTypeSQPlateList:  ///动态帖子点击事件
        {
            [params setValue:self.postData.plate_info.ID forKey:@"plate_id"];
            [params setValue:JHFromSQPlateList forKey:@"page_from"];
            [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQPlateTwitterEnter params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
        }
            break;
        case JHPageTypeSQTopicList:  ///话题全文点击事件
        {
            [params setValue:JHFromSQPlateList forKey:@"page_from"];
            [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQTopicTwitterEnter params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
        }
            break;
        case JHPageTypeSQHomePostSearch:
        {
            ///369神策埋点:搜索结果页点击帖子
            [self clickPostTrack:self.postData indexPath:self.indexPath];
        }
            break;
        default:
            break;
    }
}

///点击动态图片
- (void)baseDynamicPhotoAction {
    [self sa_tracking:@"nrhdImageClick" andOptionType:@""];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.postData.item_id forKey:@"item_id"];
    [params setValue:self.postData.publisher.user_id forKey:@"user_id"];
    switch (self.pageType) {
        case JHPageTypeSQHome:
        {
            [JHAllStatistics jh_allStatisticsWithEventId:@"recommend_Twitter_pic_enter" params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
        }
            break;
            
        case JHPageTypeUserInfoPublishTab:
            [JHAllStatistics jh_allStatisticsWithEventId:@"profile_write_Twitter_pic_enter" params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
            break;
            
        case JHPageTypeUserInfoLikeTab:
            [JHAllStatistics jh_allStatisticsWithEventId:@"profile_like_Twitter_pic_enter" params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
            break;
            
        case JHPageTypeSQPlateList:  ///版块主页点击动态图片
        {
            [params setValue:self.postData.plate_info.ID forKey:@"plate_id"];
            [params setValue:JHFromSQPlateList forKey:@"page_from"];
            [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQPlateTwitterPicEnter params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
        }
        case JHPageTypeSQTopicList: ///话题列表点击动态图片
        {
            [params setValue:JHFromSQPlateList forKey:@"page_from"];
            [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQTopicTwitterPicEnter params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
        }
            break;
        case JHPageTypeSQHomePostSearch:
        {
            ///369神策埋点:搜索结果页点击帖子
            [self clickPostTrack:self.postData indexPath:self.indexPath];
        }
            break;
        default:
            break;
    }
}

///点击动态快捷评论框
- (void)baseQuickCommentAction {
    [self sa_tracking:@"nrhdComment" andOptionType:@""];
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.postData.item_id forKey:@"item_id"];
    [params setValue:self.postData.publisher.user_id forKey:@"user_id"];
    
    switch (self.pageType) {
        case JHPageTypeSQHome:
            [JHAllStatistics jh_allStatisticsWithEventId:@"recommend_Twitter_comment_enter" params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
            break;
            
        case JHPageTypeUserInfoPublishTab:
            [JHAllStatistics jh_allStatisticsWithEventId:@"profile_write_Twitter_comment_enter" params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
            break;
            
        case JHPageTypeUserInfoLikeTab:
            [JHAllStatistics jh_allStatisticsWithEventId:@"profile_like_Twitter_comment_enter" params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
            break;
        case JHPageTypeSQPlateList:  ///版块主页点击动态快捷评论框
        {
            [params setValue:self.postData.plate_info.ID forKey:@"plate_id"];
            [params setValue:JHFromSQPlateList forKey:@"page_from"];
            [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQPlateTwitterQuicklyCommentEnter params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
        }
            
        case JHPageTypeSQTopicList: ///话题列表点击快捷评论
        {
            [params setValue:JHFromSQPlateList forKey:@"page_from"];
            [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQTopicTwitterQuicklyCommentEnter params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
        }
            break;
        case JHPageTypeSQHomePostSearch:
        {
            ///369神策埋点:搜索结果页点击帖子
            [self clickPostTrack:self.postData indexPath:self.indexPath];
        }
            break;
        default:
            break;
    }
}

///点击了帖子点击事件
- (void)baseEnterDetailAction
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:self.postData.item_id forKey:@"item_id"];
    [params setValue:self.postData.publisher.user_id forKey:@"user_id"];
    switch (self.pageType) {
        case JHPageTypeSQHome: /// 社区首页
        {
            switch (self.postData.item_type) {
                
                case JHPostItemTypeDynamic:
                    [JHAllStatistics jh_allStatisticsWithEventId:@"recommend_Twitter_enter" params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
                    break;
                    
                case JHPostItemTypePost:
                    [JHAllStatistics jh_allStatisticsWithEventId:@"recommend_article_enter" params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
                    break;
                  
                case JHPostItemTypeAppraisalVideo:
                case JHPostItemTypeVideo:
                {
                    [JHAllStatistics jh_allStatisticsWithEventId:@"recommend_video_enter" params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        case JHPageTypeSQPlateList:  ///版块主页
        {
            [params setValue:self.postData.plate_info.ID forKey:@"plate_id"];
            [params setValue:JHFromSQPlateList forKey:@"page_from"];
            switch (self.postData.item_type) {
                case JHPostItemTypeDynamic:  ///动态帖子点击事件
                {
                    [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQPlateTwitterEnter params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
                }
                    break;
                case JHPostItemTypePost: ///长文章
                {
                    [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQPlateArticleEnter params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
                }
                    break;
                case JHPostItemTypeVideo: ///小视频
                {
                    [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQPlateVideoEnter params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
                }
                    break;
                default:
                    break;
            }
        }
            break;

        case JHPageTypeSQTopicList:  ///话题主页
        {
            [params setValue:JHFromSQPlateList forKey:@"page_from"];

            switch (self.postData.item_type) {
                case JHPostItemTypeDynamic:  ///动态帖子点击事件
                    [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQTopicTwitterEnter params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
                    break;
                case JHPostItemTypePost: ///长文章
                    [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQTopicArticleEnter params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
                    break;
                case JHPostItemTypeVideo: ///小视频
                {
                    [JHAllStatistics jh_allStatisticsWithEventId:JHTrackSQTopicVideoEnter params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        case JHPageTypeSQHomePostSearch:  ///搜索
        {
            [params setValue:self.postData.queryWord forKey:@"query_word"];
            switch (self.postData.item_type) {
                case JHPostItemTypeDynamic:  ///动态帖子点击事件
                    [JHAllStatistics jh_allStatisticsWithEventId:@"search_Twitter_enter" params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
                    break;
                case JHPostItemTypePost: ///长文章
                    [JHAllStatistics jh_allStatisticsWithEventId:@"search_article_enter" params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
                    break;
                case JHPostItemTypeVideo: ///小视频
                {
                    [JHAllStatistics jh_allStatisticsWithEventId:@"search_video_enter" params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
                }
                    break;
                default:
                    break;
            }
            
            ///369神策埋点:搜索结果页点击帖子
            [self clickPostTrack:self.postData indexPath:self.indexPath];
        }
            break;
            
        case JHPageTypeUserInfo:  ///用户个人主页
        case JHPageTypeUserInfoLikeTab:  ///用户个人主页-赞过
        case JHPageTypeUserInfoPublishTab:///用户个人主页-发过
        {
            switch (self.postData.item_type) {
                case JHPostItemTypeDynamic:  ///动态帖子点击事件
                    [JHAllStatistics jh_allStatisticsWithEventId:@"profile_Twitter_enter" params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
                    break;
                case JHPostItemTypePost: ///长文章
                    [JHAllStatistics jh_allStatisticsWithEventId:@"profile_article_enter" params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
                    break;
                case JHPostItemTypeVideo: ///小视频
                {
                    [JHAllStatistics jh_allStatisticsWithEventId:@"profile_video_enter" params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeBI)];
                }
                    break;
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}

- (JHPageFromType)getPageFrom:(JHPageType)type actionType:(JHActionType)action {
    switch (type) {
        case JHPageTypeSQHome:
            {
                if (action == JHActionTypeMore) {
                    return JHPageFromTypeSQHomeListMore;
                }
                return JHPageFromTypeSQHomeListFastOperate;
            }
            break;
        case JHPageTypeSQTopicList:
            {
                if (action == JHActionTypeMore) {
                    return JHPageFromTypeSQTopicHomeListMore;
                }
                return JHPageFromTypeSQTopicHomeListFastOperate;
            }
            break;
        case JHPageTypeSQPlateList:
            {
                if (action == JHActionTypeMore) {
                    return JHPageFromTypeSQPlateHomeListMore;
                }
                return JHPageFromTypeSQPlateHomeListFastOperate;
            }
            break;
        case JHPageTypePostSearch:
        case JHPageTypeSQHomePostSearch:
            {
                if (action == JHActionTypeMore) {
                    return JHPageFromTypeSQSearchListMore;
                }
                return JHPageFromTypeSQSearchListFastOperate;
            }
            break;
        case JHPageTypeCollect:
            {
                if (action == JHActionTypeMore) {
                    return JHPageFromTypeSQFavoriteListMore;
                }
                return JHPageFromTypeSQFavoriteListFastOperate;
            }
            break;
        default:
            return JHPageFromTypeUnKnown;
            break;
    }
}

//神策埋点
- (void)sa_tracking:(NSString *)event andOptionType:(NSString *)option{
    
    JHTrackingPostDetailModel * model = [JHTrackingPostDetailModel new];
    model.event = event;
    model.operation_type = option;
    model.page_position = @"内容列表页";
    switch (self.postData.item_type) {
        case JHPostItemTypeDynamic:  ///动态
        {
            model.content_type = @"动态";
        }
            break;
        case JHPostItemTypePost: ///长文章
        {
            model.content_type = @"文章";
        }
            break;
        case JHPostItemTypeVideo: ///小视频
        {
            model.content_type = @"小视频";
        }
            break;
        default:
            break;
    }
    [model transitionWithPostData:self.postData];
    [JHTracking trackModel:model];
}
@end
