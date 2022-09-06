//
//  JHFoucsListShopViewModel.m
//  TTjianbao
//
//  Created by apple on 2020/2/14.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHFoucsListShopViewModel.h"
#import <SVProgressHUD.h>

@implementation JHFoucsListShopViewModel
/// page 1开始
-(void)requestCommonDataWithSubscriber:(id<RACSubscriber>)subscriber
{
    if (self.pageIndex == 1) {
        [self.dataArray removeAllObjects];
    }
    
//    NSString *urlStr = COMMUNITY_FILE_BASE_STRING(@"/auth/mall/shop/listFollow");
    
    NSDictionary *par = @{
        @"pageNo" : @(self.pageIndex),
        @"pageSize" : @(self.pageSize),
    };
    // 10000102
    NSString *url = FILE_BASE_STRING(@"/auth/mall/shop/listFollow");
    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
      
        if (IS_ARRAY(respondObject.data)) {
            [self.dataArray addObjectsFromArray:[JHFoucsShopInfo mj_objectArrayWithKeyValuesArray:respondObject.data]];
        }
        self.pageIndex += 1;
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [SVProgressHUD showInfoWithStatus:respondObject.message];
        [subscriber sendNext:@1];
        [subscriber sendCompleted];
    }];
}

///关注店铺/取消关注店铺 当前model
+ (void)foucsShopWithModel:(JHFoucsShopInfo *)model
             completeBlock:(dispatch_block_t)completeBlock{
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVC];
        return;
    }
    
    BOOL isFollow = (model.followed.intValue == 1);
    
    ///isFollow == yes  关注状态为已关注 需要调用取消关注的接口
    ///isFollow == no  关注状态为未关注 需要调用关注的接口
    NSString *type = isFollow ? @"0" : @"1";
    NSDictionary *par = [NSMutableDictionary dictionary];
    [par setValue:model.sellerId forKey:@"shopId"];
    [par setValue:type forKey:@"type"];

    NSString *url = FILE_BASE_STRING(@"/auth/mall/shop/follow");
    [HttpRequestTool postWithURL:url Parameters:par requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        [self changeFocusStatuModel:model];
        if(completeBlock)
        {
            completeBlock();
        }
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [SVProgressHUD showInfoWithStatus:respondObject.message];
    }];
}

+(void)changeFocusStatuModel:(JHFoucsShopInfo *)model
{
    BOOL isFollow = (model.followed.intValue == 1);
    
    model.followNum = isFollow ? (model.followNum - 1) : (model.followNum + 1);
    model.followed = isFollow ? @0 : @1;
}

///关注店铺/用户 数量
+ (void)foucsShopAndUserWithUserId:(NSInteger)userId ompleteBlock:(void(^)(JHFoucsUserAndShopNumModel *model))completeBlock{
    
    
    RACSubject *subject1 = [RACSubject subject];
    RACSubject *subject2 = [RACSubject subject];
    
    [HttpRequestTool getWithURL:COMMUNITY_FILE_BASE_STRING(@"/v2/user/follow_stats") Parameters:@{@"tid" : @(userId)} successBlock:^(RequestModel * _Nullable respondObject) {
        if(IS_DICTIONARY(respondObject.data))
        {
            [subject1 sendNext:respondObject.data];
        }
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
    
    // 3.7.0新增获取店铺关注数
    NSString *url = FILE_BASE_STRING(@"/auth/mall/follow/info");
    
    [HttpRequestTool postWithURL:url Parameters:@{} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if(IS_DICTIONARY(respondObject.data))
        {
            [subject2 sendNext:respondObject.data];
        }
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];
    
    RACSignal *combin = [subject1 combineLatestWith:subject2];
    
    [combin subscribeNext:^(id  _Nullable x) {
        if (x == nil) { return; }
        if (x[0] == nil) { return;}
        if (x[1] == nil) { return;}
        NSDictionary *shopDic = (NSDictionary *)x[1];
        JHFoucsUserAndShopNumModel *model = [JHFoucsUserAndShopNumModel mj_objectWithKeyValues:x[0]];
        model.shop_num = [shopDic integerValueForKey:@"shopNum" default:0];
        if(completeBlock)
        {
            completeBlock(model);
        }
        
    }];
}

@end
