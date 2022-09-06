//
//  JHEnvVariableDefine.h
//  TTjianbao
//
//  Created by apple on 2019/6/29.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JHServiceType) {
    /**生产环境*/
    JHServiceTypeRelease = 0,
    /**开发环境*/
    JHServiceTypeDevelop,
    /**测试环境A*/
    JHServiceTypeTestA,
    /**测试环境B*/
    JHServiceTypeTestB,
    /**测试环境C*/
    JHServiceTypeTestC,
    /**预生产环境*/
    JHServiceTypePreRelease
};

@interface JHEnvVariableDefine : NSObject

@property (nonatomic, class, copy, readonly) NSString* fileBaseString;
@property (nonatomic, class, copy, readonly) NSString* communityFileBaseString;
@property (nonatomic, class, copy, readonly) NSString* imAppKey;
@property (nonatomic, class, copy, readonly) NSString* BurySever;
@property (nonatomic, class, assign, readonly) JHServiceType serviceType;
@property (nonatomic, class, copy, readonly) NSString *h5BaseUrl;
@property (nonatomic, class, copy, readonly) NSString *h5BaseHttpUrl;
@property (nonatomic, class, copy, readonly) NSString* devDebugString;
///阿里云图片地址
@property (nonatomic, class, copy, readonly) NSString *aliyuncsBaseUrl;
///阿里云视频域名
@property (nonatomic, class, copy, readonly) NSString *aliyuncsVideoBaseUrl;
//神策url
@property (nonatomic, class, copy, readonly) NSString *sa_server_url;
//神策ab test
@property (nonatomic, class, copy, readonly) NSString *sa_abTest_url;
@property (nonatomic, class, copy, readonly) NSString *universalLink;
@property (nonatomic, class, copy, readonly) NSString *alyunImageBucketName;
@property (nonatomic, class, copy, readonly) NSString *alyunVideoBucketName;
@property (nonatomic, class, copy, readonly) NSString *alyunVoiceBucketName;
+ (JHServiceType)getService;

+ (void)showSwitchAlert;
@end

NS_ASSUME_NONNULL_END
