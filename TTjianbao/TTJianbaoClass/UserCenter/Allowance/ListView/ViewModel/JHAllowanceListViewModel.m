//
//  JHAllowanceListViewModel.m
//  TTjianbao
//
//  Created by apple on 2020/2/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "JHAllowanceListModel.h"
#import "JHAllowanceListViewModel.h"
#import <SVProgressHUD.h>
@implementation JHAllowanceListViewModel

-(void)requestCommonDataWithSubscriber:(id<RACSubscriber>)subscriber
{
    NSDictionary *parameters = @{@"pageNo" : @(self.pageIndex),
                                 @"pageSize" : @(self.pageSize),
                                 @"type" : @(self.type)};
    NSString *url = FILE_BASE_STRING(@"/auth/v2/bountyLog");
    if(self.pageIndex == 0)
    {
        [self.dataArray removeAllObjects];
    }
    [HttpRequestTool getWithURL:url Parameters:parameters successBlock:^(RequestModel *respondObject) {
        if (IS_ARRAY(respondObject.data)) {
            NSArray *array = respondObject.data;
            self.isNoMoreData = (array.count < self.pageSize);
            [self.dataArray addObjectsFromArray:[JHAllowanceListModel mj_objectArrayWithKeyValuesArray:respondObject.data]];
            self.pageIndex += 1;
        }
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD showErrorWithStatus:respondObject.message];
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
    }];
}

+(void)requestAllowanceTotalBlock:(void(^)(JHAllowanceTotalModel *model))block
{
    NSString *url = FILE_BASE_STRING(@"/auth/getBountyInfo");
    [HttpRequestTool getWithURL:url Parameters:@{} successBlock:^(RequestModel *respondObject) {
        if(IS_DICTIONARY(respondObject.data) && block)
        {
            JHAllowanceTotalModel *model = [JHAllowanceTotalModel mj_objectWithKeyValues:respondObject.data];
            block(model);
        }
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD showErrorWithStatus:respondObject.message];
    }];
}

///获取活动内容
+ (void)requestActivityBlock:(void(^)(NSString *imgUrl,NSString *webUrl))block;
{
    NSString *url = FILE_BASE_STRING(@"/activity/api/balance/activity/list");
    [HttpRequestTool getWithURL:url Parameters:@{} successBlock:^(RequestModel *respondObject) {
        NSDictionary *data = respondObject.data;
        if(IS_DICTIONARY(respondObject.data) && block)
        {
            NSArray *content = [data valueForKey:@"content"];
            if(content && IS_ARRAY(content) && content.firstObject)
            {
                NSDictionary *param = content.firstObject;
                block([param valueForKey:@"img"],[param valueForKey:@"url"]);
            }
        }
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD showErrorWithStatus:respondObject.message];
    }];
}

@end
