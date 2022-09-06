//
//  UITextView+PlaceHolder.h
//  TTjianbao
//
//  Created by user on 2020/10/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (PlaceHolder)
@property (nonatomic, readonly) UILabel            *placeholderLabel;
@property (nonatomic,   strong) NSString           *placeholder;
@property (nonatomic,   strong) NSAttributedString *attributedPlaceholder;
@property (nonatomic,   strong) UIColor            *placeholderColor;

+ (UIColor *)defaultPlaceholderColor;

@end

NS_ASSUME_NONNULL_END
