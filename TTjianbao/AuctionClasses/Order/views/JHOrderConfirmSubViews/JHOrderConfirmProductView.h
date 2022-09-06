//
//  JHOrderConfirmProductView.h
//  TTjianbao
//
//  Created by jiangchao on 2020/5/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHOrderSubBaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHOrderConfirmProductView : JHOrderSubBaseView
@property(strong,nonatomic)JHOrderDetailMode * orderMode;
-(void)ConfigCategoryTagTitle:(JHOrderDetailMode*)mode;
@end

NS_ASSUME_NONNULL_END
