//
//  JHAppraiseRedPacketView.h
//  TTjianbao
//  Descrription:鉴定师红包view(开)
//  Created by Jesse on 2020/7/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHAppraiseRedPacketModel.h"

NS_ASSUME_NONNULL_BEGIN
//4004消息来了,观众端才显示
@interface JHAppraiseRedPacketView : UIView

- (void)showAppraiserData:(JHAppraiseRedPacketListModel*)model action:(JHActionBlock)action;
+ (void)dismissAllAppraiserRedPackeView;
@end

NS_ASSUME_NONNULL_END
