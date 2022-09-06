//
//  LiveRedPacketView.h
//  TTjianbao
//
//  Created by jiangchao on 2019/3/4.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@class CoponPackageMode;

@interface LiveRedPacketView : BaseView
@property (nonatomic, copy) JHActionBlock buttonClick;
@property (nonatomic, copy) CoponPackageMode *mode;
- (void)showAnimation;
@end

NS_ASSUME_NONNULL_END
