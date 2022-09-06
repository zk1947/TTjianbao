//
//  JHGrowingIO.m
//  TTjianbao
//
//  Created by mac on 2019/7/8.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHGrowingIO.h"
#import "ChannelMode.h"
#import "CommHelp.h"
#import "UserInfoRequestManager.h"

#import "AppraisalDetailMode.h"

NSString *const JHPageFromSaleRoom = @"源头直播间";
NSString *const JHPageFromAppraiseRoom = @"鉴定直播间";
NSString *const JHPageFromAppraiseVideo = @"鉴定视频页";
NSString *const JHPageFromInteraction = @"互动消息页";
NSString *const JHPageFromOther = @"其他";

@implementation TrackLiveBaseModel

@end

@implementation LiveExtendModel

@end

@implementation VideoExtendModel

@end


@implementation TrackVideoBaseModel

@end

@implementation OrderTrackModel


@end

@implementation JHGrowingIO

+ (void)trackEventId:(NSString *)eventId {
    [Growing track:eventId];
    NSLog(@"Growing==event==%@",eventId);
}

+ (void)trackEventId:(NSString *)eventId number:(NSInteger)count{
    [Growing track:eventId withNumber:@(count)];
}


+ (void)trackEventId:(NSString *)eventId variable:(NSString *)value{
    [Growing track:eventId withVariable:@{JHKeyValue:value}];
}

+ (void)trackEventId:(NSString *)eventId variables:(NSDictionary *)value number:(NSInteger)count{
    [Growing track:eventId withNumber:@(count) andVariable:value];
}

+ (void)trackEventId:(NSString *)eventId variables:(NSDictionary *)value{
    [Growing track:eventId withVariable:value];
    NSLog(@">Growing1埋点==event==%@ variables==%@",eventId, value);
}

+ (void)trackOrderEventId:(NSString *)eventId orderCode:(NSString *)orderCode payWay:(NSString *)payWay suc:(NSString *)truefalse {
    OrderTrackModel *mode = [[OrderTrackModel alloc] init];
    mode.orderCode = orderCode;
    mode.payWay = payWay;
    mode.suc = truefalse;
    mode.result = truefalse;
    mode.time = [[CommHelp getNowTimeTimestampMS] integerValue];
    mode.userId = [JHRootController isLogin]?[UserInfoRequestManager sharedInstance].user.customerId:@"";

    [JHGrowingIO trackEventId:eventId variables:[mode mj_keyValues]];
}

+ (LiveExtendModel *)liveExtendModelChannel:(ChannelMode *)channel {
    LiveExtendModel *mode = [[LiveExtendModel alloc] init];
    mode.roomId = channel.roomId;
    mode.channelLocalId = channel.channelLocalId;
    mode.anchorId = channel.anchorId;
    mode.channelType = channel.channelType;
    mode.time = [[CommHelp getNowTimeTimestampMS] integerValue];
    mode.userId = [JHRootController isLogin]?[UserInfoRequestManager sharedInstance].user.customerId:@"";
    mode.currentRecordId = channel.currentRecordId;
    mode.channelCategory = channel.channelCategory;
    mode.teachername = channel.anchorName;
    return mode;
}

+ (VideoExtendModel *)videoExtendModel:(AppraisalDetailMode *)appraise {
    
    VideoExtendModel *mode = [[VideoExtendModel alloc] init];
    mode.time = [[CommHelp getNowTimeTimestampMS] integerValue];
    mode.userId = [JHRootController isLogin]?[UserInfoRequestManager sharedInstance].user.customerId:@"";
    if([appraise isKindOfClass:[AppraisalDetailMode class]]) {
        mode.appraiseId = appraise.appraiseId;
        mode.appraiserId = appraise.appraiser.viewId;
        mode.recordId = appraise.recordId;
        mode.originRecordId = appraise.originRecordId;
    }
    return mode;
}

//记录来源专用
+ (void)trackEventId:(NSString *)eventId from:(NSString *)from{
    if(eventId && from)
    {
        NSDictionary* fromDic = [NSDictionary dictionaryWithObject:from forKey:@"from"];
        [JHGrowingIO trackEventId:eventId variables:fromDic];
    }
}

//记录带公参的点
+ (void)trackPublicEventId:(NSString *)eventId{
    [self trackPublicEventId:eventId paramDict:nil];
}

+ (void)trackPublicEventId:(NSString *)eventId paramDict:(NSDictionary *)dict {
    if(eventId)
    {
        NSMutableDictionary* finialDict = [NSMutableDictionary dictionary];
        //公参:time+userId
        [finialDict setValue:[CommHelp getNowTimeTimestampMS] forKey:@"time"];
        if([JHRootController isLogin])
        {
            [finialDict setValue:[UserInfoRequestManager sharedInstance].user.customerId ? : @"" forKey:@"userId"];
        }
        //自定义参数
        if(dict)
        {
            [finialDict addEntriesFromDictionary:dict];
        }
        [JHGrowingIO trackEventId:eventId variables:finialDict];
    }
}

@end
