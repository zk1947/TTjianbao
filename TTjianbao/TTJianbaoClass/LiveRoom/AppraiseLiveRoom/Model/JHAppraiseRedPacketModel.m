//
//  JHAppraiseRedPacketModel.m
//  TTjianbao
//
//  Created by Jesse on 2020/7/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAppraiseRedPacketModel.h"

#define kAppraiseReqPrefix @"/app/appraise/rp/"

typedef NS_ENUM(NSUInteger, JHAppraiseReqType)
{
    JHAppraiseReqTypeConfigQuery, //配置信息
    JHAppraiseReqTypeSend, //发放鉴定师红包
    JHAppraiseReqTypeHistory, //发放记录
    JHAppraiseReqTypeTake, //"开"按钮
    JHAppraiseReqTypeList //直播间小图标，鉴定师红包列表
};

@interface JHAppraiseRedPacketReqModel ()

- (void)setAppraiseRequestType:(JHAppraiseReqType)type;
@end

@implementation JHAppraiseRedPacketModel

+ (void)asynReqConfigQueryResp:(JHActionBlocks)resp
{
    JHAppraiseRedPacketReqModel* req = [JHAppraiseRedPacketReqModel new];
    [req setAppraiseRequestType:JHAppraiseReqTypeConfigQuery];
    [JH_REQUEST asynPost:req success:^(id respData) {
        
        JHAppraiseRedPacketConfigQueryModel* model = [JHAppraiseRedPacketConfigQueryModel convertData:respData];
        resp([JHRespModel nullMessage], model);
    } failure:^(NSString *errorMsg) {
        
        resp(errorMsg, [JHRespModel nullMessage]);
    }];
}

+ (void)asynReqSendAppraiserId:(NSString*)appraiserId channelId:(NSString*)channelId Resp:(JHActionBlocks)resp
{
    JHAppraiseRedPacketReqModel* req = [JHAppraiseRedPacketReqModel new];
    [req setAppraiseRequestType:JHAppraiseReqTypeSend];
    req.appraiserId = appraiserId;
    req.channelId = channelId;
    [JH_REQUEST asynPost:req success:^(id respData) {
        
        NSString* tips = @"发放成功";
        if([respData isKindOfClass:[NSString class]])
        {
            tips = respData;
        }
        resp([JHRespModel nullMessage], tips);
    } failure:^(NSString *errorMsg) {
        
        resp(errorMsg, [JHRespModel nullMessage]);
    }];
}

+ (void)asynReqSendHistoryAppraiserId:(NSString*)appraiserId Resp:(JHActionBlocks)resp
{
    JHAppraiseRedPacketReqModel* req = [JHAppraiseRedPacketReqModel new];
    [req setAppraiseRequestType:JHAppraiseReqTypeHistory];
    req.appraiserId = appraiserId;
    [JH_REQUEST asynPost:req success:^(id respData) {
        
        JHAppraiseRedPacketHistoryModel* model = [JHAppraiseRedPacketHistoryModel convertData:respData];
        resp([JHRespModel nullMessage], model);
    } failure:^(NSString *errorMsg) {
        
        resp(errorMsg, [JHRespModel nullMessage]);
    }];
}

+ (void)asynReqTakeRedpacketId:(NSString*)redpacketId channelId:(NSString*)channelId Resp:(JHActionBlocks)resp
{
    JHAppraiseRedPacketReqModel* req = [JHAppraiseRedPacketReqModel new];
    [req setAppraiseRequestType:JHAppraiseReqTypeTake];
    req.redpacketId = redpacketId;
    req.channelId = channelId;
    [JH_REQUEST asynPost:req success:^(id respData) {
        
        JHAppraiseRedPacketTakeModel* model = [JHAppraiseRedPacketTakeModel convertData:respData];
        resp([JHRespModel nullMessage], model);
    } failure:^(NSString *errorMsg) {
        
        resp(errorMsg, [JHRespModel nullMessage]);
    }];
}

+ (void)asynReqListChannelId:(NSString*)channelId Resp:(JHActionBlocks)resp
{
    JHAppraiseRedPacketReqModel* req = [JHAppraiseRedPacketReqModel new];
    [req setAppraiseRequestType:JHAppraiseReqTypeList];
    req.channelId = channelId; 
    [JH_REQUEST asynPost:req success:^(id respData) {
        
        NSArray* arr = [JHAppraiseRedPacketListModel convertData:respData];
        if([arr count] > 0)
        {
            JHAppraiseRedPacketListModel* model = arr.firstObject;
            resp([JHRespModel nullMessage], model);
        }
        else
        {
            resp([JHRespModel nullMessage], [JHRespModel nullMessage]);
        }
    } failure:^(NSString *errorMsg) {
        
        resp(errorMsg, [JHRespModel nullMessage]);
    }];
}

@end

@implementation JHAppraiseRedPacketConfigQueryModel
///-/app/appraise/rp/config/query  //查询当前鉴定师红包配置信息
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"mId": @"id"
    };
}
@end

@implementation JHAppraiseRedPacketSendModel
///-/app/appraise/rp/send   //发放鉴定师红包
@end

@implementation JHAppraiseRedPacketHistoryModel
///-/app/appraise/rp/send/history    //查询当前鉴定师红包发放记录
@end

@implementation JHAppraiseRedPacketTakeModel
///-/app/appraise/rp/take  //鉴定师红包"开"按钮
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"mCode": @"code"
    };
}
@end

@implementation JHAppraiseRedPacketListModel
///-/app/opt/appraise/rp/list  //直播间小图标，鉴定师红包列表

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
        @"mNewValue": @"newValue"
    };
}
@end

//请求接口
@implementation JHAppraiseRedPacketReqModel

- (void)setAppraiseRequestType:(JHAppraiseReqType)type
{
    switch (type)
    {
        case JHAppraiseReqTypeConfigQuery:
        default:
            [self setRequestPath:[NSString stringWithFormat:@"%@config/query",kAppraiseReqPrefix]];
            break;
            
        case JHAppraiseReqTypeSend:
            [self setRequestPath:[NSString stringWithFormat:@"%@send",kAppraiseReqPrefix]];
            break;
            
        case JHAppraiseReqTypeHistory:
            [self setRequestPath:[NSString stringWithFormat:@"%@send/history",kAppraiseReqPrefix]];
            break;
            
        case JHAppraiseReqTypeTake:
            [self setRequestPath:[NSString stringWithFormat:@"%@take",kAppraiseReqPrefix]];
            break;
            
        case JHAppraiseReqTypeList:
            [self setRequestPath:@"/app/opt/appraise/rp/list"];
            break;
    }
}

@end
