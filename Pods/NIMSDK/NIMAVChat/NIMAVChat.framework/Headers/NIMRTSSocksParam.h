//
//  NIMRTSSocksParam.h
//  NIMAVChat
//
//  Created by He on 2018/10/17.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NIMAVChatDefs.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * 互动白板代理设置参数
 */
@interface NIMRTSSocksParam : NSObject <NSCopying>
/**
 *  是否使用全局socks5代理, 默认为 NO
 */
@property (nonatomic, assign) BOOL enableProxy;

/**
 *  代理类型，默认 NIMSocksTypeDefault
 */
@property (nonatomic, assign) NIMSocksType socksType;

/**
 *  Socks服务器地址, 格式：ip:port
 *  @discussion 代理无认证格式：socks5://ip:port; 代理有认证格式：socks5://username:password@ip:port
 */
@property (nonatomic, copy) NSString *socksAddr;

/**
 *  Socks服务请求用户名
 */
@property (nullable, nonatomic, copy) NSString *socksUsername;

/**
 *  Socks服务请求密码
 */
@property (nullable, nonatomic, copy) NSString *socksPassword;

@end

NS_ASSUME_NONNULL_END
