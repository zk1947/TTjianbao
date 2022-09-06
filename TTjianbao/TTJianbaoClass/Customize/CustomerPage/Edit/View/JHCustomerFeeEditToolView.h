//
//  JHCustomerFeeEditToolView.h
//  TTjianbao
//
//  Created by wangjianios on 2020/9/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHCustomerFeeEditModel;

NS_ASSUME_NONNULL_BEGIN

@interface JHCustomerFeeEditToolView : UIView

@property (nonatomic, strong) JHCustomerFeeEditModel *model;

@property (nonatomic, copy) void (^callBalckBlock)(NSString *minPrice,NSString *maxPrice) ;

@end

NS_ASSUME_NONNULL_END
