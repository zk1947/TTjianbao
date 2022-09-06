//
//  JHUnionPayModel.h
//  TTjianbao
//
//  Created by lihui on 2020/4/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHProviceModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JHCustomerType) {
    JHCustomerTypeCompany = 0,      ///企业
    JHCustomerTypePersonal = 2,     ///个人
};

typedef NS_ENUM(NSInteger, JHDataType) {
    ///真实/法人姓名
    JHDataTypeLegalName = 0,
    ///身份证
    JHDataTypeIdNumber = 1,
    ///邮箱
    JHDataTypeEmail = 2,
    ///手机号
    JHDataTypePhone = 3,
    ///身份证正面
    JHDataTypeIdCardFront = 4,
    ///身份证反面
    JHDataTypeIdCardBack = 5,
    ///手持身份证照片
    JHDataTypeIdCardHandle = 6,
    ///银行卡号
    JHDataTypeBankCardNumber = 7,
    ///银行名称
    JHDataTypeBankName = 8,
    ///开户地区
    JHDataTypeBankAccoProvince = 9,
    ///所属支行
    JHDataTypeBankAccoSubBranch = 10,
    ///银行预留手机号
    JHDataTypeBankPhone = 11,
    ///银行卡正面照片
    JHDataTypeBankCardFront = 12,
    ///银行卡反面照片
    JHDataTypeBankCardBack = 13,
    ///营业名称
    JHDataTypeAccountShopName = 14,
    ///营业地区 省份
    JHDataTypeAccountProvince = 15,
    ///营业地区 市
    JHDataTypeAccountCity = 16,
    ///营业地区 地区
    JHDataTypeAccountArea = 17,
    ///详细地址
    JHDataTypeShopDetailAddress = 18,
    ///社会统一代码
    JHDataTypeSocialUniformCode = 19,
    ///营业执照照片
    JHDataTypeAccountShopLicense = 20,
    ///公司开户名称
    JHDataTypeBankAccountName = 21,
    ///公司开户证明材料
    JHDataTypeOpenAccountPic = 22,
    ///对公账户认证打款金额
    JHDataTypePublicAccountAmount = 23,
    ///企业用户家庭地址
    JHDataTypeLegalHomeAddress = 24,
    ///控股股东姓名
    JHDataTypeStockholderName = 25,
    ///控股股东身份证号
    JHDataTypeStockholderId = 26,
    ///控股股东证件有效期
    JHDataTypeStockholderIdEndDate = 27,
    ///受益人姓名
    JHDataTypeBeneficiaryName = 28,
    ///受益人身份证号
    JHDataTypeBeneficiaryId = 29,
    ///受益人证件有效期至
    JHDataTypeBeneficiaryIdEndDate = 30,
    ///受益人家庭地址
    JHDataTypeBeneficiaryAddress = 31,
};

@interface JHUnionPayModel : NSObject

@property (nonatomic, copy) NSString *customerId;               ///用户id
@property (nonatomic, copy) NSString *customerType;             ///签约类型  02： 个人商家    00：企业商家
@property (nonatomic, copy) NSString *legalName;                ///真实姓名
@property (nonatomic, copy) NSString *encrptLegalName;          ///加密后的真实姓名
@property (nonatomic, copy) NSString *legalIdcardNo;            ///身份证号
@property (nonatomic, copy) NSString *encrptLegalIdcardNo;      ///加密后的身份证号
@property (nonatomic, copy) NSString *legaEmail;                ///邮箱
@property (nonatomic, copy) NSString *legalMobile;              ///手机号
@property (nonatomic, copy) NSString *encrptLegalMobile;        ///加密后的手机号
@property (nonatomic, copy) NSString *legalHomeAddr;            ///企业用户法人家庭地址
@property (nonatomic, copy) NSString *cardProsPicUrl;           ///身份证正照片
@property (nonatomic, copy) NSString *cardConsPicUrl;           ///身份证反照片
@property (nonatomic, copy) NSString *personCardPicUrl;         ///商户手持身份证照片

@property (nonatomic, copy) NSString *bankAcctNo;               ///银行卡号
@property (nonatomic, copy) NSString *encrptBankAcctNo;         ///加密后的银行卡号
@property (nonatomic, copy) NSString *bankCardName;             ///银行卡名称
@property (nonatomic, copy) NSString *bankAcctName;             ///公司开户行名称
@property (nonatomic, copy) NSString *bankAcctProvince;         ///开户地区
@property (nonatomic, copy) NSString *bankBranchName;           ///所属支行
@property (nonatomic, copy) NSString *bankNo;                   ///支行行号
@property (nonatomic, copy) NSString *bankPhone;                ///银行预留手机号
@property (nonatomic, copy) NSString *encrptBankPhone;          ///银行预留手机号
@property (nonatomic, copy) NSString *bankCardProsPicUrl;       ///银行卡正面照片
@property (nonatomic, copy) NSString *bankCardConsPicUrl;       ///银行卡反面照片

@property (nonatomic, copy) NSString *shopName;                 ///营业名称
@property (nonatomic, copy) NSString *shopProvince;             ///营业地区
@property (nonatomic, copy) NSString *shopProvinceId;           ///营业省份
@property (nonatomic, copy) NSString *shopCityId;               ///营业城市
@property (nonatomic, copy) NSString *shopCountryId;            ///营业区
@property (nonatomic, copy) NSString *shopAddrExt;              ///详细地址
@property (nonatomic, copy) NSString *shopLic;                  ///社会统一代码
@property (nonatomic, copy) NSString *licensePicUrl;            ///营业执照照片
@property (nonatomic, copy) NSString *openAccountPicUrl;        ///开户证明材料
///372新增
@property (nonatomic, copy) NSString *shareholderName;          ///控股股东姓名
@property (nonatomic, copy) NSString *entryShareholderName;     ///控股股东姓名       加密
@property (nonatomic, copy) NSString *shareholderCertno;        ///控股股东证件号码
@property (nonatomic, copy) NSString *entryShareholderCertno;   ///控股股东证件号码     加密
@property (nonatomic, copy) NSString *shareholderCertExpire;    ///控股股东有效期
@property (nonatomic, copy) NSString *bnfName;                  ///受益人姓名
@property (nonatomic, copy) NSString *entryBnfName;             ///受益人姓名            加密
@property (nonatomic, copy) NSString *bnfCertno;                ///受益人证件号码
@property (nonatomic, copy) NSString *entryBnfCertno;           ///受益人证件号码      加密
@property (nonatomic, copy) NSString *bnfCertExpire;            ///受益人证件有效期
@property (nonatomic, copy) NSString *bnfHomeAddr;              ///受益人家庭地址
@end

@interface JHUnionPayTypeModel : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *customerType;   ///商户签约类型
@property (nonatomic, strong) NSMutableArray <JHUnionPayTypeModel *>*list;

@end

@interface JHProcessModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSNumber *index;
@property (nonatomic, strong) UIColor *leftlineColor;
@property (nonatomic, strong) UIColor *rightlineColor;
@property (nonatomic, assign) BOOL showLeftLine;
@property (nonatomic, assign) BOOL showRightLine;
@property (nonatomic, assign) BOOL isFinished;  ///是否选中 是否结束

@end

@class JHUnionPayUserListModel;
@class JHUnionPayUserPhotoModel;

@interface JHUnionPayUserInfoModel : NSObject

@property (nonatomic, copy) NSString *message;   ///信息
@property (nonatomic, assign) CGFloat messageHeight;  ///信息高度
@property (nonatomic, copy) NSString *alert;     ///提示
@property (nonatomic, assign) CGFloat alertHeight;  ///提示高度

@property (nonatomic, strong) NSMutableArray <JHUnionPayUserListModel*>*listArray;
@property (nonatomic, strong) NSMutableArray <JHUnionPayUserPhotoModel*>*photoArray;
///控股股东信息
@property (nonatomic, strong) NSMutableArray <JHUnionPayUserListModel*>*legalArray;
///受益人信息
@property (nonatomic, strong) NSMutableArray <JHUnionPayUserListModel*>*beneficArray;

@end

@interface JHUnionPayUserListModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) NSString *inputTextString;
@property (nonatomic, assign) JHDataType dataType;
@property (nonatomic, assign) UIKeyboardType keyboardType;   ///键盘类型
@property (nonatomic, assign) NSInteger maxInputLength; //限制最多输入字符数

@end

@interface JHUnionPayUserPhotoModel : NSObject

@property (nonatomic, copy) NSString *iconName;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) id selectPhoto;           ///选中的照片
@property (nonatomic, assign) JHDataType dataType;      ///数据类型

@end

@interface JHUnionPaySubBankModel : NSObject

@property (nonatomic, copy) NSString *bankBranchName;   ///支行名称
@property (nonatomic, copy) NSString *code;             ///支行代码

@end




NS_ASSUME_NONNULL_END
