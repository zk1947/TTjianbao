//
//  JHC2CUploadProductSuccessController.h
//  TTjianbao
//
//  Created by jiangchao on 2021/6/10.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderMode.h"
#import "JHBaseViewExtController.h"
#import "JHOrderDetailMode.h"
#import "JHC2CPublishSuccessBackModel.h"


@interface JHC2CUploadProductSuccessController : JHBaseViewExtController
@property(strong,nonatomic) NSString* orderId;
@property(nonatomic, strong) JHC2CPublishSuccessBackModel * model;

/// 0 一口价  1 竞拍
@property(strong, nonatomic) NSString *productType;


/// 是否支持鉴定
@property(nonatomic) BOOL  canAuth;

@end
