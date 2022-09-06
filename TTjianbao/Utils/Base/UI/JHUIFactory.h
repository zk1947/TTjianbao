//
//  JHUIFactory.h
//  TTjianbao
//
//  Created by mac on 2019/11/24.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JHLine.h"
#import "JHTitleTextItemView.h"
#import "JHPreTitleLabel.h"
#import "JHTextField.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHUIFactory : NSObject
+ (UILabel *)createLabelWithTitle:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font textAlignment:(NSTextAlignment)alignment;
+ (UIButton *)createThemeBtnWithTitle:(NSString *)title cornerRadius:(CGFloat)cornerRadius target:(NSObject *)target action:(SEL)action;
+ (UIButton *)createThemeTwoBtnWithTitle:(NSString *)title cornerRadius:(CGFloat)cornerRadius target:(NSObject *)target action:(SEL)action;
+ (JHCustomLine *)createLine;
+ (JHTitleTextItemView *)createTitleTextWithTitle:(NSString *)title textPlace:(NSString *)placeHolder isEdit:(BOOL)isEdit isShowLine:(BOOL)isShowLine text:(NSString *)text;
+ (JHPreTitleLabel *)createJHLabelWithTitle:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font textAlignment:(NSTextAlignment)alignment preTitle:(NSString *)string;
+ (UIImageView *)createImageView;
+ (UIImageView *)createCircleImageViewWithRadius:(CGFloat)radius;
+ (JHTextField*)createJHTextField;

+ (CGFloat)getWidthWithString:(NSString *)string font:(UIFont *)font height:(CGFloat)height;
@end

NS_ASSUME_NONNULL_END
