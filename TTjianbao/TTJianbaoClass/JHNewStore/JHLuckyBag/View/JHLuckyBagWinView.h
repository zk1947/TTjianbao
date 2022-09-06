//
//  JHLuckyBagWinView.h
//  TTjianbao
//
//  Created by zk on 2021/11/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMode.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHLuckyBagWinView : UIView

@property (nonatomic, copy) void(^payBlock)(OrderMode *model);

-(void)show:(OrderMode *)model;

- (void)remove;

@end

NS_ASSUME_NONNULL_END
