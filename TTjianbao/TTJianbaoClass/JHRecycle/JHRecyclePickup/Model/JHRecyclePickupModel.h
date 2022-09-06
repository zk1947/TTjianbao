//
//  JHRecyclePickupModel.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

///建议图片信息
@interface JHRecyclePickupAppointmentInfoImgUrlModel : NSObject
/** 大图 */
@property (nonatomic, copy) NSString *big;
/** 小图 */
@property (nonatomic, copy) NSString *medium;
/** 原图 */
@property (nonatomic, copy) NSString *origin;
/** 缩略图 */
@property (nonatomic, copy) NSString *small;
@property (nonatomic, copy) NSString *w;
@property (nonatomic, copy) NSString *h;
@end

///取件地址
@interface JHRecyclePickupAppointmentPickAddressModel : NSObject
/** 市 */
@property (nonatomic, copy) NSString *city;
/** 县 */
@property (nonatomic, copy) NSString *county;
/** 省 */
@property (nonatomic, copy) NSString *province;
/** 详情 */
@property (nonatomic, copy) NSString *detail;
/** 收货人名称 */
@property (nonatomic, copy) NSString *receiverName;
/** 收货人电话 */
@property (nonatomic, copy) NSString *phone;
/** 发货地址名称 */
@property (nonatomic, copy) NSString *name;
/** 用户预约时间截止 */
@property (nonatomic, copy) NSString *preorderEndTime;
/** 用户预约时间开始 */
@property (nonatomic, copy) NSString *preorderStartTime;
/** 收货人电话 */
@property (nonatomic, copy) NSString *sellerAddressId;
/** 固定电话 */
@property (nonatomic, copy) NSString *telephone;
@end

@interface JHRecyclePickupLogisticsInfoModel : NSObject
/** 物流公司code */
@property (nonatomic, copy) NSString *logisticsCode;
/** 物流公司logo */
@property (nonatomic, copy) NSString *logisticsIcon;
/** 物流公司名称 */
@property (nonatomic, copy) NSString *logisticsTitle;

@property (nonatomic, strong) JHRecyclePickupAppointmentInfoImgUrlModel *logisticsImage;

@end

///未预约-预约取件信息
@interface JHRecyclePickupGoToAppointmentModel : NSObject
/** 快递包装建议 */
@property (nonatomic, copy) NSString *packingAdvice;
/** 建议图片 */
@property (nonatomic, strong) JHRecyclePickupAppointmentInfoImgUrlModel *adviceImgUrl;
/** 取件地址 */
@property (nonatomic, strong) JHRecyclePickupAppointmentPickAddressModel *pickAddress;
/** 物流公司信息列表 */
@property (nonatomic, strong) NSArray<JHRecyclePickupLogisticsInfoModel *> *logisticsInfo;

@end


///已预约-上门取件内容
@interface JHRecyclePickupAppointmentSuccessModel : NSObject

/** 联系客服电话：400-623-0666 */
@property (nonatomic, copy) NSString *contactWaiterPhone;
/** 平台客服电话：010-8648-8816 */
@property (nonatomic, copy) NSString *platformWaiterPhone;
/** 预约信息 */
@property (nonatomic, copy) NSString *preorderMessage;
/** 预约取件时间 */
@property (nonatomic, copy) NSString *preorderTime;
/** 预约取件人信息 */
@property (nonatomic, strong) JHRecyclePickupAppointmentPickAddressModel *sellerAddress;
/** 物流公司信息列表 */
@property (nonatomic, strong) NSArray<JHRecyclePickupLogisticsInfoModel *> *logisticsInfo;

@end

NS_ASSUME_NONNULL_END
