//
//  JHC2CSendServiceModel.h
//  TTjianbao
//
//  Created by hao on 2021/6/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
///自助邮寄 收货人信息
@interface JHC2CReceiveInfoModel : NSObject
///收货人详细地址
@property (nonatomic, copy) NSString *receiveAddress;
///收货人市
@property (nonatomic, copy) NSString *receiveCity;
///收货人县
@property (nonatomic, copy) NSString *receiveCounty;
///收货人手机号
@property (nonatomic, copy) NSString *receiveMobile;
///收货人姓名
@property (nonatomic, copy) NSString *receiveName;
///收货人省
@property (nonatomic, copy) NSString *receiveProvince;
@end

///发货人默认地址
@interface JHC2CDeliverInfoModel : NSObject
///发货人详细地址
@property (nonatomic, copy) NSString *deliverAddress;
///发货人市
@property (nonatomic, copy) NSString *deliverCity;
///发货人县
@property (nonatomic, copy) NSString *deliverCounty;
///发货人手机号
@property (nonatomic, copy) NSString *deliverMobile;
///发货人姓名
@property (nonatomic, copy) NSString *deliverName;
///发货人省
@property (nonatomic, copy) NSString *deliverProvince;
///发货人地址id
@property (nonatomic, assign) NSInteger sendAddressId;
@end

///快递公司列表
@interface JHC2CExpressCompanyListModel : NSObject
///快递公司编码
@property (nonatomic, copy) NSString *expressCompanyCode;
///快递公司名字
@property (nonatomic, copy) NSString *expressCompanyName;
@end

///快递包装描述
@interface JHC2CPackageDescriptionModel : NSObject
///快递包装建议图片
@property (nonatomic, copy) NSString *imageUrl;
///快递包装建议文字描述
@property (nonatomic, copy) NSString *content;
@end

@interface JHC2CSendServiceModel : NSObject
///支持快递公司列表
@property (nonatomic, copy) NSArray<JHC2CExpressCompanyListModel *> *expressCompanyList;
///快递包装描述
@property (nonatomic, strong) JHC2CPackageDescriptionModel *packageDescription;
///发货人默认地址
@property (nonatomic, strong) JHC2CDeliverInfoModel *deliverInfo;
///自助邮寄 收货人信息
@property (nonatomic, strong) JHC2CReceiveInfoModel *receiveInfo;
@end

NS_ASSUME_NONNULL_END
