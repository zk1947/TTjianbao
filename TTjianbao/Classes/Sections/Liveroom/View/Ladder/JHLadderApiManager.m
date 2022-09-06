//
//  JHLadderApiManager.m
//  TTjianbao
//
//  Created by wuyd on 2020/7/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLadderApiManager.h"

@implementation JHLadderApiManager

///获取用户津贴列表数据
+ (void)getLadderList:(JHLadderModel *)model block:(HTTPCompleteBlock)block {
    if(!model || [[model toListUrl] length] <= 0)
        return;
    NSLog(@"<阶梯津贴列表 Url：%@\n阶梯津贴列表 Url：params：%@>", [model toListUrl], [model toListParams]);
    [HttpRequestTool postWithURL:[model toListUrl] Parameters:[model toListParams] requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        NSArray<JHLadderData *> *list = [NSArray modelArrayWithClass:[JHLadderData class] json:respondObject.data];
        JHLadderModel *aModel = [[JHLadderModel alloc] init];
        aModel.list = list.mutableCopy;
        block(aModel, NO);
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        block(nil, YES);
    }];
}

///领取津贴
+ (void)sendReceiveRequest:(JHLadderModel *)model block:(HTTPCompleteBlock)block {
    NSLog(@"<领取津贴 Url：%@>", [model toReceiveUrl]);
    model.isLoading = YES;
    [HttpRequestTool postWithURL:[model toReceiveUrl] Parameters:[model toReceiveParams] requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        model.isLoading = NO;
        block(respondObject.data, NO);
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        model.isLoading = NO;
        block(nil, YES);
        [UITipView showTipStr:respondObject.message];
    }];
}

@end
