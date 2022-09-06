//
//  JHAddCouponModel.h
//  TTjianbao
//
//  Created by mac on 2019/8/12.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHAddCouponModel : NSObject
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *placeHolder;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, assign) NSInteger valueToRight;
@property (nonatomic, assign) NSInteger showRightArrow;
@property (nonatomic, assign) NSInteger textDisable;

@property (nonatomic, assign) UIKeyboardType keyBoardType;



@end

NS_ASSUME_NONNULL_END
