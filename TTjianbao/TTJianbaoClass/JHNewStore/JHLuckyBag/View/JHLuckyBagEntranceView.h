//
//  JHLuckyBagEntranceView.h
//  TTjianbao
//
//  Created by zk on 2021/11/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHMyCompeteCountdownView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHLuckyBagEntranceView : UIControl

@property (nonatomic, copy) void(^touchEventBlock)(void);

@property (nonatomic, strong) JHMyCompeteCountdownView *countdownView; /// 倒计时视图

- (void)show:(int)downSecand;

- (void)remove;

@end

NS_ASSUME_NONNULL_END
