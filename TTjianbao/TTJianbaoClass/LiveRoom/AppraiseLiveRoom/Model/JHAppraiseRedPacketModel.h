//
//  JHAppraiseRedPacketModel.h
//  TTjianbao
//  Descrription:鉴定师红包数据model
//  Created by Jesse on 2020/7/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHAppraiseRedPacketModel : NSObject

//查询当前鉴定师红包配置信息
+ (void)asynReqConfigQueryResp:(JHActionBlocks)resp;
//发放鉴定师红包
+ (void)asynReqSendAppraiserId:(NSString*)appraiserId channelId:(NSString*)channelId Resp:(JHActionBlocks)resp;
//查询当前鉴定师红包发放记录
+ (void)asynReqSendHistoryAppraiserId:(NSString*)appraiserId Resp:(JHActionBlocks)resp;
//鉴定师红包"开"按钮
+ (void)asynReqTakeRedpacketId:(NSString*)redpacketId channelId:(NSString*)channelId Resp:(JHActionBlocks)resp;
//直播间小图标，鉴定师红包列表
+ (void)asynReqListChannelId:(NSString*)channelId Resp:(JHActionBlocks)resp;
@end

@interface JHAppraiseRedPacketConfigQueryModel : JHResponseModel
///-/app/appraise/rp/config/query  //查询当前鉴定师红包配置信息
@property (nonatomic, copy) NSString* createTime;
@property (nonatomic, copy) NSString* mId;// = 18;
@property (nonatomic, copy) NSString* isStart;
@property (nonatomic, copy) NSString* singleDrawDuration;
@property (nonatomic, copy) NSString* singleWinnerCount;
@property (nonatomic, copy) NSString* updateTime;
@end

@interface JHAppraiseRedPacketSendModel : JHResponseModel
///-/app/appraise/rp/send   //发放鉴定师红包
@end

@interface JHAppraiseRedPacketHistoryModel : JHResponseModel
///-/app/appraise/rp/send/history    //查询当前鉴定师红包发放记录
@property (nonatomic, copy) NSString* remainSendTimes;
@property (nonatomic, strong) NSArray* sendTimeDescList;
@end

@interface JHAppraiseRedPacketTakeModel : JHResponseModel
///-/app/appraise/rp/take  //鉴定师红包"开"按钮
@property (nonatomic, copy) NSString* mCode; // 1成功 0失败
@property (nonatomic, copy) NSString* redPacketId;// "3",
@property (nonatomic, copy) NSString* sendCustomerName;// "鉴定师 许明鉴定 的红包",
@property (nonatomic, copy) NSString* sendCustomerImg;
@property (nonatomic, copy) NSString* wishes;// "恭喜发财，大吉大利",
@property (nonatomic, copy) NSString* countDesc;
@property (nonatomic, copy) NSString* takeMoney;
@property (nonatomic, copy) NSString* tips1;// "奖品可在个人中心查看，可在直播间购物使用",
@property (nonatomic, copy) NSString* tips2;// "https://jh-live-video-test.oss-cn-beijing.aliyuncs.com/test/gif/financemix1596010376514.jpg"

@property (nonatomic, copy) NSString* channelId; //埋点用
@property (nonatomic, copy) NSString* sendCustomerId; //埋点用

@property (nonatomic, copy) NSString* channelLocalId; //跳转直播间

/// 不跳转-0   直播间-1   推荐列表-2
@property (nonatomic, assign) NSInteger landingType;

@end

@interface JHAppraiseRedPacketListModel : JHResponseModel
///-/app/opt/appraise/rp/list  //观众直播间小图标（是否显示），鉴定师红包列表
@property (nonatomic, copy) NSString* appraiseRpId;
@property (nonatomic, copy) NSString* channelId;
@property (nonatomic, copy) NSString* createTime;
@property (nonatomic, copy) NSString* delFlag;
@property (nonatomic, copy) NSString* expireTime;
@property (nonatomic, copy) NSString* mNewValue;
@property (nonatomic, copy) NSString* redPacketId;
@property (nonatomic, copy) NSString* sendCustomerId;
@property (nonatomic, copy) NSString* sendCustomerImg;
@property (nonatomic, copy) NSString* sendCustomerName;
@property (nonatomic, copy) NSString* shortSendCustomerName;
@property (nonatomic, copy) NSString* status;
@property (nonatomic, copy) NSString* updateTime;
@property (nonatomic, copy) NSString* wishes;

/// 神测埋点用的
@property (nonatomic, copy) NSDictionary *trackingParams;
@end

//请求接口
@interface JHAppraiseRedPacketReqModel : JHRequestModel

@property (nonatomic, copy) NSString* appraiserId; // 鉴定师ID
@property (nonatomic, copy) NSString* redpacketId; // 鉴定师红包ID
@property (nonatomic, copy) NSString* channelId; // 直播间ID
@end



