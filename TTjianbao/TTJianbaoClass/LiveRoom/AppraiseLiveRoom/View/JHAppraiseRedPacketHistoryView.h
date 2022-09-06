//
//  JHAppraiseRedPacketHistoryView.h
//  TTjianbao
//  Descrription:鉴定师红包记录（发送红包）
//  Created by Jesse on 2020/7/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHAppraiseRedPacketModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHAppraiseRedPacketHistoryView : UIView

- (void)showWithAppraiserId:(NSString*)appraiserId channelId:(NSString*)channelId;
@end

NS_ASSUME_NONNULL_END
