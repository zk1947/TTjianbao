//
//  JHBillDetailViewModel.m
//  TTjianbao
//
//  Created by apple on 2019/12/16.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBillDetailViewModel.h"
#import "SVProgressHUD.h"
#import "UserInfoRequestManager.h"
#import "TTjianbaoMarcoKeyword.h"

@implementation JHBillDetailViewModel

-(void)requestCommonDataWithSubscriber:(id<RACSubscriber>)subscriber
{
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    [param setValue:@(self.pageIndex) forKey:@"pageIndex"];
    [param setValue:@(10) forKey:@"pageSize"];
    if (self.status>0) {
        [param setValue:@(self.status) forKey:@"status"];
    }
    
//    UserInfoRequestManager *user = [UserInfoRequestManager sharedInstance];
//    [param setValue:@(user.user.type) forKey:@"customerType"];
//    [param setValue:user.user.customerId forKey:@"customerId"];
    
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/account-info/detail-list-new") Parameters:param requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        NSArray *array = [respondObject.data valueForKey:@"rows"];
        if(IS_ARRAY(array))
        {
            if (self.pageIndex == 0 && self.dataArray.count) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:[JHBillDetailModel mj_objectArrayWithKeyValuesArray:array]];
        }
        self.pageIndex += 1;
        [subscriber sendNext:@1];
        [subscriber sendCompleted];

    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD showErrorWithStatus:respondObject.message];
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
    }];
}

+(NSString*)numberFormatter:(NSNumber*)number
{
    return [NSNumberFormatter localizedStringFromNumber:number numberStyle:NSNumberFormatterCurrencyStyle];
}

@end
