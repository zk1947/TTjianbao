//
//  JHPushDataModel.h
//  TTjianbao
//  Description:Push相关请求
//  Created by jesee on 27/4/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHReqModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHPushDataModel : NSObject

//上报push到达
+ (void)report:(NSString*)pushIds;
//上报push点击
+ (void)requestPushClicked:(NSString*)pushId;
//保存deviceToken
+ (void)saveUserDeviceToken:(NSData *)deviceToken;
@end

/*
*上报push到达 pushIds 逗号隔开
 */
@interface JHPushReportModel : JHReqModel

@property (nonatomic, copy) NSString *pushIds;
@property (nonatomic, copy) NSString *deviceToken;
@end

/*
*上报push点击
 */
@interface JHPushClickModel : JHReqModel

@property (nonatomic, copy) NSString *pushId;
@property (nonatomic, copy) NSString *deviceToken;
@end

NS_ASSUME_NONNULL_END
