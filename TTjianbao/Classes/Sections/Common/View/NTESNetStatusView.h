//
//  NTESNetStatusView.h
//  TTjianbao
//
//  Created by chris on 2016/11/16.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <NIMAVChat/NIMAVChat.h>

#import "BaseView.h"

@interface NTESNetStatusView : BaseView

- (void)refresh:(NIMNetCallNetStatus)status;

@end
