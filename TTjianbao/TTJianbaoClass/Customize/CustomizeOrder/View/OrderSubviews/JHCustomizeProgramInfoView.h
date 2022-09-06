//
//  JHCustomizeProgramInfoView.h
//  TTjianbao
//
//  Created by jiangchao on 2020/10/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHOrderSubBaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeProgramInfoView : UIView
@property(strong,nonatomic)JHCustomizeOrderPlanModel * planMode;
@property(strong,nonatomic)JHCustomizeOrderModel * orderMode;//跳转页面传参用
-(void)initCustomizeProgramInfoViews;
@end

NS_ASSUME_NONNULL_END
