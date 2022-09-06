//
//  JHOrderConfirmShopTrolleyView.h
//  TTjianbao
//
//  Created by jiangchao on 2020/5/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHOrderSubBaseView.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHOrderConfirmShopTrolleyView : JHOrderSubBaseView
@property(strong,nonatomic)JHActionBlock buttonHandle;
@property (strong, nonatomic)  UILabel *goodCountLabel;
@end

NS_ASSUME_NONNULL_END
