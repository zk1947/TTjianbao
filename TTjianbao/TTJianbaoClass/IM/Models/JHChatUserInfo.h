//
//  JHChatUserInfo.h
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/22.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHChatUserInfo : NSObject
/// 用户ID
@property(nonatomic, copy) NSString *userId;
/// 用户ID
@property(nonatomic, copy) NSString *customerId;
/// 用户名
@property(nonatomic, copy) NSString *userName;
/// 用户昵称
@property(nonatomic, copy) NSString *nickName;
/// 用户头像
@property(nonatomic, copy) NSString *vatarUrl;
/// 用户类型-0普通用户，1鉴定主播，2直播卖货主播，3:助理 4:社区商户，5:机器人马甲6:社区商户+直播卖货主播 7:回血商家，8回血助理，9定制师，10定制师助理, 12回收直播助理, 13 图文鉴定师'
@property(nonatomic, assign) NSUInteger customerType;
@end

NS_ASSUME_NONNULL_END
