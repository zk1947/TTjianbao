//
//  JHSizeCalculationHelper.h
//  TTjianbao
//
//  Created by user on 2021/2/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHSizeCalculationHelper : NSObject
+ (CGSize)calculationTextWidthWith:(NSString *)string font:(UIFont *)font;
@end

NS_ASSUME_NONNULL_END
