//
//  JHRedpacketDataModel.m
//  TTjianbao
//
//  Created by Jesse on 2020/1/8.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRedpacketDataModel.h"

@implementation JHRedpacketDataModel

//请求“创建红包页”需要条件数据
- (void)requestMakeRedpacketPageData:(NSString*)channelId resp:(JHResponse)response
{
    JHMakeRedpacketPageReqModel* req = [JHMakeRedpacketPageReqModel new];
    req.channelId = channelId;
    [self request:req finish:^(id respData, NSString *errorMsg) {
        JHMakeRedpacketPageModel* model = nil;
        if(respData)
        {
            model = [JHMakeRedpacketPageModel convertData:respData];
        }
        //返回数据？？
        response(model, errorMsg);
    }];
}

//“塞钱进红包”请求
- (void)makeRedpacketRequest:(JHMakeRedpacketReqModel*)reqModel respone:(JHResponse)response
{
    [self request:reqModel finish:^(id respData, NSString *errorMsg) {
        JHMakeRedpacketModel* model = nil;
        if(respData)
        {
            model = [JHMakeRedpacketModel convertData:respData];
        }
        //返回数据？？
        response(model, errorMsg);
    }];
}

- (void)request:(JHReqModel*)model finish:(JHResponse)resp
{
    [JH_REQUEST asynPost:model success:^(id respData) {
        
        resp(respData, [JHRespModel nullMessage]);
    } failure:^(NSString *errorMsg) {
        resp([JHRespModel nullMessage], errorMsg);
    }];
}

///请求红包分页
- (void)requestGetRedpacketDetailWithModel:(JHGetRedpacketDetailPageModel *)paramModel PageData:(JHResponse)response;
{
    [self request:paramModel finish:^(id respData, NSString *errorMsg) {
        JHMakeRedpacketPageModel* model = nil;
        if(respData)
        {
            model = [JHMakeRedpacketPageModel convertData:respData];
        }
        //返回数据？？
        response(model, errorMsg);
    }];
}

@end
