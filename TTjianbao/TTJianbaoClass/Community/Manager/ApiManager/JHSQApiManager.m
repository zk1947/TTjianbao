//
//  JHSQApiManager.m
//  TTjianbao
//
//  Created by wuyd on 2020/4/15.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSQApiManager.h"
#import "JHPostDetailModel.h"
#import "JHSQUploadManager.h"
#import "SVProgressHUD.h"
#import "JHAttributeStringTool.h"

@implementation JHSQApiManager

//社区首页关注列表数据
//+ (void)getFollowListData:(JHSQDataModel *)model block:(HTTPCompleteBlock)block {
//    NSLog(@"获取社区关注列表数据");
//    model.isLoading = YES;
//    model.isFirstReq = NO;
//
//    NSString *url = [model toFollowListUrl];
//    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
//
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//            JHSQDataModel *aModel = [JHSQDataModel modelWithJSON:respondObject.data];
//
//            dispatch_async(dispatch_get_main_queue(), ^{
//                model.isLoading = NO;
//                block(aModel?:nil, NO);
//            });
//        });
//
//    } failureBlock:^(RequestModel * _Nullable respondObject) {
//        model.isLoading = NO;
//        block(nil, YES);
//        //[UITipView showTipStr:respondObject.message];
//    }];
//}

//+ (void)getInterestUserList:(JHInterestUserListModel *)model block:(HTTPCompleteBlock)block {
//    NSLog(@"获取感兴趣的人列表数据");
//
//    model.isLoading = YES;
//    model.isFirstReq = NO;
//
//    [HttpRequestTool getWithURL:[model toUrl] Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
//        model.isLoading = NO;
//
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//
//               NSArray *dataList = [NSArray modelArrayWithClass:[JHSQRcmdListData class] json:respondObject.data];
//               JHInterestUserListModel *aModel = [[JHInterestUserListModel alloc] init];
//               aModel.list = dataList.mutableCopy;
//
//               dispatch_async(dispatch_get_main_queue(), ^{
//                   block(aModel, NO);
//               });
//           });
//
//    } failureBlock:^(RequestModel * _Nullable respondObject) {
//        model.isLoading = NO;
//        block(nil, YES);
//        [UITipView showTipStr:respondObject.message];
//    }];
//}


#pragma mark -
#pragma mark - 3.3.0 新方法

+ (void)getHotWords:(HTTPCompleteBlock)block {
    NSLog(@"获取热搜词");
    NSString *url= COMMUNITY_FILE_BASE_STRING(@"/content/communityHotKeywords");
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         
            NSArray *keywords = [NSArray modelArrayWithClass:[JHHotWordModel class] json:respondObject.data];
         
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(keywords, NO);
                }
            });
        });
        
    } failureBlock:^(RequestModel *respondObject) {
        if (block) {
            block(nil, YES);
        }
    }];
}

+ (void)getBannerList:(HTTPCompleteBlock)block {
    NSLog(@"获取推荐列表页广告数据");
    NSString *url = COMMUNITY_FILE_BASE_STRING(@"/ad/23");
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         
            NSArray<BannerCustomerModel *> *list = [NSArray modelArrayWithClass:[BannerCustomerModel class] json:respondObject.data];
         
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(list, NO);
                }
            });
        });
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(nil, YES);
        }
    }];
}

+ (void) getPlateList:(HTTPCompleteBlock)block {
    NSLog(@"获取所有版块数据");
    NSString *url = COMMUNITY_FILE_BASE_STRING(@"/v1/channel/allChannelList");
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSArray<JHPlateListData *> *list = [NSArray modelArrayWithClass:[JHPlateListData class] json:respondObject.data];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (list.count > 0) {
                    block(list, NO);
                } else {
                    block(nil, NO);
                }
            });
        });
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(nil, YES);
        }
    }];
}

+ (void)getNoticeList:(HTTPCompleteBlock)block {
    NSString *url = COMMUNITY_FILE_BASE_STRING(@"/ad/24");
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSArray<BannerCustomerModel *> *list = [NSArray modelArrayWithClass:[BannerCustomerModel class] json:respondObject.data];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(list, NO);
                }
            });
        });

    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(nil, YES);
        }
    }];
}

+ (void)getPostList:(JHSQModel *)model block:(HTTPCompleteBlock)block {
    NSLog(@"获取首页推荐列表feed流数据");
    model.isLoading = YES;
    
    [HttpRequestTool getWithURL:[model toPostListUrl] Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        model.isLoading = NO;
        
        NSArray<JHPostData *> *list = [NSArray modelArrayWithClass:[JHPostData class] json:respondObject.data];
        
        if (list.count > 0) {
            JHSQModel *aModel = [[JHSQModel alloc] init];
            aModel.list = list.mutableCopy;
            block(aModel, NO);
            
        } else {
            block(nil, NO);
        }
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        model.isLoading = NO;
        block(nil, YES);
    }];
}
+ (void)getCollectPostList:(JHSQModel *)model block:(HTTPCompleteBlock)block {
    NSLog(@"获取收藏列表feed流数据");
    model.isLoading = YES;
    [HttpRequestTool getWithURL:[model toCollectPostListUrl] Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         
            NSArray<JHPostData *> *list = [NSArray modelArrayWithClass:[JHPostData class] json:respondObject.data];
         
            dispatch_async(dispatch_get_main_queue(), ^{
                
                model.isLoading = NO;
                
                if (list.count > 0) {
                    for (JHPostData *data in list) {
                        if (data.item_type == JHPostItemTypeDynamic || data.item_type == JHPostItemTypeVideo) {
                            if (![data.content isNotBlank]) { //动态&短视频内容为空时，赋默认值
                                data.content = @"分享内容";
                            }
                        }
                    }
                    JHSQModel *aModel = [[JHSQModel alloc] init];
                    aModel.list = list.mutableCopy;
                    block(aModel, NO);
                    
                } else {
                    block(nil, NO);
                }
            });
        });
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        model.isLoading = NO;
        block(nil, YES);
    }];
}

+ (void)getSearchPostList:(JHSearchRespModel*)resModel block:(HTTPCompleteBlock)block{
    NSLog(@"获取搜索列表feed流数据");
    [HttpRequestTool postWithURL:COMMUNITY_FILE_BASE_STRING(@"/v1/bbs/search")  Parameters:[resModel mj_keyValues] requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         
            NSArray<JHPostData *> *list = [NSArray modelArrayWithClass:[JHPostData class] json:respondObject.data[@"post_list"]];
         
            dispatch_async(dispatch_get_main_queue(), ^{
                for (JHPostData *data in list) {
                    if (data.item_type == JHPostItemTypeDynamic || data.item_type == JHPostItemTypeVideo) {
                        if (![data.content isNotBlank]) { //动态&短视频内容为空时，赋默认值
                            data.content = @"分享内容";
                        }
                    }
                }
                JHSQModel *aModel = [[JHSQModel alloc] init];
                aModel.list = list.mutableCopy;
                aModel.total_num = [respondObject.data[@"total_num"] integerValue];
                block(aModel, NO);
            });
        });
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
       
        block(nil, YES);
    }];
}
+ (void)getCollectStats:(HTTPCompleteBlock)block{
    
    [HttpRequestTool getWithURL:COMMUNITY_FILE_BASE_STRING(@"/auth/v1/user/collection_stats")  Parameters:nil successBlock:^(RequestModel *respondObject) {
        block(respondObject, NO);
        
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
        block(respondObject, YES);
    }];
    
}
///api/mall/product/follow/count
///新收藏商品数量 接口
+ (void)getNewCollectCount:(HTTPCompleteBlock)block{
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/product/follow/count") Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        block(respondObject, NO);
        
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
        block(respondObject, YES);
    }];
}
+ (void)getC2CCollectCount :(HTTPCompleteBlock)block{
    NSString *url = FILE_BASE_STRING(@"/api/mall/product/follow/count");
    [HttpRequestTool postWithURL:url Parameters:nil requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        block(respondObject, NO);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        block(respondObject, YES);
    }];
}
///点赞
+ (void)sendLikeRequest:(JHPostData *)data block:(HTTPCompleteBlock)block {
    NSString *url= [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/auth/user/like/%ld/%@/%ld"),
                    (long)data.item_type, data.item_id, (long)data.like_num];
    [Growing track:@"like" withVariable:@{@"value":@(1)}];
    [HttpRequestTool postWithURL:url  Parameters:nil requestSerializerType:RequestSerializerTypeHttp  successBlock:^(RequestModel *respondObject) {
        block(respondObject, NO);
        
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
    }];
}

///取消点赞
+ (void)sendUnLikeRequest:(JHPostData *)data block:(HTTPCompleteBlock)block {
    NSString *url= [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/auth/user/like/%ld/%@/%ld"),
                    (long)data.item_type, data.item_id, (long)data.like_num];
    [Growing track:@"like" withVariable:@{@"value":@(0)}];
    [HttpRequestTool deleteWithURL:url Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        block(respondObject, NO);
        
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
    }];
}

// 发评论
+ (void)sendComment:(NSDictionary *)comments postData:(JHPostData *)data block:(HTTPCompleteBlock)block {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params addEntriesFromDictionary:comments];
    [params setValue:data.item_id forKey:@"item_id"];
    [params setValue:@(data.item_type) forKey:@"item_type"];

    [HttpRequestTool postWithURL:COMMUNITY_FILE_BASE_STRING(@"/auth/user/comment") Parameters:params requestSerializerType:RequestSerializerTypeJson  successBlock:^(RequestModel *respondObject) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         
            JHCommentData *commentData = [JHCommentData modelWithJSON:respondObject.data];
         
            dispatch_async(dispatch_get_main_queue(), ^{
                [UITipView showTipStr:@"评论成功"];
                BOOL hasUser = [JHAttributeStringTool hasCallUser:params[@"content"]];
                if (hasUser) {
                    [self statisticsMethodWithItemId:data.item_id itemType:data.item_type commentId:commentData.comment_id];
                }
                block(commentData, NO);
            });
        });
        [SVProgressHUD dismiss];
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [UITipView showTipStr:respondObject.message];
    }];
    //埋点
    [Growing track:@"rate"];
}

+ (void)statisticsMethodWithItemId:(NSString *)itemId itemType:(NSInteger)itemType commentId:(NSString *)commentId {
    User *user = [UserInfoRequestManager sharedInstance].user;
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:user.customerId forKey:@"userId"];
    [params setValue:[CommHelp deviceIDFA] forKey:@"deviceId"];
    [params setValue:@"item_id" forKey:@"item_id"];
    [params setValue:@(itemType) forKey:@"item_type"];
    [params setValue:commentId forKey:@"comment_id"];
    
    [JHAllStatistics jh_allStatisticsWithEventId:@"comment_@_click" params:params type:(JHStatisticsTypeGrowing | JHStatisticsTypeSensors)];
}

+ (void)getHotPostList:(NSString *)dateString completeBlock:(HTTPCompleteBlock)block {
    NSString *url = [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/v2/content/hotList?date=%@"), dateString];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         
            JHHotListModel *model = [JHHotListModel modelWithJSON:respondObject.data];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(model, NO);
                }
            });
        });
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [UITipView showTipStr:respondObject.message];
        if (block) {
            block(respondObject, YES);
        }
    }];
}

+ (void)collectRequest:(JHPostData *)data block:(HTTPCompleteBlock)block {
    [HttpRequestTool postWithURL:COMMUNITY_FILE_BASE_STRING(@"/auth/v1/bbs/section/post/collect")  Parameters:@{@"status":data.is_collect?@(0):@(1),@"post_id":data.item_id} requestSerializerType:RequestSerializerTypeJson  successBlock:^(RequestModel *respondObject)
    {
        NSString * tip = data.is_collect?@"取消收藏成功":@"收藏成功";
        [UITipView showTipStr:tip];
        block(respondObject, NO);
        
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
    }];
}

+ (void)contentlevelRequest:(JHPostData *)data block:(HTTPCompleteBlock)block {
    
    NSLog(@"1");
    [HttpRequestTool postWithURL:COMMUNITY_FILE_BASE_STRING(@"/auth/v1/bbs/section/post/set_best")  Parameters:@{@"status":data.content_level==1?@(0):@(1),@"post_id":data.item_id} requestSerializerType:RequestSerializerTypeJson  successBlock:^(RequestModel *respondObject) {
        if (data.content_level==1) {
            [UITipView showTipStr:@"取消成功"];
        }else{
            [UITipView showTipStr:@"设置成功"];
        }
           block(respondObject, NO);
       } failureBlock:^(RequestModel *respondObject) {
           [UITipView showTipStr:respondObject.message];
       }];
}
+ (void)topRequest:(JHPostData *)data block:(HTTPCompleteBlock)block {
    
    [HttpRequestTool postWithURL:COMMUNITY_FILE_BASE_STRING(@"/auth/v1/bbs/section/post/set_top")  Parameters:@{@"status":data.content_style==2?@(0):@(1),@"post_id":data.item_id} requestSerializerType:RequestSerializerTypeJson  successBlock:^(RequestModel *respondObject) {
        if (data.content_style==2) {
            [UITipView showTipStr:@"取消成功"];
        }else{
            [UITipView showTipStr:@"设置成功"];
        }
           block(respondObject, NO);
       } failureBlock:^(RequestModel *respondObject) {
           [UITipView showTipStr:respondObject.message];
       }];
}
+ (void)noticeRequest:(JHPostData *)data block:(HTTPCompleteBlock)block {
    [HttpRequestTool postWithURL:COMMUNITY_FILE_BASE_STRING(@"/auth/v1/bbs/section/post/set_notice")  Parameters:@{@"status":data.content_style==3?@(0):@(1),@"post_id":data.item_id} requestSerializerType:RequestSerializerTypeJson  successBlock:^(RequestModel *respondObject) {
        if (data.content_style==3) {
            [UITipView showTipStr:@"取消成功"];
        }else{
            [UITipView showTipStr:@"设置成功"];
        }
        block(respondObject, NO);
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
    }];
}

+ (void)muteRequest:(JHPostData *)data reasonId:(NSString *)reasonId timeType:(NSInteger)timeType block:(HTTPCompleteBlock)block {
     NSString * customerId = [UserInfoRequestManager sharedInstance].user.customerId?:@"";
    //    NSString * user_id = mode.plate_info.owner.user_id?:@"";
    NSMutableArray * userid_array = [[NSMutableArray alloc] init];
    for (JHOwnerInfo *info in data.plate_info.owners) {
        if ((OBJ_TO_STRING(info.user_id)).length>0) {
            [userid_array addObject:OBJ_TO_STRING(info.user_id)];
        }
    }
    if ([userid_array containsObject:customerId]) {
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setValue:@0 forKey:@"status"];
        [params setValue:[NSNumber numberWithString:data.publisher.user_id] forKey:@"user_id"];
        [params setValue:reasonId forKey:@"reason"];
        [params setValue:@(timeType) forKey:@"ban_day"];
        
        [HttpRequestTool postWithURL:COMMUNITY_FILE_BASE_STRING(@"/user/forbid_speak")  Parameters:params requestSerializerType:RequestSerializerTypeJson  successBlock:^(RequestModel *respondObject) {
            [UITipView showTipStr:@"禁言成功"];

        } failureBlock:^(RequestModel *respondObject) {
            [UITipView showTipStr:respondObject.message];
        }];
    }
    
}
+ (void)waringRequest:(JHPostData *)data reasonId:(NSString *)reasonId {
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:reasonId forKey:@"reason"];
    [params setValue:data.item_id forKey:@"post_id"];
    [HttpRequestTool postWithURL:COMMUNITY_FILE_BASE_STRING(@"/auth/v1/bbs/section/post/warning")  Parameters:params requestSerializerType:RequestSerializerTypeJson  successBlock:^(RequestModel *respondObject) {
           [UITipView showTipStr:@"警告成功"];
       } failureBlock:^(RequestModel *respondObject) {
           [UITipView showTipStr:respondObject.message];
       }];
}
///这个接口是版主删除帖子
+ (void)deleteRequestAsPlator:(JHPostData *)data reasonId:(NSString *)reasonId block:(HTTPCompleteBlock)block{
    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:reasonId forKey:@"reason"];
    [params setValue:data.item_id forKey:@"post_id"];
    [HttpRequestTool postWithURL:COMMUNITY_FILE_BASE_STRING(@"/auth/v1/bbs/section/post/del")  Parameters:params requestSerializerType:RequestSerializerTypeJson  successBlock:^(RequestModel *respondObject)
    {
        block(respondObject, NO);
        
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
    }];
}

///作者删除帖子
+ (void)deleteRequestAsAuthor:(JHPostData *)data reasonId:(NSString *)reasonId block:(HTTPCompleteBlock)block {
    
    NSString *url= [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/auth/user/content/%ld/%@"), (long)data.item_type, data.item_id];
    [HttpRequestTool deleteWithURL:url Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        if (block) {
            block(respondObject, NO);
        }
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
    }];
}

+ (void)banRequest:(JHPostData *)data reason:(NSString*)note block:(HTTPCompleteBlock)block{
    
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    [dic setObject:@"" forKey:@"image"];
    [dic setObject:data.plate_info.owner.user_id forKey:@"customerId"];
    [dic setObject:note forKey:@"mark"];
    [dic setObject:note forKey:@"reason"];
    [dic setObject:@"1" forKey:@"banFlag"];
    
    [HttpRequestTool postWithURL:COMMUNITY_FILE_BASE_STRING(@"/bans/create") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
          block(respondObject, NO);
    } failureBlock:^(RequestModel *respondObject) {
    }];
}

///获取发布页选择板块列表
+ (void)getPlateSelectList:(JHPlateSelectModel *)model block:(HTTPCompleteBlock)block {
    NSLog(@"获取发布页选择板块列表");
    [HttpRequestTool getWithURL:[model toUrl] Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSArray<JHPlateSelectData *> *list = [NSArray modelArrayWithClass:[JHPlateSelectData class] json:respondObject.data];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (list.count > 0) {
                    block(list, NO);
                } else {
                    block(nil, NO);
                }
            });
        });
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        block(nil, YES);
        [UITipView showTipStr:respondObject.message];
    }];
}


+ (void)getPostDetailInfo:(NSString *)itemType
                   itemId:(NSString *)itemId
                    block:(HTTPCompleteBlock)block {
    ///跟伟哥沟通后entryType和entryId固定写2和0
    NSString *url = [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/content/detail/%@/%@/2/0"),itemType, itemId];
//    url = @"http://39.97.164.118:8080/content/detail/30/5f4dc2ed4a5df138d2e063f9/2/-2";
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            JHPostDetailModel *model = [JHPostDetailModel mj_objectWithKeyValues:respondObject.data];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(model, NO);
                }
            });
        });
    
    } failureBlock:^(RequestModel *respondObject) {
        JHTOAST(respondObject.message);
        if (respondObject.code == 400) {
//            [self.navigationController popViewControllerAnimated:YES];
        }
        if (block) {
            block(respondObject, YES);
        }
    }];
}

///最热评论
+ (void)getHotCommentList:(NSString *)itemId
                 itemType:(NSInteger)itemType
             completation:(HTTPCompleteBlock)block {
    NSString *url = [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/content/commentHotLists/%ld/%@"), (long)itemType, itemId];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        NSArray *commentArray = [JHCommentModel mj_objectArrayWithKeyValuesArray:respondObject.data[@"list"]];
        if (block) {
            block(commentArray, NO);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(nil, YES);
        }
    }];
}

///获取全部评论
+ (void)getAllCommentList:(NSString *)itemId
                 itemType:(NSInteger)itemType
                     page:(NSInteger)page
                   lastId:(NSString *)lastId
                filterIds:(NSString *)filterIds
             completation:(HTTPCompleteBlock)block {
    NSString *url = [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/content/commentListsAll/%ld/%@/%@/%ld/%@"), (long)itemType, itemId, lastId, (long)page, filterIds];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(respondObject, NO);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(nil, YES);
        }
    }];
}



// 添加评论
+ (void)submitCommentWithCommentInfos:(NSDictionary *)commentInfos
               itemId:(NSString *)itemId
             itemType:(NSInteger)itemType
        completeBlock:(HTTPCompleteBlock)block {
        
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:itemId forKey:@"item_id"];
    [parameters setValue:@(itemType) forKey:@"item_type"];
    [parameters addEntriesFromDictionary:commentInfos];

    [HttpRequestTool postWithURL:COMMUNITY_FILE_BASE_STRING(@"/auth/user/comment") Parameters:parameters.copy requestSerializerType:RequestSerializerTypeJson  successBlock:^(RequestModel *respondObject) {
        JHCommentModel *model = [JHCommentModel mj_objectWithKeyValues:respondObject.data];
        BOOL hasUser = [JHAttributeStringTool hasCallUser:parameters[@"content"]];
        if (hasUser) {
            [self statisticsMethodWithItemId:itemId itemType:@(itemType).stringValue commentId:model.comment_id];
        }

        if (block) {
            block(respondObject, NO);
        }
        [SVProgressHUD dismiss];
    } failureBlock:^(RequestModel *respondObject) {
        if (block) {
            block(respondObject, YES);
        }
        [SVProgressHUD dismiss];
    }];
}

//回复主评论
+ (void)submitCommentReplay:(NSDictionary *)params
              completeBlock:(HTTPCompleteBlock)block {
    
    [HttpRequestTool postWithURL:COMMUNITY_FILE_BASE_STRING(@"/auth/user/commentReply")  Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        JHCommentModel *model = [JHCommentModel mj_objectWithKeyValues:respondObject.data];
        if (model) {
            BOOL hasUser = [JHAttributeStringTool hasCallUser:params[@"content"]];
            if (hasUser) {
                [self statisticsMethodWithItemId:params[@"item_id"] itemType:[params[@"item_type"] integerValue] commentId:model.comment_id];
            }
        }
        if (block) {
            block(respondObject, NO);
        }
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [UITipView showTipStr:[respondObject.message isNotBlank] ? respondObject.message : @"评论失败"];
        if (block) {
            block(respondObject, YES);
        }
    }];
//    //埋点
//    [Growing track:@"rate"];
}

//评论列表 (从2页开始)
+ (void)requestPostDetailCommentListWithItemType:(NSString *)itemType
                                      itemId:(NSString *)itemId
                                        lastId:(NSString *)lastId
                                       sortNum:(NSInteger)sortNum
                                         page:(NSInteger)page
                                     filterIds:(NSString *)filterIds
                                      completeBlock:(HTTPCompleteBlock)block {

    NSString *url = [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/content/commentList/%@/%@/%@/%@/%ld/%@"),itemType, itemId, lastId, @(sortNum), page, filterIds];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        if (block) {
            block(respondObject, NO);
        }

    } failureBlock:^(RequestModel *respondObject) {
        if (block) {
            block(respondObject, YES);
        }
    }];
}

//回复列表
+ (void)requestPostDetailReplyListWithCommentId:(NSString *)commentId
                                           lastId:(NSInteger)lastId
                                            page:(NSInteger)page
                                        filterIds:(NSString *)filterIds
                                         completeBlock:(HTTPCompleteBlock)block {

    NSString *url = [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/content/commentReplyList/%@/%@/%@/%@"),commentId, @(lastId), @(page), filterIds];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        if (block) {
            block(respondObject, NO);
        }
    } failureBlock:^(RequestModel *respondObject) {
        if (block) {
            block(respondObject, YES);
        }
    }];
}


//删除评论
+ (void)deletePostDetailCommentWithCommentId:(NSString *)comment_id
                                      reasonId:(NSString *)reasonId
                              completeBlock:(HTTPCompleteBlock)block {
    NSString *url= [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/auth/user/commentRea/%@/%@"), comment_id,reasonId];
    if(!reasonId)
    {
        url= [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/auth/user/comment/%@"), comment_id];
    }
    [HttpRequestTool deleteWithURL:url Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        if (block) {
            block(respondObject, NO);
        }
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        if (block) {
            block(respondObject, YES);
        }
    }];
}

//删除评论
+ (void)deletePublishPostDetailCommentWithCommentId:(NSString *)comment_id
                                      reasonId:(NSString *)reasonId
                              completeBlock:(HTTPCompleteBlock)block {
    NSString *url= [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/auth/user/commentRea/%@/%@"), comment_id,reasonId];
    if(!reasonId)
    {
        url= [NSString stringWithFormat:COMMUNITY_FILE_BASE_STRING(@"/auth/user/product_comment/%@"), comment_id];
    }
    [HttpRequestTool deleteWithURL:url Parameters:nil requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        if (block) {
            block(respondObject, NO);
        }
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        if (block) {
            block(respondObject, YES);
        }
    }];
}

/// 禁言
+ (void)muteRequestWithUserId:(NSString *)userId
                       reasonId:(NSString *)reasonId
                     timeType:(NSInteger)timeType
                        block:(HTTPCompleteBlock)block {

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@(0) forKey:@"status"];
    [params setValue:[NSNumber numberWithString:userId] forKey:@"user_id"];
    [params setValue:reasonId forKey:@"reason"];
    [params setValue:@(timeType) forKey:@"ban_day"];

    [HttpRequestTool postWithURL:COMMUNITY_FILE_BASE_STRING(@"/user/forbid_speak") Parameters:params requestSerializerType:RequestSerializerTypeJson  successBlock:^(RequestModel *respondObject) {
        if (block) {
            block(respondObject, NO);
        }
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
    }];
}

/// 封号
+ (void)banRequest:(NSString *)itemId
          itemType:(NSInteger)itemType
            userId:(NSString *)userId
            reason:(NSString*)note
             block:(HTTPCompleteBlock)block {
    
    NSMutableDictionary * dic=[NSMutableDictionary dictionary];
    [dic setObject:@"" forKey:@"image"];
    [dic setObject:userId forKey:@"customerId"];
    [dic setObject:note forKey:@"mark"];
    [dic setObject:note forKey:@"reason"];
    [dic setObject:@"1" forKey:@"banFlag"];
    
    [HttpRequestTool postWithURL:COMMUNITY_FILE_BASE_STRING(@"/bans/create") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        if (block) {
            block(respondObject, NO);
        }
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
    }];
}


/// 警告
+ (void)warningRequest:(NSString *)itemId
             itemType:(NSInteger)itemType
                userId:(NSString *)userId
                reasonId:(NSString*)reasonId
                 block:(HTTPCompleteBlock)block {
    
    if(!reasonId)
    {
        reasonId = @0;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:itemId forKey:@"item_id"];
    [params setValue:@(itemType) forKey:@"item_type"];
    [params setValue:@(userId.integerValue) forKey:@"user_id"];
    [params setValue:reasonId forKey:@"reason"];
    [HttpRequestTool postWithURL:COMMUNITY_FILE_BASE_STRING(@"/auth/v1/guard/warning")  Parameters:params requestSerializerType:RequestSerializerTypeJson  successBlock:^(RequestModel *respondObject) {
        if (block) {
            block(respondObject, NO);
        }
    } failureBlock:^(RequestModel *respondObject) {
        [UITipView showTipStr:respondObject.message];
    }];
}

+ (void)searchInfoWithChannelId:(NSInteger)channelId
                        keyword:(NSString *)keyword
                           type:(NSString *)type
                           page:(NSInteger)page
                  completeBlock:(HTTPCompleteBlock)block {

    NSDictionary * parameters = @{
                                @"channel_id":@(channelId),
                                @"q":keyword,
                                @"type":@([type intValue]),
                                @"page":@(page)
                                };
    
    [HttpRequestTool postWithURL:COMMUNITY_FILE_BASE_STRING(@"/v1/search")  Parameters:parameters requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        if (block) {
            block(respondObject, NO);
        }
    } failureBlock:^(RequestModel *respondObject) {
        if (block) {
            block(respondObject, YES);
        }
    }];
}

///获取用户最新发的审核中的帖子信息接口
+ (void)getPostDetailInfoPublishByNow:(HTTPCompleteBlock)block {
    [HttpRequestTool getWithURL:COMMUNITY_FILE_BASE_STRING(@"/v2/user/history?type=9") Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        JHPostData *data = [JHPostData modelWithJSON:respondObject.data];
        if (block) {
            block(data, NO);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(respondObject, YES);
        }
    }];
}

@end
