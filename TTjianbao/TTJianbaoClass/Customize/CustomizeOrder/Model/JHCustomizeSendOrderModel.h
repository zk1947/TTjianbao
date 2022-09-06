//
//  JHCustomizeSendOrderModel.h
//  TTjianbao
//
//  Created by jiangchao on 2020/11/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class JHCustomizeSendExpressModel;

@interface JHCustomizeSendOrderModel : NSObject
@property (strong,nonatomic)NSString * receiveAddress;// 接收地址
@property (strong,nonatomic)NSString * receiveName;//接收名字
@property (strong,nonatomic)NSString * receivePhone;//接收手机号
@property (strong,nonatomic)NSArray<JHCustomizeSendExpressModel *>*expressTypes;//快递公司
@property (nonatomic, copy)NSString *platformServiceDialTelStr;//平台呼出客服电话
@property (nonatomic, copy)NSString *platformServiceTelStr;//平台客服电话
@property (nonatomic, copy)NSString *platformServiceWorkTimeStr;//平台客服工作时间段
@property (nonatomic, copy)NSString *expressReserveAddress;// 预约地址
@property (nonatomic, copy)NSString *expressReserveDate;//预约时间
@property (nonatomic, copy)NSString *expressReserveName;//预约姓名
@property (nonatomic, copy)NSString *expressReservePhone;//预约手机号
/** 预约状态 0 未预约 1 已预约 2 预约成功 3 不支持 4 发货成功*/
@property (nonatomic, copy)NSString *expressReserveStatus;
/** 防疫提示内容*/
@property (nonatomic, copy)NSString *keepEpidemicWarnDesc;
@end

@interface JHCustomizeSendExpressModel : NSObject
@property (strong,nonatomic)NSString * name;//
@property (strong,nonatomic)NSString * com;//
@end

NS_ASSUME_NONNULL_END
