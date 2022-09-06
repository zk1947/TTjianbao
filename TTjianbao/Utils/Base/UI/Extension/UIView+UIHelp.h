// 常用UI控件便利构造器
// 更新于 2020-12-31
// UIView UIImageView UIButton UILabel UIScrollView UITableView UITextField

#import <UIKit/UIKit.h>
#import "TTjianbaoMarcoUI.h"
#import "UIView+Toast.h"

#define JHTOAST(STRING) [JHKeyWindow makeToast:[NSString stringWithFormat:@"%@",STRING] duration:2 position:CSToastPositionCenter]

NS_ASSUME_NONNULL_BEGIN

@interface UIView (UIHelp)

- (void)jh_cornerRadius:(CGFloat)radius;

- (void)jh_cornerRadius:(CGFloat)radius shadowColor:(UIColor *)shadowColor;

- (void)jh_borderWithColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

- (void)jh_cornerRadius:(CGFloat)radius
            borderColor:(UIColor *)borderColor
            borderWidth:(CGFloat)borderWidth;

- (void)jh_cornerRadius:(CGFloat)radius
             rectCorner:(UIRectCorner)rectCorner
                 bounds:(CGRect)bounds;

+ (instancetype)jh_viewWithColor:(UIColor *)color
             addToSuperview:(UIView *)superview;

@end

@interface UIImageView (UIHelp)

/// UIViewContentModeScaleAspectFill
+ (instancetype)jh_imageViewAddToSuperview:(UIView *)superview;

+ (instancetype)jh_imageViewWithContentModel:(UIViewContentMode)contentMode addToSuperview:(UIView *)superview;

+ (instancetype)jh_imageViewWithImage:(id)image addToSuperview:(UIView *)superview;

+ (instancetype)jh_imageViewWithImage:(id)image contentModel:(UIViewContentMode)contentMode addToSuperview:(UIView *)superview;

- (void)jh_setImageWithUrl:(NSString *)url placeHolder:(NSString *)placeholder;

- (void)jh_setImageWithUrl:(NSString *)url;

- (void)jh_setAvatorWithUrl:(NSString *)url;

@end

@interface UIButton (UIHelp)

- (UIButton * (^)(NSString *title))jh_title;

- (UIButton * (^)(UIColor *color))jh_titleColor;

- (UIButton * (^)(UIFont *font))jh_font;

- (UIButton * (^)(int font))jh_boldFontNum;

- (UIButton * (^)(int font))jh_fontNum;

- (UIButton * (^)(UIColor *color))jh_backgroundColor;

- (UIButton * (^)(NSString *name))jh_imageName;

- (UIButton * (^)(id object, SEL action))jh_action;

+ (instancetype)jh_buttonWithTitle:(NSString *)title
                        fontSize:(NSInteger)fontsize
                       textColor:(UIColor *)textcolor
                          target:(id)target action:(SEL)action
                  addToSuperView:(UIView *)superview;

+ (instancetype)jh_buttonWithBackgroundimage:(id)image
                                    target:(id)target
                                    action:(SEL)action
                            addToSuperView:(UIView *)superview;

+ (instancetype)jh_buttonWithImage:(id)image
                          target:(id)target
                          action:(SEL)action
                  addToSuperView:(UIView *)superview;

+ (instancetype)jh_buttonWithTarget:(id)target
                            action:(SEL)action
                    addToSuperView:(UIView *)superview;

- (void)jh_setImageWithUrl:(NSString *)url;

- (void)jh_setImageWithUrl:(NSString *)url placeholderImage:(NSString *)placeholderImage;

- (void)jh_setAvatorWithUrl:(NSString *)url;

@end


@interface UILabel (UIHelp)

- (UILabel * (^)(UIFont *font))jh_font;

- (UILabel * (^)(NSString *text))jh_text;

- (UILabel * (^)(NSTextAlignment textAlignment))jh_textAlignment;

- (UILabel * (^)(UIColor *color))jh_textColor;

- (UILabel * (^)(UIColor *color))jh_backgroundColor;

- (UILabel * (^)(NSInteger num))jh_numberOfLines;

- (UILabel * (^)(NSLineBreakMode lineBreak))jh_lineBreakMode;

+ (instancetype)jh_labelWithText:(NSString *)string
                         font:(NSInteger)font
                    textColor:(UIColor *)color
                textAlignment:(NSTextAlignment)textAlignment
               addToSuperView:(UIView *)superview;

+ (instancetype)jh_labelWithBoldText:(NSString *)string
                             font:(NSInteger)font
                        textColor:(UIColor *)color
                    textAlignment:(NSTextAlignment)textAlignment
                   addToSuperView:(UIView *)superview;

/**
    带textAlignment
 */
+ (instancetype)jh_labelWithFont:(NSInteger)font
                    textColor:(UIColor *)color
                textAlignment:(NSTextAlignment)textAlignment
               addToSuperView:(UIView *)superview;

/**
 默认textAlignmentLeft
 */

+ (instancetype)jh_labelWithFont:(NSInteger)font
                    textColor:(UIColor *)color
               addToSuperView:(UIView *)superview;

+ (instancetype)jh_labelWithBoldFont:(NSInteger)boldFont
                        textColor:(UIColor *)color
                   addToSuperView:(UIView *)superview;

+ (instancetype)jh_labelWithBoldFont:(NSInteger)boldFont
                        textColor:(UIColor *)color
                    textAlignment:(NSTextAlignment)textAlignment
                   addToSuperView:(UIView *)superview;

@end

@interface UIScrollView (UIHelp)

+ (instancetype)jh_scrollViewWithContentSize:(CGSize)contentsize
                      showsScrollIndicator:(BOOL)showsScrollIndicator
                              scrollsToTop:(BOOL)scrollsToTop
                                   bounces:(BOOL)bounces
                             pagingEnabled:(BOOL)pagingEnabled
                            addToSuperView:(nullable UIView *)superview;

@end


@interface UITableView (UIHelp)

+(instancetype)jh_tableViewWithStyle:(UITableViewStyle)tableViewStyle
                    separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle
                            target:(id)target
                    addToSuperView:(UIView *)superview;

@end


@interface UITextField (UIHelp)
+ (instancetype)jh_textFieldWithFont:(NSInteger)font textAlignment:(NSTextAlignment)textAlignment textColor:(UIColor *)textColor placeholderText:(NSString *)placeholderText placeholderColor:(UIColor *)placeholderColor addToSupView:(UIView *)superView;

+(instancetype)jh_textFieldWithFont:(NSInteger)font textAlignment:(NSTextAlignment)textAlignment textColor:(UIColor *)textColor addToSupView:(UIView *)superView;

@end


@interface UIView (Gesture)

@property (nonatomic, copy) dispatch_block_t jh_tapGesture;

- (void)jh_addTapGesture:(dispatch_block_t)block;

@end

NS_ASSUME_NONNULL_END
