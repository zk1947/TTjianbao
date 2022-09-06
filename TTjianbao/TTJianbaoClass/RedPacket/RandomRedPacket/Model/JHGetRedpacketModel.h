//
//  JHGetRedpacketModel.h
//  TTjianbao
//  Description:拆红包页，请求
//  Created by Jesse on 2020/1/8.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRespModel.h"

NS_ASSUME_NONNULL_BEGIN

@class JHGetRedpacketDetailModel;

@interface JHGetRedpacketModel : JHRespModel

@property (nonatomic, assign) NSInteger resultCode;// (integer, optional): 结果码：0-失败，1-成功 ,
///是否满足领红包条件，0：满足，1：不满足
@property (nonatomic, assign)NSInteger conditionCheckFlag;

@property (nonatomic, assign) NSInteger takeCount;// (integer, optional): 领取个数 ,
@property (nonatomic, assign) NSInteger totalCount;// (integer, optional): 红包个数 ,
@property (nonatomic, copy) NSString* redPacketId;// (integer, optional): 红包ID ,
@property (nonatomic, copy) NSString* sendCustomerImg;// (string, optional): 发红包人头像 ,
@property (nonatomic, copy) NSString* sendCustomerName;// (string, optional): 发红包人名字 ,
@property (nonatomic, strong) NSMutableArray<JHGetRedpacketDetailModel*>* takeList;// (Array[GetRedPacketTakeResponse], optional): 领取列表 ,
@property (nonatomic, assign) CGFloat takeMoney;// (number, optional): 领取金额 ,
@property (nonatomic, copy) NSString* tips1;// (string, optional): 提示语 ,
@property (nonatomic, copy) NSString* tips2;
@property (nonatomic, copy) NSString* wishes;// (string, optional): 寄语
/// 领取/红包个数 
@property (nonatomic, copy) NSString* countDesc;

@end

@interface JHGetRedpacketDetailModel : NSObject

@property (nonatomic, copy) NSString* createTime;// (string, optional): 领取时间 ,
@property (nonatomic, copy) NSString* takeCustomerId;// (integer, optional): 领取红包人id ,
@property (nonatomic, copy) NSString* takeCustomerImg;// (string, optional): 领取红包人头像 ,
@property (nonatomic, copy) NSString* takeCustomerName;// (string, optional): 领取红包人名字 ,
@property (nonatomic, assign) CGFloat takeMoney;// (integer, optional): 领取金额

@property (nonatomic, copy) NSString *redPacketTakeId;

@end


NS_ASSUME_NONNULL_END
