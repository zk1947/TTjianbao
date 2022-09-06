//
//  JHOrdePayGradationView.h
//  TTjianbao
//
//  Created by jiangchao on 2019/2/27.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMode.h"

@class PayWayMode;
@protocol JHOrdePayGradationViewDelegate <NSObject>
-(void)Complete:(PayWayMode*)mode andPayMoney:(double)money;
@optional

@end
#import "BaseView.h"

@interface JHOrdePayGradationView : BaseView
@property(strong,nonatomic) OrderMode* orderMode;
@property(weak,nonatomic)id<JHOrdePayGradationViewDelegate>delegate;
@property(strong,nonatomic) NSArray* payWayArray;
@end


