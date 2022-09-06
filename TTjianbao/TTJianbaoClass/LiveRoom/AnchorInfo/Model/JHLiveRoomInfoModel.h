//
//  JHLiveRoomInfoModel.h
//  TTjianbao
//
//  Created by jesee on 19/7/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class JHLiveRoomInfoAddReqModel, JHLiveRoomArchorInfoAddReqModel;

@interface JHLiveRoomInfoModel : JHRespModel
//直播间介绍详情
@property (nonatomic, copy) NSString *roomInfoId;// 直播间介绍ID ,
@property (nonatomic, copy) NSString *roomDes;// 直播间介绍

//添加或编辑直播间信息
- (void)requestAddLiveRoomInfo:(JHLiveRoomInfoAddReqModel*)model resp:(JHActionBlocks)resp;

//添加或编辑主播信息
- (void)requestAddArchorInfo:(JHLiveRoomArchorInfoAddReqModel*)model resp:(JHActionBlocks)resp;
@end

//直播间介绍新增和编辑
@interface JHLiveRoomInfoAddReqModel : JHReqModel

@property (nonatomic, copy) NSString *channelLocalId;// 直播间ID ,
@property (nonatomic, copy) NSString *roomDes;// 描述
@end

//虚拟主播介绍新增和编辑
@interface JHLiveRoomArchorInfoAddReqModel : JHReqModel

@property (nonatomic, copy) NSString *avatar;// 头像 ,
@property (nonatomic, copy) NSString *broadId;// 主播介绍ID ,
@property (nonatomic, copy) NSString *channelLocalId;// 直播间ID ,
@property (nonatomic, copy) NSString *des;// 描述 ,
@property (nonatomic, copy) NSString *nick;// 昵称

///身份证人像
@property (nonatomic, copy) NSString *idCardFrontImg;

///身份证国徽
@property (nonatomic, copy) NSString *idCardBackImg;

@end



//直播间介绍新增和编辑
@interface JHLiveRoomInfoCustomizeAddReqModel : JHReqModel

@property (nonatomic, copy) NSString *channelLocalId;// 直播间ID ,
@property (nonatomic, copy) NSString *introduction;// 描述
@end
