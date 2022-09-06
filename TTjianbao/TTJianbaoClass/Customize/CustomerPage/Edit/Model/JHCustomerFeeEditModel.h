//
//  JHCustomerFeeEditModel.h
//  TTjianbao
//
//  Created by wangjianios on 2020/9/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomerFeeEditModel : NSObject

@property (nonatomic, copy) NSString *ID;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, assign) NSInteger maxPrice;

@property (nonatomic, assign) NSInteger minPrice;

@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
