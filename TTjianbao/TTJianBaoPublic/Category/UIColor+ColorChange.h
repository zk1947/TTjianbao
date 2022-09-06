//
//  UIColor+ColorChange.h
//  TTjianbao
//
//  Created by YJ on 2020/12/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define COLOR_CHANGE(string)             [UIColor colorWithHexString:string]

@interface UIColor (ColorChange)

+ (UIColor *) colorWithHexString: (NSString *)color;
+ (UIColor *) colorWithHexString: (NSString *)color alpha : (CGFloat) alpha;
@end

NS_ASSUME_NONNULL_END
