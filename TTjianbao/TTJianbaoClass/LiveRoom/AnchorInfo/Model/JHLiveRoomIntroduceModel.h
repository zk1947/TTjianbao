//
//  JHLiveRoomIntroduceModel.h
//  TTjianbao
//  Description://直播间右滑介绍详情model
//  Created by Jesse on 2020/9/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRespModel.h"
#import "JHPriceWrapper.h"

@class JHLiveRoomFeeInfoModel, JHLiveRoomAnchorInfoModel;

typedef NS_ENUM(NSInteger, JHAnchorLiveStatus)
{//0:停播 1:直播  -11:(左滑介绍无数据时)展示用,无其他意思
    JHAnchorLiveStatusPause,
    JHAnchorLiveStatusPlaying = 1,
    JHAnchorLiveStatusNoData = -11 //其实不该掺和在一起！！
};

NS_ASSUME_NONNULL_BEGIN

//直播间右滑介绍详情
@interface JHLiveRoomIntroduceModel : JHRespModel

@property (nonatomic, copy) NSString* roomDes;// (string, optional): 直播间介绍
@property (nonatomic, strong) NSArray<JHLiveRoomAnchorInfoModel *>* broads;// (Array[主播介绍], optional): 主播介绍列表 ,
@property (nonatomic, strong) NSArray<JHLiveRoomFeeInfoModel *>* fees;// (Array[定制费用说明], optional): 定制费用集合
@property (nonatomic, strong) NSArray<NSString *>* cateNames; /// 回收类别
//请求直播间信息
+ (void)requestLiveRoomInfo:(NSString *)channelLocalId completeBlock:(JHActionBlocks)complete;
@end

//主播介绍
@interface JHLiveRoomAnchorInfoModel : NSObject

@property (nonatomic, copy) NSString* avatar;///主播头像
@property (nonatomic, copy) NSString* broadId;///主播介绍id
@property (nonatomic, copy) NSString* nick;///主播昵称
@property (nonatomic, copy) NSString* des;///主播描述
@property (nonatomic, copy) NSString* liveState; ///(string, optional): 是否开播：0-否、1-是 ,
///主播直播状态0:停播 1:直播  -11:(左滑介绍无数据时)展示用,无其他意思
@property (nonatomic, assign) JHAnchorLiveStatus liveStatus;

@end

//定制费用说明
@interface JHLiveRoomFeeInfoModel : NSObject

@property (nonatomic, copy) NSString* customizeFeeId;// (integer, optional): 定制费用ID ,
@property (nonatomic, copy) NSString* name;//  (string, optional): 定制类别名称
@property (nonatomic, copy) NSString* img;// (string, optional): 图片地址 ,
@property (nonatomic, copy) NSString* maxPrice;//  (number, optional): 价格最大值 ,
@property (nonatomic, copy) NSString* minPrice;//  (number, optional): 价格最小值 ,
@property (nonatomic, strong) JHPriceWrapper* maxPriceWrapper;//  (PriceWrapper, optional): 最大价格包装类 ,
@property (nonatomic, strong) JHPriceWrapper* minPriceWrapper;//  (PriceWrapper, optional): 最小价格包装类 ,

@end



@interface JHLiveRoomIntroduceReqModel : JHReqModel

@property (nonatomic, copy) NSString* channelLocalId; // (integer, optional): 直播间ID
@end

NS_ASSUME_NONNULL_END
