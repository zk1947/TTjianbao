//
//  JHRedPacketDetailViewModel.m
//  TTjianbao
//
//  Created by apple on 2020/1/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRedPacketDetailViewModel.h"
#import <SVProgressHUD.h>
#import "JHRedpacketDataModel.h"

@implementation JHRedPacketDetailViewModel

-(void)requestCommonDataWithSubscriber:(id<RACSubscriber>)subscriber
{
    if(self.pageIndex == 0)
    {
        NSString *urlStr = FILE_BASE_STRING(@"/app/red-packet/get");
        [HttpRequestTool postWithURL:urlStr Parameters:@{@"redPacketId" : self.redPacketId} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
            self.dataSources = [JHGetRedpacketModel mj_objectWithKeyValues:respondObject.data];
            [subscriber sendNext:@1];
            [subscriber sendCompleted];
        } failureBlock:^(RequestModel *respondObject) {
            [SVProgressHUD showInfoWithStatus:respondObject.message];
            [subscriber sendCompleted];
        }];
    }
    else
    {
        if(self.dataSources.takeList.count > 0)
        {
            
            JHGetRedpacketDetailModel *model = [self.dataSources.takeList lastObject];
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
            [params setValue:model.redPacketTakeId forKey:@"lastRedPacketTakeId"];
            [params setValue:@(self.pageSize) forKey:@"pageSize"];
            [params setValue:self.redPacketId forKey:@"redPacketId"];

            NSString *urlStr = FILE_BASE_STRING(@"/app/red-packet/list-take");
            [HttpRequestTool postWithURL:urlStr Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {

                [self.dataSources.takeList addObjectsFromArray:[JHGetRedpacketDetailModel mj_objectArrayWithKeyValuesArray:respondObject.data]];

                [subscriber sendNext:@1];
                [subscriber sendCompleted];
            } failureBlock:^(RequestModel *respondObject) {
                [SVProgressHUD showInfoWithStatus:respondObject.message];
                [subscriber sendCompleted];
            }];
            
            
             
//             JHGetRedpacketDetailModel *model = [self.dataSources.takeList lastObject];
//             JHGetRedpacketDetailPageModel *req = [JHGetRedpacketDetailPageModel new];
//             req.lastRedPacketTakeId = model.redPacketTakeId;
//             req.pageSize = self.pageSize;
//             req.redPacketId = self.redPacketId;
//             [[JHRedpacketDataModel new] requestGetRedpacketDetailWithModel:req PageData:^(id respData, NSString *errorMsg) {
//                 if(IS_ARRAY(respData))
//                 {
//                     [self.dataSources.takeList addObjectsFromArray:[JHGetRedpacketDetailModel mj_objectArrayWithKeyValuesArray:respData]];
//                 }
//                 [subscriber sendNext:@1];
//                 [subscriber sendCompleted];
//             }];
        }
        else
        {
            [subscriber sendCompleted];
        }
    }
}

+(void)openRedPacketWithRedPacketId:(NSString *)redPacketId CompleteBlock:(nonnull void (^)(BOOL, JHGetRedpacketModel * _Nonnull, NSString * _Nonnull))completeBlock
{
    NSString *urlStr = FILE_BASE_STRING(@"/app/red-packet/take");
    [HttpRequestTool postWithURL:urlStr Parameters:@{@"redPacketId" : redPacketId} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        JHGetRedpacketModel *model = [JHGetRedpacketModel mj_objectWithKeyValues:respondObject.data];
        model.conditionCheckFlag = (respondObject.code == 1001 ? 1 : 0);
        if(completeBlock){
            completeBlock(model.resultCode, model, respondObject.message);
        }
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD showInfoWithStatus:respondObject.message];
    }];
}

-(JHGetRedpacketModel *)dataSources
{
    if(!_dataSources){
        _dataSources = [JHGetRedpacketModel new];
        if (!_dataSources.takeList) {
            _dataSources.takeList = [NSMutableArray array];
        }
    }
    return _dataSources;
}
@end
