//
//  JHSendLivingTipManeger.h
//  TTjianbao
//
//  Created by apple on 2021/2/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHSendLivingTipManeger : NSObject
+ (instancetype)shareManager;
- (void)sendLivingTipManeger:(UIView *)sView andChannelLocalId:(NSString *)channelLocalId;
@end

NS_ASSUME_NONNULL_END
