//
//  JHCustomerAddCommentBusiness.h
//  TTjianbao
//
//  Created by user on 2020/11/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHCustomerAddCommentModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomerAddCommentBusiness : NSObject
+ (void)publishComment:(JHCustomerAddCommentModel *)model
         completeBlock:(HTTPCompleteBlock)block;
@end

NS_ASSUME_NONNULL_END
