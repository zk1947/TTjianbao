//
//  JHOrderOperation.h
//  TTjianbao
//
//  Created by jiangchao on 2021/1/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHCustomizeOrderModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHOrderOperation : NSObject
+(void)customizeOrderButtonAction:(JHCustomizeOrderModel*)model
  buttonType:(JHCustomizeOrderButtonType)type isSeller:(BOOL)seller  isFromOrderDetail:(BOOL)fromDetail;
@end

NS_ASSUME_NONNULL_END
