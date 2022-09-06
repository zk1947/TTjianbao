//
//  JHOrderDetailDelegate.h
//  TTjianbao
//
//  Created by jiangchao on 2020/10/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "JHCustomizeOrderModel.h"
@protocol JHOrderViewDelegate <NSObject>
@optional
-(void)buttonPress:(NSInteger)index;
-(void)buttonPress:(NSInteger)buttonIndex withOrder:(JHCustomizeOrderModel*)mode;
-(void)buttonPressStr:(NSString *)buttonText withOrder:(JHCustomizeOrderModel*)mode;
@end
