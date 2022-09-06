//
//  JHExpressHeaderView.h
//  TTjianbao
//
//  Created by jiangchao on 2019/1/28.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpressMode.h"
#import "BaseView.h"
#import "JHOrderExpressViewMode.h"
@interface JHExpressHeaderView : BaseView
@property (nonatomic, strong)ExpressVo *model;
@property (nonatomic, assign)  JHExpressStepType  expressStep;
@end

