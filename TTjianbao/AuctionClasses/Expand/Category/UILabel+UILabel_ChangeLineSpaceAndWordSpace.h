//
//  UILabel+UILabel_ChangeLineSpaceAndWordSpace.h
//  TTjianbao
//
//  Created by jiangchao on 2019/1/17.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (UILabel_ChangeLineSpaceAndWordSpace)
/**
 *  改变行间距
 */
+ (void)changeLineSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变字间距
 */
+ (void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space;

/**
 *  改变行间距和字间距
 */
+ (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace;


@end

NS_ASSUME_NONNULL_END
