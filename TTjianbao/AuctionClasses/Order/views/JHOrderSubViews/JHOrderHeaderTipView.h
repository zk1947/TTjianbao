//
//  JHOrderTipView.h
//  TTjianbao
//
//  Created by jiangchao on 2020/7/8.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHOrderSubBaseView.h"
@interface JHOrderHeaderTipView : JHOrderSubBaseView
-(void)initContent:(NSString *)title andDesc:(NSString*)desc;
-(void)initContentWithPrice:(NSString *)price;
@end

