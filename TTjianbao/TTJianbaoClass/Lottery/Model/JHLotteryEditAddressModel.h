//
//  JHLotteryEditAddressModel.h
//  TTjianbao
//  Description:填写地址
//  Created by jesse on 2020/7/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHRespModel.h"
#import "JHLotteryReqModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHLotteryAddressDetailModel : NSObject

@property (nonatomic, copy) NSString* name;// "张三", //收货人
@property (nonatomic, copy) NSString* phone;// "18512345678", //联系电话
@property (nonatomic, copy) NSString* address;// "这是详细地址" //详细地
@end

@interface JHLotteryEditAddressModel : JHRespModel

@property (nonatomic, strong) JHLotteryAddressDetailModel* address; //收货人
@property (nonatomic, assign) BOOL isExpired; //领奖是否过期(0:否、1: 是)
@property (nonatomic,   copy) NSString* expiredTxt; //已经过期//领奖过期提示文案

+ (void)asynRequestActivityCode:(NSString*)code addressId:(NSString*)addressId resp:(JHActionBlocks)resp;
@end

@interface JHLotteryEditAddressReqModel : JHLotteryReqModel

@end

@interface JHLotteryEditAddressReqModelExt : JHLotteryEditAddressReqModel

@property (nonatomic, copy) NSString* addressId; //1234,用户地址ID，不传表示校验领奖是否过期
@end

NS_ASSUME_NONNULL_END
