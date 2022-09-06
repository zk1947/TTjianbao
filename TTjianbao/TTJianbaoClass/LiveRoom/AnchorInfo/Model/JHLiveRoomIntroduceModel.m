//
//  JHLiveRoomIntroduceModel.m
//  TTjianbao
//
//  Created by Jesse on 2020/9/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLiveRoomIntroduceModel.h"

@implementation JHLiveRoomIntroduceModel

+ (void)requestLiveRoomInfo:(NSString *)channelLocalId completeBlock:(JHActionBlocks)complete
{
    JHLiveRoomIntroduceReqModel* reqModel = [JHLiveRoomIntroduceReqModel new];
    reqModel.channelLocalId = channelLocalId;
    [JH_REQUEST asynPost:reqModel success:^(id respData) {
        JHLiveRoomIntroduceModel* model = [JHLiveRoomIntroduceModel convertData:respData];
//        model = [JHLiveRoomIntroduceModel testDataExt]; //test
        complete([JHRespModel nullMessage], model);
    } failure:^(NSString *errorMsg) {
        complete(errorMsg, [JHRespModel nullMessage]);
    }];
}

+ (JHLiveRoomIntroduceModel*)testDataExt
{
    JHLiveRoomIntroduceModel* m = [JHLiveRoomIntroduceModel new];
    m.roomDes = @"00000请求直播及主播信息sdadsflasjlfreoj23023909请求直播及主播信息klaslefo0232o30420-3ksdlklkdfslkf023000r30iwiriweq90i90";
    //主播介绍
    JHLiveRoomAnchorInfoModel* info1 = [JHLiveRoomAnchorInfoModel new];
    info1.avatar = @"http://sq-image-test.oss-cn-beijing.aliyuncs.com/images/5701b6342221c15bc093cab62a729297.jpg?x-oss-process=image/resize,w_400";
    info1.nick = @"1";
    info1.des = @"11111111请求直播及主播信息sdadsflasjlfreoj23023909请求直播及主播信息klaslefo0232o30420-3ksdlklkdfslkf023000r30iwiriweq90i90";
    JHLiveRoomAnchorInfoModel* info2 = [JHLiveRoomAnchorInfoModel new];
    info2.avatar = @"http://sq-image-test.oss-cn-beijing.aliyuncs.com/images/5701b6342221c15bc093cab62a729297.jpg?x-oss-process=image/resize,w_400";
    info2.nick = @"2";
    info2.liveState = @"1";
    info2.des = @"2222211请求直播及主播信息sdadsflasjlfreoj23023909请求直播及主播信息klaslefo0232o30420-3ksdlklkdfslkf023000r30iwiriweq90i90";
    JHLiveRoomAnchorInfoModel* info3 = [JHLiveRoomAnchorInfoModel new];
    info3.avatar = @"http://sq-image-test.oss-cn-beijing.aliyuncs.com/images/5701b6342221c15bc093cab62a729297.jpg?x-oss-process=image/resize,w_400";
    info3.nick = @"3";
    info3.des = @"3333311请求直播及主播信息sdadsflasjlfreoj23023909请求直播及主播信息klaslefo0232o30420-3ksdlklkdfslkf023000r30iwiriweq90i90";
    m.broads = [NSArray arrayWithObjects:info1, nil];
    //费用说明
    JHLiveRoomFeeInfoModel* fee1 = [JHLiveRoomFeeInfoModel new];
    fee1.customizeFeeId = @"123";
    fee1.name = @"收到了12";
    fee1.maxPrice = @"5000000988999009";
    fee1.minPrice = @"3000000099929929";
    fee1.img = @"https://jianhuo.nos-eastchina1.126.net/sys/appraise_img/1600762869008.jpg?imageView&thumbnail=400x400";
    JHLiveRoomFeeInfoModel* fee2 = [JHLiveRoomFeeInfoModel new];
    fee2.customizeFeeId = @"123";
    fee2.name = @"收到了12";
    fee2.maxPrice = @"5000000988999009";
    fee2.minPrice = @"6000000988999009";
    fee2.img = @"";
    JHLiveRoomFeeInfoModel* fee3 = [JHLiveRoomFeeInfoModel new];
    fee3.customizeFeeId = @"123";
    fee3.name = @"收到了12";
    fee3.maxPrice = @"5000";
    fee3.minPrice = @"3000";
    fee3.img = @"";
    JHLiveRoomFeeInfoModel* fee4 = [JHLiveRoomFeeInfoModel new];
    fee4.customizeFeeId = @"123";
    fee4.name = @"收到了12";
    fee4.maxPrice = @"5000";
    fee4.minPrice = @"3000";
    fee4.img = @"https://jianhuo.nos-eastchina1.126.net/sys/appraise_img/1600762869008.jpg?imageView&thumbnail=400x400";
    JHLiveRoomFeeInfoModel* fee5 = [JHLiveRoomFeeInfoModel new];
    fee5.customizeFeeId = @"123";
    fee5.name = @"收到了12";
    fee5.maxPrice = @"5000";
    fee5.minPrice = @"3000";
    fee5.img = @"https://jianhuo.nos-eastchina1.126.net/sys/appraise_img/1600762869008.jpg?imageView&thumbnail=400x400";
    m.fees = [NSArray arrayWithObjects:fee1, fee2, fee3, fee4, fee5, nil];
    return m;
}

+ (NSDictionary *)mj_objectClassInArray
{
    return @{
        @"broads" : [JHLiveRoomAnchorInfoModel class],
        @"fees" : [JHLiveRoomFeeInfoModel class],
        @"cateNames": [NSString class]
    };
}
@end

@implementation JHLiveRoomAnchorInfoModel

- (JHAnchorLiveStatus)liveStatus
{
    if([_liveState isEqualToString:@"1"])
    {
        _liveStatus = JHAnchorLiveStatusPlaying;
    }
    else if([_liveState isEqualToString:@"0"])
    {
        _liveStatus = JHAnchorLiveStatusPause;
    }
    else
    {
        _liveStatus = JHAnchorLiveStatusNoData;
    }
    return _liveStatus;
}

@end

@implementation JHLiveRoomFeeInfoModel

+(NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"customizeFeeId":@"id"};
}

@end
@implementation JHLiveRoomIntroduceReqModel
///app/opt/channel/introduction/detail
- (NSString *)uriPath
{
    return @"/app/opt/channel/introduction/detail";
}

@end
