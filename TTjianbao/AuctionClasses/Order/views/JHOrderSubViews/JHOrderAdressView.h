//
//  JHOrderAdressView.h
//  TTjianbao
//
//  Created by jiang on 2020/5/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHOrderSubBaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHOrderAdressView : JHOrderSubBaseView
@property(strong,nonatomic)JHOrderDetailMode * orderMode;
@property(strong,nonatomic)JHCustomizeOrderModel *customizeOrderMode;
@end

NS_ASSUME_NONNULL_END
