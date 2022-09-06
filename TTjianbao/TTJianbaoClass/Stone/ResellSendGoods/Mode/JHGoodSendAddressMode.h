//
//  JHGoodSendAddressMode.h
//  TTjianbao
//
//  Created by jiangchao on 2020/5/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN
//deliverAddress (string, optional): 发货人详细地址 ,
//deliverCity (string, optional): 发货人市 ,
//deliverCounty (string, optional): 发货人县 ,
//deliverMobile (string, optional): 发货人手机号 ,
//deliverName (string, optional): 发货人姓名 ,
//deliverProvince (string, optional): 发货人省 ,
//deliverShipperCode (string, optional): 发货人邮政编码 ,
//depositoryId (integer, optional): 仓库id ,
//payDeadline (string, optional): 订单支付截止时间
@interface JHGoodSendAddressMode : NSObject
@property (strong, nonatomic)  NSString *deliverAddress;
@property (strong, nonatomic)  NSString *deliverCity;
@property (strong, nonatomic)  NSString *deliverCounty;
@property (strong, nonatomic)  NSString *deliverName;
@property (strong, nonatomic)  NSString *deliverMobile;
@property (strong, nonatomic)  NSString *deliverProvince;
@property (strong, nonatomic)  NSString *deliverShipperCode;
@property (strong, nonatomic)  NSString *depositoryId;
@property (strong, nonatomic)  NSString *payDeadline;
@property (strong, nonatomic)  NSString *warnInfo;



@end

NS_ASSUME_NONNULL_END
