//
//  JHOfferPriceViewController.h
//  TTjianbao
//
//  Created by jiang on 2019/12/3.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHOfferPriceViewController : JHBaseViewController
@property (nonatomic, strong) NSString *stoneRestoreId;
@property (nonatomic, assign) BOOL resaleFlag;//是否是个人转售
@end

NS_ASSUME_NONNULL_END
