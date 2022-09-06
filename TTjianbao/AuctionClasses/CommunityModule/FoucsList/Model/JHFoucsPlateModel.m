//
//  JHFoucsPlateModel.m
//  TTjianbao
//
//  Created by apple on 2020/9/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHFoucsPlateModel.h"
#import "SVProgressHUD.h"
#import "YYKit/YYKit.h"

@implementation JHFoucsPlateModel
-(id)init{
    self = [super init];
    self.is_follow = YES;
    return self;
}
+ (void)requestFoucsPlateWithId:(NSString *)last_id
                         userId:(NSString *)userId
                   successBlock:(void(^)(NSMutableArray * array))succBlock
                      failBlock:(void(^)(RequestModel * _Nonnull reqModel))failBlock {

    NSMutableDictionary *params = [NSMutableDictionary new];
    [params setValue:last_id forKey:@"last_id"];
    [params setValue:userId forKey:@"tid"];
    
    [HttpRequestTool getWithURL:COMMUNITY_FILE_BASE_STRING(@"/v2/user/channel/follow_list") Parameters:params successBlock:^(RequestModel * _Nullable respondObject) {
        NSMutableArray * array = [JHFoucsPlateModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        succBlock(array);
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        failBlock(respondObject);
    }];
}

///关注店铺/取消关注店铺 当前model
+ (void)foucsPlateWithModel:(JHFoucsPlateModel *)model isCancel:(BOOL)isCancel
              completeBlock:(dispatch_block_t)completeBlock failBlock:(dispatch_block_t)failBlock{
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVC];
        return;
    }
    
    ///isCancel == yes  取消关注的接口
    ///isCancel == no  关注的接口
    NSString *str = isCancel ? @"followCancel" : @"follow";
    NSString *url = [NSString stringWithFormat: COMMUNITY_FILE_BASE_STRING(@"/auth/channel/%@"), str];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:[NSNumber numberWithString:model.channel_id] forKey:@"channel_id"];
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        
        if(completeBlock)
        {
            completeBlock();
        }
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD showInfoWithStatus:respondObject.message];
        if (failBlock) {
            failBlock();
        }
    }];
}

- (void)mj_didConvertToObjectWithKeyValues:(NSDictionary *)keyValues
{
    _scan_num = [self getNumStringWithNum:_scan_num];
    _comment_num = [self getNumStringWithNum:_comment_num];
    _content_num = [self getNumStringWithNum:_content_num];
}

-(NSString *)getNumStringWithNum:(NSString *)numStr
{
    CGFloat num = numStr.floatValue;
    
    if(num < 10000)
    {
        return numStr;
    }
    else
    {
        return [NSString stringWithFormat:@"%.1fw",num / 10000.0];
    }
}

@end
