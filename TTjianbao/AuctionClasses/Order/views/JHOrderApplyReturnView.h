//
//  JHOrderApplyReturnView.h
//  TTjianbao
//
//  Created by jiang on 2019/10/17.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMode.h"
#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@class JHOrderReturnMode;

@interface JHOrderApplyReturnView : BaseView
@property(strong,nonatomic) JHOrderReturnMode* orderReturnMode;
@property(strong,nonatomic) OrderMode* orderMode;
@property(strong,nonatomic) NSArray* reasonArr;
@property(strong,nonatomic) JHActionBlock completeBlock;
@end

NS_ASSUME_NONNULL_END
