//
//  JHUserAuthModel.h
//  TTjianbao
//
//  Created by lihui on 2021/3/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, JHUserAuthType) {
    /**未认证*/
    JHUserAuthTypeUnAuth = 0,
    /**个体户*/
    JHUserAuthTypePersonal = 1,
    /**普通企业*/
    JHUserAuthTypeCommonBunsiness,
    /**个体工商户*/
    JHUserAuthTypeIndividualBunsiness
};

typedef NS_ENUM(NSInteger, JHUserAuthState) {
    /**未认证*/
    JHUserAuthStateUnCommit = -1,
    /**审核中*/
    JHUserAuthStateChecking = 0,
    /**通过*/
    JHUserAuthStatePassed,
    /**未通过*/
    JHUserAuthStateUnPassed,
};


NS_ASSUME_NONNULL_BEGIN

@interface JHUserAuthModel : NSObject
/***/
@property (nonatomic, copy) NSString *Id;
/**认证类型*/
@property (nonatomic, assign) JHUserAuthType authType;
/**身份证正面照*/
@property (nonatomic, copy) NSString *idCardFrontImg;
/**身份证反面照*/
@property (nonatomic, copy) NSString *idCardBackImg;
/**营业执照*/
@property (nonatomic, copy) NSString *businessLicense;
/**其他执照*/
@property (nonatomic, copy) NSArray <NSString *>*otherLicense;
/**审核状态*/
@property (nonatomic, assign) JHUserAuthState authState;
@property (nonatomic, copy) NSString *rejectReason;

+ (void)requestUserAuthInfo:(HTTPCompleteBlock)block;

/// Description   lihui
/// @param block 网络请求回调
+ (void)commitAuthInfoToServe:(JHUserAuthModel *)authModel
                completeBlock:(HTTPCompleteBlock)block;

/// Description 重新提交认证信息
/// @param block 网络请求回调
+ (void)reCommitAuthInfoToServe:(JHUserAuthModel *)authModel
                completeBlock:(HTTPCompleteBlock)block;

@end

NS_ASSUME_NONNULL_END
