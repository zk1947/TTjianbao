//
//  JHLotteryDataManager.m
//  TTjianbao
//
//  Created by wuyd on 2020/7/17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLotteryDataManager.h"

@implementation JHLotteryDataManager

#pragma mark -
#pragma mark - 数据处理

///返回媒体播放组件需要的类型数据
+ (NSMutableArray<YDMediaData *> *)mediaSourceFromMediaList:(NSMutableArray<JHLotteryMediaData *> *)mediaList {
    NSMutableArray<YDMediaData *> *mediaSource = [NSMutableArray new];
    for (NSInteger i = 0; i < mediaList.count; i++) {
        JHLotteryMediaData *data = mediaList[i];
        YDMediaData *media = [YDMediaData new];
        
        media.isVideo = data.type == 1;
        if (data.type == 1) {
            media.videoUrl = data.url;
            media.imageUrl = data.coverImg;
        } else {
            media.imageUrl = data.url;
        }
        [mediaSource addObject:media];
    }
    return mediaSource;
}

#pragma mark -
#pragma mark - 网络请求
+ (void)getLotteryList:(JHLotteryModel *)model block:(HTTPCompleteBlock)block {
    NSLog(@"<Request Url = %@>", [model toUrl]);
    model.isLoading = YES;
    [HttpRequestTool getWithURL:[model toUrl] Parameters:@{@"page" : @(model.page)} successBlock:^(RequestModel * _Nullable respondObject) {
        model.isLoading = NO;
        
        JHLotteryDialog *dialog = [JHLotteryDialog modelWithJSON:respondObject.data[@"dialog"]];
        NSArray<JHLotteryData *> *list = [NSArray modelArrayWithClass:[JHLotteryData class] json:respondObject.data[@"content"]];
        
        JHLotteryModel *aModel = [[JHLotteryModel alloc] init];
        aModel.dialog = dialog;
        aModel.list = list.mutableCopy;
        block(aModel, NO);
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        model.isLoading = NO;
        block(nil, YES);
        [UITipView showTipStr:respondObject.message];
    }];
}

+ (void)sendJoinRequestWithActivityCode:(NSString *)code block:(HTTPCompleteBlock)block {
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/activity/api/lottery/activity/v2/auth/join?activityCode=%@"), code];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        
        JHLotteryJoinModel *aModel = [JHLotteryJoinModel modelWithJSON:respondObject.data];
        block(aModel, NO);
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        block(nil, YES);
        [UITipView showTipStr:respondObject.message];
    }];
}

+ (void)sendShareCommpleteRequestWithCode:(NSString *)code block:(HTTPCompleteBlock)block {
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/activity/api/lottery/activity/v2/auth/share?activityCode=%@"), code];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel * _Nullable respondObject) {
        
        JHLotteryShareModel *aModel = [JHLotteryShareModel modelWithJSON:respondObject.data];
        block(aModel, NO);
        
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        block(nil, YES);
        [UITipView showTipStr:respondObject.message];
    }];
}

+ (void)getLotteryListDetailWithActivityCode:(NSString*)code inviter:(NSString*)inviter unionId:(NSString*)unionId resp:(JHActionBlocks)resp
{
    JHLotteryActivityDetailReqModel* req = [JHLotteryActivityDetailReqModel new];
    req.activityCode = code;
    req.inviter = inviter;
    req.unionId = unionId;
    
    [JH_REQUEST asynGet:req success:^(NSDictionary* respData) {
        if([respData isKindOfClass:[NSDictionary class]])
        {
            JHLotteryActivityDetailModel* model = [JHLotteryActivityDetailModel modelWithJSON:respData];
            resp([JHRespModel nullMessage], model);
        }
        else
        {
            resp(@"请求失败", [JHRespModel nullMessage]);
        }
    } failure:^(NSString *errorMsg) {
        resp(errorMsg, [JHRespModel nullMessage]);
    }];
}


@end
