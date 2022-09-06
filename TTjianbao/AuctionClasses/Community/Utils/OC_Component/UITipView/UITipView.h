//
//  UITipView.h
//  DYSport
//
//  Created by Wujg on 16/5/6.
//  Copyright © 2016年 Wujg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITipView : UIView

+ (void)showTipStr:(NSString *)tipStr;

- (id)initWithText:(NSString *)text;

@end
