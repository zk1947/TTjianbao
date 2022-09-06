//
//  JHPayView.h
//  TTjianbao
//
//  Created by jiang on 2020/1/9.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMode.h"
#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@class PayWayMode;
@protocol JHPayViewDelegate <NSObject>
@optional
-(void)Complete:(PayWayMode*)mode andPayMoney:(double)money;
@end

@interface JHPayView : BaseView
@property(strong,nonatomic) NSString* price;
@property(weak,nonatomic)id<JHPayViewDelegate>delegate;
@property(strong,nonatomic) NSArray* payWayArray;
@end

NS_ASSUME_NONNULL_END
