//
//  JHUIFactory.m
//  TTjianbao
//
//  Created by mac on 2019/11/24.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHUIFactory.h"

@implementation JHUIFactory
+ (UILabel *)createLabelWithTitle:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font textAlignment:(NSTextAlignment)alignment {
    UILabel *label = [UILabel new];
    label.font = font;
    label.textColor = color;
    label.textAlignment = alignment;
    label.text = title;
    return label;
}

+ (UIButton *)createThemeBtnWithTitle:(NSString *)title cornerRadius:(CGFloat)cornerRadius target:(NSObject *)target action:(SEL)action {
    UIButton *_okBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_okBtn setTitle:title forState:UIControlStateNormal];
    _okBtn.titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
    [_okBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    _okBtn.backgroundColor = kGlobalThemeColor;
    _okBtn.layer.cornerRadius = cornerRadius;
    _okBtn.layer.masksToBounds = YES;
    [_okBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return _okBtn;
}

+ (UIButton *)createThemeTwoBtnWithTitle:(NSString *)title cornerRadius:(CGFloat)cornerRadius target:(NSObject *)target action:(SEL)action {
    UIButton *_cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setTitle:title forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
    [_cancelBtn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    _cancelBtn.layer.borderColor = kGlobalThemeColor.CGColor;
    _cancelBtn.layer.borderWidth = 1;
    _cancelBtn.layer.cornerRadius = cornerRadius;
    _cancelBtn.layer.masksToBounds = YES;
    [_cancelBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    _cancelBtn.backgroundColor = [UIColor clearColor];
    return _cancelBtn;
}

+ (JHCustomLine *)createLine {
    return [[JHCustomLine alloc] init];
}

+ (JHTextField*)createJHTextField{
    return [[JHTextField alloc] init];
}

+ (JHTitleTextItemView *)createTitleTextWithTitle:(NSString *)title textPlace:(NSString *)placeHolder isEdit:(BOOL)isEdit isShowLine:(BOOL)isShowLine text:(NSString *)text {
    JHTitleTextItemView *item = [[JHTitleTextItemView alloc] initWithTitle:title textPlace:placeHolder isEdit:isEdit isShowLine:isShowLine];
    item.textField.text = text;
    return item;
}

+ (JHPreTitleLabel *)createJHLabelWithTitle:(NSString *)title titleColor:(UIColor *)color font:(UIFont *)font textAlignment:(NSTextAlignment)alignment preTitle:(NSString *)string {
    JHPreTitleLabel *label = [JHPreTitleLabel new];
    label.font = font;
    label.textColor = color;
    label.textAlignment = alignment;
    label.preTitle = string;
    label.text = title;
    return label;
}

+ (UIImageView *)createImageView {
    UIImageView *image = [UIImageView new];
    image.contentMode = UIViewContentModeScaleAspectFill;
    image.layer.cornerRadius = 4;
    image.layer.masksToBounds = YES;
    return image;
}

+ (UIImageView *)createCircleImageViewWithRadius:(CGFloat)radius {
    UIImageView *image = [UIImageView new];
    image.contentMode = UIViewContentModeScaleAspectFill;
    image.layer.cornerRadius = radius;
    image.layer.masksToBounds = YES;
    return image;
}

+ (CGFloat)getWidthWithString:(NSString *)string font:(UIFont *)font height:(CGFloat)height {
    NSDictionary *attribute = @{NSFontAttributeName: font};
    CGSize size = [string boundingRectWithSize:CGSizeMake(MAXFLOAT,height) options: NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading  attributes:attribute context:nil].size;
    
   return size.width;
}
@end
