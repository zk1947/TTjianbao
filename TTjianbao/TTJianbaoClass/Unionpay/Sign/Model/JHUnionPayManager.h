//
//  JHUnionPayManager.h
//  TTjianbao
//
//  Created by lihui on 2020/4/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
/// 管理银联签约的管理类

#import <Foundation/Foundation.h>
#import "JHUnionPayModel.h"

NS_ASSUME_NONNULL_BEGIN

static NSString *const kCustomerTypeCommpany = @"00";
static NSString *const kCustomerTypePersonal = @"02";

typedef NS_ENUM(NSInteger, JHSignContractPageType) {
    ///用户个人信息填写页面
    JHSignContractPageTypeAccunt,
    ///营业信息填写页面
    JHSignContractPageTypeBusiness,
    ///公司开户行账户信息填写
    JHSignContractPageTypeBankAccoInfo,
    ///个人银行卡信息填写
    JHSignContractPageTypeBankCardInfo,
};

@interface JHUnionPayManager : NSObject

+ (instancetype)shareManager;
///重置用户信息
- (void)resetUserInfo;

/// 选择图片后存储到单例中
/// @param model 选择的图片model
- (void)configSelectPicByPicModel:(JHUnionPayUserPhotoModel *)model;

///获取信息回显的数据 --- 处理
- (void)cofigSignInfo:(JHUnionPayModel *)model;

///获取提交档案资料时的参数信息
- (NSDictionary *)configParams;

/// 根据type获取提示信息字符串
/// @param type 页面类型
+ (NSString *)getTipStringWithPageType:(JHSignContractPageType)type;

/// 获取所属支行信息
/// @param cityId 城市id
/// @param key 城市key
/// @param block 网络请求成功或者失败回调
+ (void)getBankSubBranch:(NSString *)cityId key:(NSString *)key completeBlock:(HTTPCompleteBlock)block;

/// 档案资料上传
/// @param contractInfo 档案资料相关参数
/// @param block 网络请求回调
+ (void)submitSignContract:(NSDictionary *)contractInfo completeBlock:(HTTPCompleteBlock)block;

/// 对公账户认证接口
/// @param customerId 用户id
/// @param transAmt 随机交易金额
/// @param block 网络请求回调
+ (void)accountContract:(NSString *)customerId
               transAmt:(NSString *)transAmt
          completeBlock:(HTTPCompleteBlock)block;

/// 对公账户发起验证交易接口
/// @param customerId 用户id
/// @param block 网络请求回调
+ (void)accountContract:(NSString *)customerId
          completeBlock:(HTTPCompleteBlock)block;

///上传图片 单个上传
- (void)uploadSignContractImg:(JHCustomerType)type CompleteBlock:(void(^)(NSString *idCardFront, NSString *idCardBack, NSString *idCardHandle, NSString *bankCardFront, NSString *bankCardBack,NSString *license, NSString *proofMertial))block;

/// 信息回显 获取填写的信息数据
/// @param type 数据类型
+ (NSString *)getuserInfoByDataType:(JHDataType)type;

/// 签约后信息查询 0-个人中心显示         1-数据回调显示
+(void)getUnionSignAllInfoWithQueryType:(NSInteger)type completeBlock:(nullable void(^)(NSDictionary *dataDic,BOOL success))completeBlock;

///解密接口返回的用户信息的相关字段
+ (JHUnionPayModel *)decrytUnionPayInfo:(JHUnionPayModel *)model;

@property (nonatomic, strong) JHUnionPayModel * _Nullable unionpayModel;  ///保存用户信息的类

///签约的h5页面地址
@property (nonatomic, copy) NSString *requestInfoUrl;
///身份证正面照片
@property (nonatomic, strong) id _Nullable idCardProsPic;
///身份证反面照片
@property (nonatomic, strong) id _Nullable idCardConsPic;
///手持身份证
@property (nonatomic, strong) id _Nullable idCardHandlePic;
///银行卡正面照片
@property (nonatomic, strong) id _Nullable bankCardProsPic;
/// 银行卡反面照片
@property (nonatomic, strong) id _Nullable bankCardConsPic;
///用户营业执照照片
@property (nonatomic, strong) id _Nullable accoLicensePic;

///用户证明材料照照片
@property (nonatomic, strong) id _Nullable proofMaterialPic;

///开户省市
@property (nonatomic, strong) JHProviceModel *accoProvince;
///开户城市
@property (nonatomic, strong) JHCityModel *accoCity;
///开户区级
@property (nonatomic, strong) JHAreaModel *accoArea;

@end

NS_ASSUME_NONNULL_END
