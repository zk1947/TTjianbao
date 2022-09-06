//
//  JHCustomerCerEditViewController.h
//  TTjianbao
//
//  Created by user on 2020/10/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomerCerEditViewController : JHBaseViewController
///保存成功
@property (nonatomic, copy) dispatch_block_t callbackMethod;
@end

NS_ASSUME_NONNULL_END
