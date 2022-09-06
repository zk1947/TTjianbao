//
//  JHOrderConfirmProcessPayView.h
//  TTjianbao
//
//  Created by jiangchao on 2021/1/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHOrderSubBaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHOrderConfirmProcessPayView : JHOrderSubBaseView
@property (strong, nonatomic)  UILabel *deductionFinishPrice;
-(void)initSubViews;
@end

NS_ASSUME_NONNULL_END
