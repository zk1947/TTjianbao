//
//  JHRefunfOrderModel.h
//  TTjianbao
//
//  Created by liuhai on 2021/9/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHRefunfOrderModel : NSObject
@property (nonatomic, copy)NSString *amount;
@property (nonatomic, copy)NSString *orderId;
@property (nonatomic, copy)NSString * refundTag;
@property (nonatomic, assign)BOOL flag;
@end

NS_ASSUME_NONNULL_END
