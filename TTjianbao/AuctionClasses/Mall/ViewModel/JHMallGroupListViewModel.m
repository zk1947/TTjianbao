//
//  JHJHMallGroupListViewModel.m
//  TTjianbao
//
//  Created by apple on 2020/3/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallGroupListViewModel.h"
#import "JHLiveRoomMode.h"

@implementation JHMallGroupListViewModel

- (void)requestCommonDataWithSubscriber:(id<RACSubscriber>)subscriber
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:3];
    [dic setValue:self.groupIdListStr forKey:@"groupIdList"];
    [dic setValue:@(self.pageIndex) forKey:@"pageNo"];
    [dic setValue:@(self.pageSize) forKey:@"pageSize"];
    if(self.pageIndex == 0)
    {
        [self.dataArray removeAllObjects];
    }
    
    [JHMallGroupListViewModel requestListWithParameters:dic block:^(BOOL success, NSArray *data) {
       if(success)
       {
           [self.dataArray addObjectsFromArray:[JHLiveRoomMode mj_objectArrayWithKeyValuesArray:data]];
       }
        self.pageIndex += 1;
        [subscriber sendNext:@YES];
        [subscriber sendCompleted];
    }];
}

+(void)requestListWithParameters:(NSDictionary *)parameters block:(void(^)(BOOL success,NSArray *data))block
{
    if(!block)
    {
        return;
    }
    [HttpRequestTool getWithURL: FILE_BASE_STRING(@"/channel/sellByGroupList") Parameters:parameters successBlock:^(RequestModel *respondObject) {
        block(IS_ARRAY(respondObject.data),respondObject.data);
       } failureBlock:^(RequestModel *respondObject) {
           block(NO,@[]);
       }];
}

-(NSString *)groupIdListStr
{
    if(!_groupIdListStr)
    {
        NSMutableString *groupIdList1 = [NSMutableString string];
        for (NSString *ID in self.groupIdArray) {
            [groupIdList1 appendFormat:@",%@",ID];
        }
        _groupIdListStr = [groupIdList1 substringFromIndex:1];
    }
    return _groupIdListStr;
}

@end
