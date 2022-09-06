//
//  JHPlateDetailListViewModel.m
//  TTjianbao
//
//  Created by wangjianios on 2020/9/3.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHPlateDetailListViewModel.h"
#import "JHSQUploadManager.h"

@implementation JHPlateDetailListViewModel

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
                JHPostData *data = [JHSQUploadManager shareInstance].localPostInfo;
                if(data.plate_info && [data.plate_info.ID isEqualToString:self.reqModel.channel_id])
                {
                    [self.dataArray addObject:data];
                }
            }];
        }
        self.reqModel.page ++;
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

- (JHPlateDetailListReqModel *)reqModel
{
    if(!_reqModel)
    {
        _reqModel = [JHPlateDetailListReqModel new];
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
