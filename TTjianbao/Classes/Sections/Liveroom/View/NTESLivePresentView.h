//
//  NTESLivePresentView.h
//  TTjianbao
//
//  Created by chris on 16/3/30.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIMSDK/NIMSDK.h"

@class NTESPresent;

#import "BaseView.h"

@interface NTESLivePresentView : BaseView

- (void)addPresentMessage:(NIMMessage *)message;

@end
