//
//  JHUnionPayManager.m
//  TTjianbao
//
//  Created by lihui on 2020/4/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHUnionPayManager.h"
#import <NSString+YYAdd.h>
#import "CommHelp.h"
#import "TTjianbao.h"
#import "JHUploadManager.h"
#import "UIImage+JHCompressImage.h"
#import "JHUnionPayModel.h"
#import "RSA.h"
#import "JHRSAKey.h"

#define kMaxImageByte  (2*1024)

static JHUnionPayManager *shareManager = nil;

@implementation JHUnionPayManager

+ (instancetype)shareManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[JHUnionPayManager alloc] init];
    });
    return shareManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

- (JHUnionPayModel *)unionpayModel {
    if (!_unionpayModel) {
        _unionpayModel = [[JHUnionPayModel alloc] init];
    }
    return _unionpayModel;
}

#pragma mark - 根据数据类型返回提示信息
+ (NSString *)getTipStringWithPageType:(JHSignContractPageType)type {
    JHUnionPayModel *model = [JHUnionPayManager shareManager].unionpayModel;
    NSString * str = nil;
    if (type == JHSignContractPageTypeAccunt) {
        if (![model.legalName isNotBlank]) {  ///真实姓名
            str = @"inputName";
        }
        else if (![model.legalIdcardNo isNotBlank]) { ///身份证号
            str = @"inputIdCard";
        }
        else if (![model.legaEmail isNotBlank]) {  ///邮箱
            str = @"inputEmail";
        }
        else if (![model.legalMobile isNotBlank]) {  ///手机号
            str = @"inputTelephone";
        }
        else if ([model.customerType isEqualToString:@"00"] && ![model.legalHomeAddr isNotBlank]) {  ///家庭地址
            str = @"inputLegalHomeAddress";
        }
        else if (![CommHelp judgeIdentityStringValid:model.legalIdcardNo]) {
            str = @"inputBingleIdNumber";
        }
        else if (![model.legaEmail isEmail]) {///正确的邮箱
            str = @"inputBingleEmail";
        }
        else if (![CommHelp isValidateMobile:model.legalMobile]) {
            ///[model.legalMobile isPhoneNumber]
            str = @"inputBingleTelephone";
        }
        else {
            ///图片提示
            if ([JHUnionPayManager shareManager].idCardProsPic == nil) {
                str = @"selectFrontIdCardPic";
            }
            else if ([JHUnionPayManager shareManager].idCardConsPic == nil) {
                str = @"selectBackIdCardPic";
            }
            else if ([JHUnionPayManager shareManager].idCardHandlePic == nil) {
                str = @"selectHandlePic";
            }
        }
        return JHLocalizedString(str);
    }
    if (type == JHSignContractPageTypeBusiness) {
        if (![model.shopName isNotBlank]) {
            str = @"inputShopName";
        }
        else if (![model.shopProvince isNotBlank]) {
            str = @"selectShopProvince";
        }
        else if (![model.shopAddrExt isNotBlank]) {
            str = @"inputShopDetailAddr";
        }
        else if (![model.shopLic isNotBlank]) {
            str = @"inputUniqueCode";
        }
        else if ([JHUnionPayManager shareManager].accoLicensePic == nil) {
            str = @"uploadShopLicensePic";
        }

        return JHLocalizedString(str);
    }
    if (type == JHSignContractPageTypeBankAccoInfo) {
        ///公司开户行信息
        if (![model.bankAcctName isNotBlank]) {
            str = @"inputBankAccoName";
        }
        else if (![model.bankAcctNo isNotBlank]) {
            str = @"inputBankCardNo";
        }
        else if (![model.bankAcctProvince isNotBlank]) {
            str = @"selectBankAccoProvince";
        }
        else if (![model.bankBranchName isNotBlank]) {
            str = @"selectBankBranch";
        }
        else if (![model.bankPhone isNotBlank]) {
            str = @"inputBankTelephone";
        }
//        else if (![model.bankAcctNo checkCardNo]) {
//            str = @"inputBingleBankCardNo";
//        }
        else if ([JHUnionPayManager shareManager].proofMaterialPic == nil) {
            str = @"accountProofMetrial";
        }
        else if (![model.shareholderName isNotBlank]) {
            str = @"请输入控股股东姓名";
        }
        else if (![model.shareholderCertno isNotBlank]) {
            str = @"请输入控股股东证件号码";
        }
        else if (![model.shareholderCertExpire isNotBlank]) {
            str = @"请选择控股股东证件有效期";
        }
        else if (![model.bnfName isNotBlank]) {
            str = @"请输入受益人姓名";
        }
        else if (![model.bnfCertno isNotBlank]) {
            str = @"请输入受益人证件号码";
        }
        else if (![model.bnfCertExpire isNotBlank]) {
            str = @"请选择受益人证件有效期";
        }
        else if (![model.bnfHomeAddr isNotBlank]) {
            str = @"请输入受益人家庭地址";
        }
        return JHLocalizedString(str);
    }
    if (type == JHSignContractPageTypeBankCardInfo) {
        ///个人
        if (![model.bankAcctNo isNotBlank]) {
            str = @"inputBankCardNo";
        }
        else if (![model.bankAcctProvince isNotBlank]) {
            str = @"selectBankAccoProvince";
        }
        else if (![model.bankBranchName isNotBlank]) {
            str = @"selectBankBranch";
        }
        else if (![model.bankPhone isNotBlank]) {
            str = @"inputBankTelephone";
        }
        else {
            ///图片提示
            if ([JHUnionPayManager shareManager].bankCardProsPic == nil) {
                str = @"uploadBankCardFrontPic";
            }
            else if ([JHUnionPayManager shareManager].bankCardConsPic == nil) {
                str = @"uploadBankCardBackPic";
            }
        }
        return JHLocalizedString(str);
    }
    return nil;
}

+ (void)getBankSubBranch:(NSString *)cityId key:(NSString *)key completeBlock:(HTTPCompleteBlock)block {
    NSString *url = FILE_BASE_STRING(@"/signContract/signContract/auth/queryBank");
    NSDictionary *params = @{@"cityId":cityId, @"key":key};
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(respondObject, NO);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(respondObject, YES);
        }
    }];
}

///提交档案资料
+ (void)submitSignContract:(NSDictionary *)contractInfo completeBlock:(HTTPCompleteBlock)block {
    [HttpRequestTool sessionManager].requestSerializer.timeoutInterval = 10000.0f;
    NSString *url = FILE_BASE_STRING(@"/signContract/signContract/auth/submitSignContract");
    [HttpRequestTool postWithURL:url Parameters:contractInfo requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(respondObject, NO);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [UITipView showTipStr:respondObject.message ?: @"资料提交失败，请重试"];
        if (block) {
            block(respondObject, YES);
        }
    }];
}

///对公账户认证接口
+ (void)accountContract:(NSString *)customerId
               transAmt:(NSString *)transAmt
          completeBlock:(HTTPCompleteBlock)block {
    
    NSString *url = FILE_BASE_STRING(@"/signContract/signContract/auth/accountReg");
    NSDictionary *params = @{@"customerId":customerId, @"transAmt":transAmt};

    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(respondObject, NO);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(respondObject, NO);
        }
    }];
}

///对公账户发起验证交易接口
+ (void)accountContract:(NSString *)customerId
          completeBlock:(HTTPCompleteBlock)block {
    
    NSString *url = FILE_BASE_STRING(@"/signContract/signContract/auth/askAccountReg");
    NSDictionary *params = @{@"customerId":customerId};
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(respondObject, NO);
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (block) {
            block(respondObject, NO);
        }
    }];
}

- (void)uploadSignContractImg:(JHCustomerType)type CompleteBlock:(void(^)(NSString *idCardFront, NSString *idCardBack, NSString *idCardHandle, NSString *bankCardFront, NSString *bankCardBack,NSString *license, NSString *proofMertial))block {
    __block NSString *cardFront, *cardBack, *cardHandle, *license, *proofFile, *bankFront, *bankBack;
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("com.signContract.www", DISPATCH_QUEUE_CONCURRENT);
    ///身份证正面
    dispatch_group_async(group, queue, ^{
        id img = [JHUnionPayManager shareManager].idCardProsPic;
        if ([img isKindOfClass:[UIImage class]]) {
            dispatch_group_enter(group);
            UIImage *idCardProsPic = [img compressedImageFiles:img imageMaxSizeKB:kMaxImageByte];
            [self uploadsignContractImg:idCardProsPic completeBlock:^(NSString * _Nonnull imgKey) {
                if (imgKey) {
                    cardFront = imgKey;
                }
                dispatch_group_leave(group);
            }];
        }
        else {
            cardFront = img;
        }
    });
    ///身份证反面
    dispatch_group_async(group, queue, ^{
        id img = [JHUnionPayManager shareManager].idCardConsPic;
        if ([img isKindOfClass:[UIImage class]]) {
            dispatch_group_enter(group);
            UIImage *idCardConsPic = [img compressedImageFiles:img imageMaxSizeKB:kMaxImageByte];
            [self uploadsignContractImg:idCardConsPic completeBlock:^(NSString * _Nonnull imgKey) {
                if (imgKey) {
                    cardBack = imgKey;
                }
              dispatch_group_leave(group);
            }];
        }
        else {
            cardBack = img;
        }
    });
    ///手持身份证
    dispatch_group_async(group, queue, ^{
        id img = [JHUnionPayManager shareManager].idCardHandlePic;
        if ([img isKindOfClass:[UIImage class]]) {
            dispatch_group_enter(group);
            UIImage *idCardHandlePic = [img compressedImageFiles:img imageMaxSizeKB:kMaxImageByte];
            [self uploadsignContractImg:idCardHandlePic completeBlock:^(NSString * _Nonnull imgKey) {
                if (imgKey) {
                    cardHandle = imgKey;
                }
                dispatch_group_leave(group);
            }];
        }
        else {
            cardHandle = img;
        }
    });
    ///公司
    if (type == JHCustomerTypeCompany) {
        ///营业执照
        dispatch_group_async(group, queue, ^{
            ///手持身份证
            id img = [JHUnionPayManager shareManager].accoLicensePic;
            if ([img isKindOfClass:[UIImage class]]) {
                dispatch_group_enter(group);
                UIImage *accoLicensePic = [img compressedImageFiles:img imageMaxSizeKB:kMaxImageByte];
                [self uploadsignContractImg:accoLicensePic completeBlock:^(NSString * _Nonnull imgKey) {
                    if (imgKey) {
                        license = imgKey;
                    }
                    dispatch_group_leave(group);
                }];
            }
            else {
                license = img;
            }
        });
        ///证明材料
        dispatch_group_async(group, queue, ^{
            id img = [JHUnionPayManager shareManager].proofMaterialPic;
            if ([img isKindOfClass:[UIImage class]]) {
                dispatch_group_enter(group);
                UIImage *proofMaterialPic = [img compressedImageFiles:img imageMaxSizeKB:kMaxImageByte];
                [self uploadsignContractImg:proofMaterialPic completeBlock:^(NSString * _Nonnull imgKey) {
                    if (imgKey) {
                        proofFile = imgKey;
                    }
                    dispatch_group_leave(group);
                }];
            }
            else {
                proofFile = img;
            }
        });
    }
    else {
        ///银行卡正面
        dispatch_group_async(group, queue, ^{
            id img = [JHUnionPayManager shareManager].bankCardProsPic;
            if ([img isKindOfClass:[UIImage class]]) {
                dispatch_group_enter(group);
                UIImage *bankCardProsPic = [img compressedImageFiles:img imageMaxSizeKB:kMaxImageByte];
                [self uploadsignContractImg:bankCardProsPic completeBlock:^(NSString * _Nonnull imgKey) {
                    if (imgKey) {
                        bankFront = imgKey;
                    }
                    dispatch_group_leave(group);
                }];
            }
            else {
                bankFront = img;
            }
        });
        ///银行卡反面
        dispatch_group_async(group, queue, ^{
            id img = [JHUnionPayManager shareManager].bankCardConsPic;
            if ([img isKindOfClass:[UIImage class]]) {
                dispatch_group_enter(group);
                UIImage *bankCardConsPic = [img compressedImageFiles:img imageMaxSizeKB:kMaxImageByte];
                [self uploadsignContractImg:bankCardConsPic completeBlock:^(NSString * _Nonnull imgKey) {
                    if (imgKey) {
                        bankBack = imgKey;
                    }
                    dispatch_group_leave(group);
                }];
            }
            else {
                bankBack = img;
            }
        });
    }
    
    ///上传完成
    dispatch_group_notify(group, queue, ^{
        if (block) {
            block(cardFront, cardBack, cardHandle, bankFront, bankBack, license, proofFile);
        }
    });
}

- (void)uploadsignContractImg:(UIImage *)image completeBlock:(void(^)(NSString *imgKey))block {
    if (image == nil) {
        return;
    }
    [[JHUploadManager shareInstance] uploadSingleImage:image filePath:kJHAiyunSignContractpath finishBlock:^(BOOL isFinished, NSString * _Nonnull imgKey) {
        if (isFinished && [imgKey isNotBlank]) {
            ///已经上传完成
            if (block) {
                block(imgKey);
            }
        }
        else {
            [UITipView showTipStr:@"图片上传失败，请重试"];
            if (block) {
                block(nil);
            }
        }
    }];
}

+ (NSString *)getuserInfoByDataType:(JHDataType)type {
    JHUnionPayModel *payModel = [JHUnionPayManager shareManager].unionpayModel;
    switch (type) {
        case JHDataTypeLegalName: ///真是姓名
            return [payModel.legalName isNotBlank] ? payModel.legalName : nil;
            break;
        case JHDataTypeIdNumber: ///身份证号
            return [payModel.legalIdcardNo isNotBlank] ? payModel.legalIdcardNo : nil;
            break;
        case JHDataTypeEmail: ///邮箱
            return [payModel.legaEmail isNotBlank] ? payModel.legaEmail : nil;
            break;
        case JHDataTypePhone: ///手机号
            return [payModel.legalMobile isNotBlank] ? payModel.legalMobile : nil;
            break;
        case JHDataTypeBankCardNumber: ///银行卡号
            return [payModel.bankAcctNo isNotBlank] ? payModel.bankAcctNo : nil;
            break;
        case JHDataTypeBankName: ///银行名称
            return [payModel.bankCardName isNotBlank] ? payModel.bankCardName : nil;
            break;
        case JHDataTypeBankAccoProvince: ///开户地区
            return [payModel.bankAcctProvince isNotBlank] ? payModel.bankAcctProvince : nil;
            break;
        case JHDataTypeBankAccoSubBranch: ///所属支行
            return [payModel.bankBranchName isNotBlank] ? payModel.bankBranchName : nil;
            break;
        case JHDataTypeBankPhone: ///银行预留手机号
            return [payModel.bankPhone isNotBlank] ? payModel.bankPhone : nil;
            break;
        case JHDataTypeAccountShopName: ///营业名称
            return [payModel.shopName isNotBlank] ? payModel.shopName : nil;
            break;
        case JHDataTypeAccountProvince: ///营业地区 省份
            return [payModel.shopProvince isNotBlank] ? payModel.shopProvince : nil;
            break;
        case JHDataTypeAccountCity: ///银行预留手机号
            return [payModel.shopCityId isNotBlank] ? payModel.shopCityId : nil;
            break;
        case JHDataTypeAccountArea: ///营业名称
            return [payModel.shopCountryId isNotBlank] ? payModel.shopCountryId : nil;
            break;
        case JHDataTypeShopDetailAddress: ///详细地址
            return [payModel.shopAddrExt isNotBlank] ? payModel.shopAddrExt : nil;
            break;
        case JHDataTypeSocialUniformCode: ///社会统一代码
            return [payModel.shopLic isNotBlank] ? payModel.shopLic : nil;
            break;
        case JHDataTypeBankAccountName: ///公司开户名称
            return [payModel.bankAcctName isNotBlank] ? payModel.bankAcctName : nil;
            break;
        case JHDataTypeOpenAccountPic: ///公司开户证明材料
            return [payModel.openAccountPicUrl isNotBlank] ? payModel.openAccountPicUrl : nil;
            break;
        case JHDataTypeLegalHomeAddress: ///法人家庭地址
            return [payModel.legalHomeAddr isNotBlank] ? payModel.legalHomeAddr : nil;
            break;
        case JHDataTypeStockholderName: ///控股股东姓名
            return [payModel.shareholderName isNotBlank] ? payModel.shareholderName : nil;
            break;
        case JHDataTypeStockholderId: ///控股股东证件号码
            return [payModel.shareholderCertno isNotBlank] ? payModel.shareholderCertno : nil;
            break;
        case JHDataTypeStockholderIdEndDate: ///控股股东证件有效期
            return [payModel.shareholderCertExpire isNotBlank]
            ? ([payModel.shareholderCertExpire isEqualToString:kUnionPayForeverTimeKey]?@"长期":payModel.shareholderCertExpire)
            : nil;
            break;
        case JHDataTypeBeneficiaryName: ///受益人姓名
            return [payModel.bnfName isNotBlank] ? payModel.bnfName : nil;
            break;
        case JHDataTypeBeneficiaryId: ///受益人证件号码
            return [payModel.bnfCertno isNotBlank] ? payModel.bnfCertno : nil;
            break;
        case JHDataTypeBeneficiaryIdEndDate: ///受益人证件号码有效期
            return [payModel.bnfCertExpire isNotBlank]
            ? ([payModel.bnfCertExpire isEqualToString:kUnionPayForeverTimeKey]?@"长期":payModel.bnfCertExpire)
            : nil;
            break;
        case JHDataTypeBeneficiaryAddress: ///受益人家庭地址
            return [payModel.bnfHomeAddr isNotBlank] ? payModel.bnfHomeAddr : nil;
            break;
        default:
            return nil;
            break;
    }
}

/// 签约后信息查询 0-个人中心显示       1-数据回调显示
+(void)getUnionSignAllInfoWithQueryType:(NSInteger)type completeBlock:(void (^)(NSDictionary * _Nonnull, BOOL))completeBlock{
    NSString *url = FILE_BASE_STRING(@"/signContract/signContract/auth/accountInfoQuery");
    [HttpRequestTool postWithURL:url Parameters:@{@"queryType":@(type)} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        NSDictionary *dic = respondObject.data;
        if (completeBlock) {
            if(IS_DICTIONARY(dic)){
                completeBlock(dic, YES);
            }
            else{
                completeBlock(@{@"errorMessage" : respondObject.message}, NO);
            }
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        if (completeBlock) {
            completeBlock(@{@"errorMessage" : respondObject.message}, NO);
        }
    }];
}

#pragma mark -
#pragma mark - 选择图片后存储到单例

- (void)configSelectPicByPicModel:(JHUnionPayUserPhotoModel *)model {
    switch (model.dataType) {
        case JHDataTypeIdCardFront:  ///身份证正面
            self.idCardProsPic = model.selectPhoto;
            break;
        case JHDataTypeIdCardBack:  ///身份证反面
            self.idCardConsPic = model.selectPhoto;
            break;
        case JHDataTypeIdCardHandle:  ///手持身份证
            self.idCardHandlePic = model.selectPhoto;
            break;
        case JHDataTypeBankCardFront:  ///银行卡正面
            self.bankCardProsPic = model.selectPhoto;
            break;
        case JHDataTypeBankCardBack:  ///银行卡反面
            self.bankCardConsPic = model.selectPhoto;
            break;
        case JHDataTypeAccountShopLicense:  ///营业执照照片
            self.accoLicensePic = model.selectPhoto;
            break;
        case JHDataTypeOpenAccountPic:  ///商家开户证明资料
            self.proofMaterialPic = model.selectPhoto;
            break;
        default:
            break;
    }
}



#pragma mark -
#pragma mark - 转换档案资料提交的参数信息

- (NSDictionary *)configParams {
    ///加密敏感信息
    [self encryptSignInfo];
    NSMutableDictionary *params = [self.unionpayModel mj_keyValues].mutableCopy;
    ///删除多余的字段
    [params removeObjectForKey:@"encrptLegalName"];
    [params removeObjectForKey:@"encrptLegalIdcardNo"];
    [params removeObjectForKey:@"encrptLegalMobile"];
    [params removeObjectForKey:@"encrptBankAcctNo"];
    [params removeObjectForKey:@"encrptBankPhone"];
    
    [params setValue:self.unionpayModel.encrptLegalName forKey:@"legalName"];
    [params setValue:self.unionpayModel.encrptLegalIdcardNo forKey:@"legalIdcardNo"];
    [params setValue:self.unionpayModel.encrptLegalMobile forKey:@"legalMobile"];
    [params setValue:self.unionpayModel.encrptBankAcctNo forKey:@"bankAcctNo"];
    [params setValue:self.unionpayModel.encrptBankPhone forKey:@"bankPhone"];
    ///372新增
    [params setValue:self.unionpayModel.entryShareholderName forKey:@"shareholderName"];
    [params setValue:self.unionpayModel.entryShareholderCertno forKey:@"shareholderCertno"];
    [params setValue:self.unionpayModel.entryBnfName forKey:@"bnfName"];
    [params setValue:self.unionpayModel.entryBnfCertno forKey:@"bnfCertno"];
    
    return params;
}

#pragma mark - 转换用户信息 用于信息回显
- (void)cofigSignInfo:(JHUnionPayModel *)userInfo {
    self.unionpayModel.encrptLegalName = userInfo.legalName;
    self.unionpayModel.encrptLegalIdcardNo = userInfo.legalIdcardNo;
    self.unionpayModel.encrptLegalMobile = userInfo.legalMobile;
    self.unionpayModel.encrptBankAcctNo = userInfo.bankAcctNo;
    self.unionpayModel.encrptBankPhone = userInfo.bankPhone;
    ///372新增
    self.unionpayModel.entryShareholderName = userInfo.shareholderName;
    self.unionpayModel.entryShareholderCertno = userInfo.shareholderCertno;
    self.unionpayModel.entryBnfName = userInfo.bnfName;
    self.unionpayModel.entryBnfCertno = userInfo.bnfCertno;

    self.unionpayModel = [JHUnionPayManager decrytUnionPayInfo:userInfo];
    
    self.idCardProsPic = [self getAliyunPicUrl:userInfo.cardProsPicUrl];
    self.idCardConsPic = [self getAliyunPicUrl:userInfo.cardConsPicUrl];
    self.idCardHandlePic = [self getAliyunPicUrl:userInfo.personCardPicUrl];
    self.bankCardProsPic = [self getAliyunPicUrl:userInfo.bankCardProsPicUrl];
    self.bankCardConsPic = [self getAliyunPicUrl:userInfo.bankCardConsPicUrl];
    self.accoLicensePic = [self getAliyunPicUrl:userInfo.licensePicUrl];
    self.proofMaterialPic = [self getAliyunPicUrl:userInfo.openAccountPicUrl];
}

#pragma mark -
#pragma mark - 加密用户敏感信息

- (void)encryptSignInfo {
    self.unionpayModel.encrptLegalName = [RSA encryptString:self.unionpayModel.legalName publicKey:kSignContractPublicKey];
    self.unionpayModel.encrptLegalIdcardNo = [RSA encryptString:self.unionpayModel.legalIdcardNo publicKey:kSignContractPublicKey];
    self.unionpayModel.encrptLegalMobile = [RSA encryptString:self.unionpayModel.legalMobile publicKey:kSignContractPublicKey];
    self.unionpayModel.encrptBankAcctNo = [RSA encryptString:self.unionpayModel.bankAcctNo publicKey:kSignContractPublicKey];
    ///372新增
    self.unionpayModel.entryShareholderName = [RSA encryptString:self.unionpayModel.shareholderName publicKey:kSignContractPublicKey];
    self.unionpayModel.entryShareholderCertno = [RSA encryptString:self.unionpayModel.shareholderCertno publicKey:kSignContractPublicKey];
    self.unionpayModel.entryBnfName = [RSA encryptString:self.unionpayModel.bnfName publicKey:kSignContractPublicKey];
    self.unionpayModel.entryBnfCertno = [RSA encryptString:self.unionpayModel.bnfCertno publicKey:kSignContractPublicKey];

    if ([self.unionpayModel.bankPhone isNotBlank]) {
        self.unionpayModel.encrptBankPhone = [RSA encryptString:self.unionpayModel.bankPhone publicKey:kSignContractPublicKey];
    }
}

#pragma mark - 解密用户敏感信息

+ (JHUnionPayModel *)decrytUnionPayInfo:(JHUnionPayModel *)model {
    if ([model.bankAcctNo isNotBlank] && ![model.bankAcctNo checkCardNo]) {
        model.bankAcctNo = [RSA decryptString:model.bankAcctNo publicKey:kSignContractPublicKey];
    }
    if ([model.legalMobile isNotBlank] && ![CommHelp isValidateMobile:model.legalMobile]) {
        model.legalMobile = [RSA decryptString:model.legalMobile publicKey:kSignContractPublicKey];
    }
    if ([model.bankPhone isNotBlank] && ![CommHelp isValidateMobile:model.bankPhone]) {
        model.bankPhone = [RSA decryptString:model.bankPhone publicKey:kSignContractPublicKey];
    }
    if ([model.legalName isNotBlank] && model.legalName.length > 10) {
        model.legalName = [RSA decryptString:model.legalName publicKey:kSignContractPublicKey];
    }
    if ([model.legalIdcardNo isNotBlank] && ![CommHelp judgeIdentityStringValid:model.legalIdcardNo]) {
        model.legalIdcardNo = [RSA decryptString:model.legalIdcardNo publicKey:kSignContractPublicKey];
    }
    ///372新增
//    if ([model.shareholderName isNotBlank] && ![CommHelp judgeIdentityStringValid:model.shareholderName]) {
//        model.shareholderName = [RSA decryptString:model.shareholderName publicKey:kSignContractPublicKey];
//    }
//    if ([model.shareholderCertno isNotBlank] && ![CommHelp judgeIdentityStringValid:model.shareholderCertno]) {
//        model.shareholderCertno = [RSA decryptString:model.shareholderCertno publicKey:kSignContractPublicKey];
//    }
//    if ([model.bnfName isNotBlank] && ![CommHelp judgeIdentityStringValid:model.bnfName]) {
//        model.bnfName = [RSA decryptString:model.bnfName publicKey:kSignContractPublicKey];
//    }
//    if ([model.bnfCertno isNotBlank] && ![CommHelp judgeIdentityStringValid:model.bnfCertno]) {
//        model.bnfCertno = [RSA decryptString:model.bnfCertno publicKey:kSignContractPublicKey];
//    }
    return model;
}

#pragma mark - 拼接字符串
- (NSString *)getAliyunPicUrl:(NSString *)url {
    if ([url containsString:kJHAiyunSignContractpath]) {
        ///如果包含阿里云图片域名 则获取域名后面的url
        NSArray *urlArray = [url componentsSeparatedByString:@"client_publish"];
        NSString *aliyunUrl = [NSString stringWithFormat:@"/client_publish%@",[urlArray lastObject]];
        return aliyunUrl;
    }
    else {
        return url;
    }
}

- (void)resetUserInfo {
    self.unionpayModel = nil;
    self.idCardProsPic = nil;
    self.idCardConsPic = nil;
    self.idCardHandlePic = nil;
    self.bankCardProsPic = nil;
    self.bankCardConsPic = nil;
    self.accoLicensePic = nil;
    self.proofMaterialPic = nil;
}

@end
