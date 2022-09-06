//
//  JHLiveRoomInfoModel.m
//  TTjianbao
//
//  Created by jesee on 19/7/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLiveRoomInfoModel.h"
#import "JHLiveRoomModel.h"

@implementation JHLiveRoomInfoModel

//添加或编辑直播间信息
- (void)requestAddLiveRoomInfo:(JHLiveRoomInfoAddReqModel*)model resp:(JHActionBlocks)resp
{
    [JH_REQUEST asynPost:model success:^(id respData) {
        JHLiveRoomInfoModel* info = [JHLiveRoomInfoModel convertData:respData];
        resp(nil, info);
    } failure:^(NSString *errorMsg) {
        resp(errorMsg, nil);
    }];
}

//添加或编辑主播信息
- (void)requestAddArchorInfo:(JHLiveRoomArchorInfoAddReqModel*)model resp:(JHActionBlocks)resp
{
    [JH_REQUEST asynPost:model success:^(id respData) {
        JHAnchorInfo* info = [JHAnchorInfo convertData:respData];
        resp(nil, info);
    } failure:^(NSString *errorMsg) {
        resp(errorMsg, nil);
    }];
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"roomInfoId":@"id"};
}
@end

@implementation JHLiveRoomInfoAddReqModel

- (NSString *)uriPath
{
    return @"/app/channel/introduction/save";

}
@end

@implementation JHLiveRoomArchorInfoAddReqModel

- (NSString *)uriPath
{
    return @"/app/channel/dummy-anchor/save";
}
@end



@implementation JHLiveRoomInfoCustomizeAddReqModel
- (NSString *)uriPath {
    return @"/app/appraisal/customizeIntro/saveCustomizeIntro";
}

@end



