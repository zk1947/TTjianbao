//
//  JHUnionSignShowDataSourceModel.h
//  TTjianbao
//
//  Created by apple on 2020/4/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHUnionSignShowDataSourceModel : NSObject

/// 签约商户开户账户名称
@property (nonatomic, copy) NSString *bankAcctName;

/// 签约商户开户银行卡号
@property (nonatomic, copy) NSString *bankAcctNo;

///签约商户开户地区名称
@property (nonatomic, copy) NSString *bankAcctProvince;

///签约商户开户行支行名称
@property (nonatomic, copy) NSString *bankBranchName;

/// 银行卡反面照片
@property (nonatomic, copy) NSString *bankCardConsPicUrl;

///签约商户开户银行名称
@property (nonatomic, copy) NSString *bankCardName;

/// 银行卡正面照片
@property (nonatomic, copy) NSString *bankCardProsPicUrl;

/// 签约商户开户行行号
@property (nonatomic, copy) NSString *bankNo;

/// 银行预留手机号
@property (nonatomic, copy) NSString *bankPhone;

/// 签约商户身份反面照片
@property (nonatomic, copy) NSString *cardConsPicUrl;

/// 签约商户身份正面照片
@property (nonatomic, copy) NSString *cardProsPicUrl;

/// 签约商户手持身份证照片
@property (nonatomic, copy) NSString *personCardPicUrl;


/// 签约商户id
@property (nonatomic, copy) NSString *customerId;

///签约商户类型
@property (nonatomic, copy) NSString *customerType;

/// 签约商户邮箱
@property (nonatomic, copy) NSString *legaEmail;

/// 约商户身份证号
@property (nonatomic, copy) NSString *legalIdcardNo;

/// 签约商户电话号
@property (nonatomic, copy) NSString *legalMobile;

/// 签约商户姓名
@property (nonatomic, copy) NSString *legalName;

/// 营业场所店内照片图片地址
@property (nonatomic, copy) NSString *licenseIntoPicUrl;

/// 营业场所门头照片图片地址
@property (nonatomic, copy) NSString *licenseOutPicUrl;

/// 营业场所照片图片地址
@property (nonatomic, copy) NSString *licensePicUrl;

/// 营业执照类型0：企业 2：个人 ,
@property (nonatomic, assign) NSInteger licenseType;

/// 开户照片
@property (nonatomic, copy) NSString *openAccountPicUrl;

/// 对公账户验证请求次数
@property (nonatomic, copy) NSString *regCount;

/// 电子签约地址信息
@property (nonatomic, copy) NSString *requestInfoUrl;

/// 营业详细地址
@property (nonatomic, copy) NSString *shopAddrExt;

/// 营业城市
@property (nonatomic, copy) NSString *shopCityId;

/// 营业区
@property (nonatomic, copy) NSString *shopCountryId;

/// 营业执照编码
@property (nonatomic, copy) NSString *shopLic;


@property (nonatomic, copy) NSString *shopName;

/// 营业省市区，商户为企业商户类型时必传
@property (nonatomic, copy) NSString *shopProvince;

///营业省份
@property (nonatomic, copy) NSString *shopProvinceId;

/// 签约状态 0未签约 4签约中，1审核中，2签约 成功，3签约失败,5对公账户等待验证
@property (nonatomic, assign) NSInteger status;

///签约成功后商户号
@property (nonatomic, copy) NSString *unionpayMerchantNo;

/// 是否是个人 (自己加的)
@property (nonatomic, assign) BOOL isPerson;

@end

NS_ASSUME_NONNULL_END
