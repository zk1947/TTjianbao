//
//  JHTopicDetailListViewModel.m
//  TTjianbao
//
//  Created by wangjianios on 2020/8/31.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHTopicDetailListViewModel.h"
#import "JHSQUploadManager.h"

@implementation JHTopicDetailListViewModel

- (void)requestCommonDataWithSubscriber:(id<RACSubscriber>)subscriber
{
    [JH_REQUEST asynGet:_reqModel subQueueSuccess:^(id respData) {
        
        if(self.reqModel.page == 1)
        {
            [self.dataArray removeAllObjects];
            [self.playVideoUrls removeAllObjects];
        }
        NSArray<JHPostData *> *list = [NSArray modelArrayWithClass:[JHPostData class] json:respData];
        [self configDataList:list];
        
        ///如果是刷新操作 并且 存在刚发布的帖子信息  如果是全部页面 执行下面逻辑
        if (self.pageIndex == 0 &&
            self.reqModel.page == 1 &&
            [JHSQUploadManager shareInstance].localPostInfo) {
            
            [JHSQUploadManager updatePostInfoPublishedByNow:^{
                BOOL isSHow = NO;
                JHPostData *data = [JHSQUploadManager shareInstance].localPostInfo;
                if(IS_ARRAY(data.topics)) {
                    for (JHTopicInfo *t in data.topics) {
                        if(IS_STRING(self.reqModel.topic_id)) {
                            if([self.reqModel.topic_id isEqualToString:t.ID]) {
                                isSHow = YES;
                            }
                        }
                    }
                }
                if(isSHow) {
                    [self.dataArray addObject:data];
                }
                
            }];
        }
        
        self.reqModel.page += 1;
        dispatch_async(dispatch_get_main_queue(), ^{
            [subscriber sendNext:@YES];
            [subscriber sendCompleted];
        });
        
    } subQueueFailure:^(NSString *errorMsg) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [subscriber sendNext:@NO];
            [subscriber sendCompleted];
        });
    }];
}

- (void)requestMoreData:(HTTPCompleteBlock)completeBlock {
    [JH_REQUEST asynGet:_reqModel subQueueSuccess:^(id respData) {
        NSArray<JHPostData *> *list = [NSArray modelArrayWithClass:[JHPostData class] json:respData];
        if (list.count <= 0) {
            return;
        }
        JHPostData *model = list.lastObject;
        self.reqModel.last_date = model.last_date;
        
        NSMutableArray<NSURL *> *urlList = [NSMutableArray new];
        NSMutableArray <JHPostData *>*dataList = [NSMutableArray array];
        for (JHPostData *data in list) {
            //配置帖子内容
            BOOL isNormal = data.item_type == JHPostItemTypePost;
            [data configPostContent:data.content isNormal:isNormal];
            data.listIndex = self.dataArray.count;
            [dataList addObject:data];
            [self.dataArray addObject:data];
            
            //配置视频url
            if (data.item_type == JHPostItemTypeVideo) {
                [urlList addObject:[NSURL URLWithString:data.video_info.url]];
            } else {
                [urlList addObject:[NSURL URLWithString:@""]];
            }
        }
        [self.playVideoUrls addObjectsFromArray:urlList];
        self.reqModel.page += 1;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completeBlock) {
                completeBlock(dataList.copy, NO);
            }
        });
        
    } subQueueFailure:^(NSString *errorMsg) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completeBlock) {
                completeBlock(errorMsg, YES);
            }
        });
    }];
}

- (void)configDataList:(NSArray<JHPostData *> *)dataList {
    if (dataList.count <= 0) {
        return;
    }
    JHPostData * m = dataList.lastObject;
    self.reqModel.last_date = m.last_date;
    
    NSMutableArray<NSURL *> *urlList = [NSMutableArray new];
    for (JHPostData *data in dataList) {
        //配置帖子内容
        BOOL isNormal = data.item_type == JHPostItemTypePost;
        [data configPostContent:data.content isNormal:isNormal];
        data.listIndex = self.dataArray.count;
        [self.dataArray addObject:data];
        
        //配置视频url
        if (data.item_type == JHPostItemTypeVideo) {
            [urlList addObject:[NSURL URLWithString:data.video_info.url]];
        } else {
            [urlList addObject:[NSURL URLWithString:@""]];
        }
    }
    [self.playVideoUrls addObjectsFromArray:urlList];
}

- (JHTopicDetailListReqModel *)reqModel
{
    if(!_reqModel)
    {
        _reqModel = [JHTopicDetailListReqModel new];
    }
    return _reqModel;
}

- (NSMutableArray *)playVideoUrls
{
    if(!_playVideoUrls)
    {
        _playVideoUrls = [NSMutableArray array];
    }
    return _playVideoUrls;
}
@end
