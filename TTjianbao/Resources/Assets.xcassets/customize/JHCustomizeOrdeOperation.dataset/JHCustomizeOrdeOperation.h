//
//  JHCustomizeOrdeOperation.h
//  TTjianbao
//
//  Created by jiangchao on 2020/11/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHCustomizeOrderModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JHCustomizeOrdeOperation : NSObject
+(void)customizeOrderButtonAction:(JHCustomizeOrderModel*)model
  buttonType:(JHCustomizeOrderButtonType)type isSeller:(BOOL)seller  isFromOrderDetail:(BOOL)fromDetail;

@end

NS_ASSUME_NONNULL_END
