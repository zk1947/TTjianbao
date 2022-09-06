//
//  JHCustomizeSendGoodsViewController.h
//  TTjianbao
//
//  Created by jiangchao on 2020/11/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseViewExtController.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeSendGoodsViewController : JHBaseViewExtController
@property(strong,nonatomic) NSString* orderId;
@property(assign,nonatomic) BOOL  isSeller;
@end

NS_ASSUME_NONNULL_END
