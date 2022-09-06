//
//  JHMakeRedpacketModel.h
//  TTjianbao
//  Description:创建红包页，请求
//  Created by Jesse on 2020/1/8.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRespModel.h"
#import "PayMode.h"

#define kDefaultWishes @"恭喜发财，大吉大利"

NS_ASSUME_NONNULL_BEGIN

/**创建红包，即塞钱进红包*/
@interface JHMakeRedpacketModel : JHRespModel

@property (nonatomic, assign) BOOL enableRemainPay;// (integer, optional): 是否启动津贴支付 ,
@property (nonatomic, assign) BOOL isRemainEnough;// (integer, optional): 津贴是否足够支付 ,
@property (nonatomic, strong) NSString* amountOfMoney;// (number, optional): 总金额 ,
@property (nonatomic, strong) NSString* payMoney;// (number, optional): 支付金额 ,
@property (nonatomic, strong) NSArray<PayWayMode*>* payWayList;//  支付方式列表 ,
@property (nonatomic, strong) NSString* redPacketId;// (integer, optional): 红包ID ,
@property (nonatomic, strong) NSString* remainMoney;// (number, optional): 津贴

@end

@interface JHMakeRedpacketReqModel : JHReqModel

@property (nonatomic, strong) NSString* channelId;// (integer, optional): 直播间ID ,
@property (nonatomic, strong) NSString* amountOfMoney;// (number, optional): 总金额 ,
@property (nonatomic, strong) NSString* wishes;// (string, optional): 寄语
@property (nonatomic, assign) NSInteger takeCondition;// (integer, optional): 抢红包条件：0-无条件
@property (nonatomic, assign) NSUInteger totalCount;// (integer, optional): 红包个数 ,
@property (nonatomic, assign) NSUInteger validMinutes;// (integer, optional): 有效时间(分) ,

@end

/**创建红包页面数据*/
@interface JHMakeRedpacketPageModel : JHRespModel

@property (nonatomic, strong) NSString* defaultWishes;// (string, optional): 缺省寄语 ,
@property (nonatomic, strong) NSString* maxAmountOfMoney;// (number, optional): 最大红包总金额 ,
@property (nonatomic, strong) NSString* minAmountOfMoney;// (number, optional): 最小红包总金额 ,
@property (nonatomic, assign) NSInteger maxCount;// (integer, optional): 最大红包个数 ,
@property (nonatomic, assign) NSInteger minCount;// (integer, optional): 最小红包个数 ,
@property (nonatomic, assign) NSInteger wishesLength; //限制寄语的长度
@property (nonatomic, strong) NSString* tips;// (string, optional): 提示语 ,
@property (nonatomic, strong) NSArray* wishesList; //寄语列表,不为空,第一项为defaultWishes
@property (nonatomic, strong) NSArray<NSDictionary*>* conditionList;// (Array[KeyValue«int,string»], optional): 抢红包条件列表,不空则显示,空则不显示
@property (nonatomic, strong) NSArray<NSDictionary*>* validMinutesList;// (Array[KeyValue«int,string»], optional): 有效时间列表

@end

@interface JHMakeRedpacketPageReqModel : JHReqModel
//新版加参数
@property (nonatomic, copy) NSString *channelId;
@end

/**创建红包页面数据*/
@interface JHGetRedpacketDetailPageModel : JHRespModel

@property (nonatomic, copy) NSString *lastRedPacketTakeId;

@property (nonatomic, copy) NSString *redPacketId;

@property (nonatomic, assign) NSInteger pageSize;

@end

NS_ASSUME_NONNULL_END
