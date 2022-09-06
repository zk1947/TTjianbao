//
//  JHSellerSendOrderViewController.h
//  TTjianbao
//
//  Created by jiang on 2019/9/10.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseViewExtController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHSellerSendOrderViewController : JHBaseViewExtController
@property(assign,nonatomic) BOOL  isSeller;
@property (nonatomic, copy) NSString *expressNumber;

@property (nonatomic, copy) NSString *expressName;

@end

NS_ASSUME_NONNULL_END
