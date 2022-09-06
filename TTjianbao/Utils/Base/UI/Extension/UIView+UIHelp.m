
#import "UIView+UIHelp.h"
#import "UIImageView+JHWebImage.h"
#import "UIButton+JHWebImage.h"

@implementation UIView (UIHelp)

- (void)jh_cornerRadius:(CGFloat)radius {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius  = radius;
}

- (void)jh_borderWithColor:(UIColor*)borderColor
               borderWidth:(CGFloat)borderWidth {
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
}

- (void)jh_cornerRadius:(CGFloat)radius
            borderColor:(UIColor*)borderColor
            borderWidth:(CGFloat)borderWidth {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius  = radius;
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
}

- (void)jh_cornerRadius:(CGFloat)radius rectCorner:(UIRectCorner)rectCorner bounds:(CGRect)bounds
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:bounds byRoundingCorners:rectCorner cornerRadii:CGSizeMake(radius,radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)jh_cornerRadius:(CGFloat)radius
            shadowColor:(UIColor *)shadowColor
{
    self.layer.cornerRadius  = radius;
    self.layer.shadowColor   = shadowColor.CGColor;
    self.layer.shadowOffset  = CGSizeMake(0, 1);
    self.layer.shadowOpacity = 0.3;
    self.layer.shadowRadius  = 8;
}

+ (instancetype)jh_viewWithColor:(UIColor *)color addToSuperview:(UIView *)superview
{
    UIView* view = [[self alloc]init];
    view.backgroundColor = color;
    if (superview) {
        [superview addSubview:view];
    }
    return view;
}

@end

@implementation UIImageView (UIHelp)

+ (instancetype)jh_imageViewAddToSuperview:(UIView *)superview
{
    UIImageView *imageView = [self jh_imageViewWithContentModel:UIViewContentModeScaleAspectFill addToSuperview:superview];
    return imageView;
}

+ (instancetype)jh_imageViewWithContentModel:(UIViewContentMode)contentMode addToSuperview:(UIView *)superview
{
    UIImageView *imageView = [self new];
    [superview addSubview:imageView];
    imageView.contentMode = contentMode;
    imageView.layer.masksToBounds = YES;
    return imageView;
}

+ (instancetype)jh_imageViewWithImage:(id)image addToSuperview:(UIView *)superview
{
    return [self jh_imageViewWithImage:image contentModel:UIViewContentModeCenter addToSuperview:superview];
}

+ (instancetype)jh_imageViewWithImage:(id)image contentModel:(UIViewContentMode)contentMode addToSuperview:(UIView *)superview
{
    UIImageView *imageView = [self new];
    [superview addSubview:imageView];
    UIImage *image0;
    if ([image isKindOfClass:[NSString class]]) {
        image0 = [UIImage imageNamed:image];
    }
    else
    {
        image0 = image;
    }
    imageView.image = image0;
    return imageView;
}

- (void)jh_setImageWithUrl:(NSString *)url placeHolder:(NSString *)placeholder
{
    url = [NSString stringWithFormat:@"%@",url];
    [self jhSetImageWithURL:[NSURL URLWithString:url] placeholder:[UIImage imageNamed:placeholder]];
}

- (void)jh_setImageWithUrl:(NSString *)url
{
    url = [NSString stringWithFormat:@"%@",url];
    [self jhSetImageWithURL:[NSURL URLWithString:url] placeholder:kDefaultCoverImage];
}

- (void)jh_setAvatorWithUrl:(NSString *)url
{
    url = [NSString stringWithFormat:@"%@",url];
    [self jhSetImageWithURL:[NSURL URLWithString:url] placeholder:kDefaultAvatarImage];
}

@end

@implementation UIButton (UIHelp)

- (UIButton * (^)(NSString *title))jh_title {
    return ^(NSString *title) {
        [self setTitle:title forState:UIControlStateNormal];
        return self;
    };
}

- (UIButton * (^)(UIColor *color))jh_titleColor {
    return ^(UIColor *color) {
        [self setTitleColor:color forState:UIControlStateNormal];
        return self;
    };
}

- (UIButton * (^)(UIFont *font))jh_font {
    return ^(UIFont *font) {
        self.titleLabel.font = font;
        return self;
    };
}

- (UIButton * (^)(int font))jh_boldFontNum {
    return ^(int font) {
        self.titleLabel.font = [UIFont boldSystemFontOfSize:font];
        return self;
    };
}

- (UIButton * (^)(int font))jh_fontNum {
    return ^(int font) {
        self.titleLabel.font = [UIFont systemFontOfSize:font];
        return self;
    };
}

- (UIButton * (^)(UIColor *color))jh_backgroundColor {
    return ^(UIColor *color) {
        self.backgroundColor = color;
        return self;
    };
}

- (UIButton * (^)(NSString *name))jh_imageName {
    return ^(NSString *name) {
        [self setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        return self;
    };
}

- (UIButton * (^)(id object, SEL action))jh_action {
    return ^(id object, SEL action) {
        [self addTarget:object action:action forControlEvents:UIControlEventTouchUpInside];
        return self;
    };
}

+ (instancetype)jh_buttonWithTitle:(NSString *)title
                     fontSize:(NSInteger)fontsize
                    textColor:(UIColor*)textcolor
                       target:(id)target action:(SEL)action
               addToSuperView:(UIView *)superview
{
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:fontsize];
    [button setTitleColor:textcolor forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [superview addSubview:button];
    
    return button;
}

+ (instancetype)jh_buttonWithBackgroundimage:(id)image
                                target:(id)target
                                action:(SEL)action
                        addToSuperView:(UIView *)superview
{
    UIImage *image0;
    if ([image isKindOfClass:[NSString class]]) {
        image0 = [UIImage imageNamed:image];
    }
    else
    {
        image0 = image;
    }
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:image0 forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [superview addSubview:button];
    return button;
}

+ (instancetype)jh_buttonWithImage:(id)image
                      target:(id)target
                      action:(SEL)action
              addToSuperView:(UIView *)superview
{
    UIImage *image0;
    if ([image isKindOfClass:[NSString class]]) {
        image0 = [UIImage imageNamed:image];
    }
    else
    {
        image0 = image;
    }
    
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    [button setImage:image0 forState:UIControlStateNormal];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [superview addSubview:button];
    return button;
}

+ (instancetype)jh_buttonWithTarget:(id)target
                        action:(SEL)action
                addToSuperView:(UIView *)superview
{
    UIButton *button = [self buttonWithType:UIButtonTypeCustom];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [superview addSubview:button];
    return button;
}

- (void)jh_setImageWithUrl:(NSString *)url
{
    url = [NSString stringWithFormat:@"%@",url];
    [self jhSetImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholder:kDefaultCoverImage];
}

- (void)jh_setImageWithUrl:(NSString *)url placeholderImage:(NSString *)placeholderImage
{
    url = [NSString stringWithFormat:@"%@",url];
    [self jhSetImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholder:[UIImage imageNamed:placeholderImage]];
}

- (void)jh_setAvatorWithUrl:(NSString *)url
{
    url = [NSString stringWithFormat:@"%@",url];
    [self jhSetImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholder:kDefaultAvatarImage];
}

@end


@implementation UILabel (UIHelp)

- (UILabel * (^)(UIFont* font))jh_font
{
    return ^(UIFont *font){
        self.font = font;
        return self;
    };
}

- (UILabel * (^)(NSString* text))jh_text
{
    return ^(NSString *text){
        self.text = text;
        return self;
    };
}

- (UILabel * (^)(NSTextAlignment textAlignment))jh_textAlignment
{
    return ^(NSTextAlignment textAlignment){
        self.textAlignment = textAlignment;
        return self;
    };
}

- (UILabel * (^)(UIColor* color))jh_textColor
{
    return ^(UIColor *color){
        self.textColor = color;
        return self;
    };
}

- (UILabel * (^)(UIColor* color))jh_backgroundColor
{
    return ^(UIColor *color){
        self.backgroundColor = color;
        return self;
    };
}

- (UILabel * (^)(NSInteger num))jh_numberOfLines
{
    return ^(NSInteger num){
        self.numberOfLines = num;
        return self;
    };
}

- (UILabel * (^)(NSLineBreakMode lineBreak))jh_lineBreakMode
{
    return ^(NSLineBreakMode lineBreak){
        self.lineBreakMode = lineBreak;
//           NSLineBreakByTruncatingTail,
        return self;
    };
}

+ (instancetype)jh_labelWithText:(NSString*)string
                     font:(NSInteger)font
                textColor:(UIColor *)color
            textAlignment:(NSTextAlignment)textAlignment
           addToSuperView:(UIView *)superview
{
    UILabel *label = [[self alloc] init];
    label.text = string;
    label.font = [UIFont systemFontOfSize:font];
    label.textColor = color;
    label.textAlignment = textAlignment;
    [superview addSubview:label];
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    return label;
}

+ (instancetype)jh_labelWithBoldText:(NSString*)string
                         font:(NSInteger)font
                    textColor:(UIColor *)color
                textAlignment:(NSTextAlignment)textAlignment
               addToSuperView:(UIView *)superview
{
    UILabel *label = [self jh_labelWithText:string font:font textColor:color textAlignment:textAlignment addToSuperView:superview];
    label.font = [UIFont boldSystemFontOfSize:font];
    return label;
}


+ (instancetype)jh_labelWithFont:(NSInteger)font
                textColor:(UIColor *)color
            textAlignment:(NSTextAlignment)textAlignment
           addToSuperView:(UIView *)superview{
    
    return [self jh_labelWithText:@"" font:font textColor:color textAlignment:textAlignment addToSuperView:superview];
    
}

+ (instancetype)jh_labelWithFont:(NSInteger)font
                textColor:(UIColor *)color
           addToSuperView:(UIView *)superview{
    return [self jh_labelWithText:@"" font:font textColor:color textAlignment:NSTextAlignmentLeft addToSuperView:superview];
}

+ (instancetype)jh_labelWithBoldFont:(NSInteger)boldFont
                    textColor:(UIColor *)color
               addToSuperView:(UIView *)superview{
    
    UILabel *label = [self jh_labelWithFont:boldFont textColor:color addToSuperView:superview];
    label.font = [UIFont boldSystemFontOfSize:boldFont];
    return label;
}

+ (instancetype)jh_labelWithBoldFont:(NSInteger)boldFont
                        textColor:(UIColor *)color
                    textAlignment:(NSTextAlignment)textAlignment
                   addToSuperView:(UIView *)superview{
    
    UILabel *label = [self jh_labelWithBoldFont:boldFont textColor:color addToSuperView:superview];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

@end


@implementation UIScrollView (UIHelp)

+ (instancetype)jh_scrollViewWithContentSize:(CGSize)contentsize
                       showsScrollIndicator:(BOOL)showsScrollIndicator
                               scrollsToTop:(BOOL)scrollsToTop
                                    bounces:(BOOL)bounces
                              pagingEnabled:(BOOL)pagingEnabled
                             addToSuperView:(UIView *)superview
{
    UIScrollView *scrollview = [[self alloc]init];
    scrollview.showsHorizontalScrollIndicator = showsScrollIndicator;
    scrollview.showsVerticalScrollIndicator = showsScrollIndicator;
    scrollview.bounces = bounces;
    scrollview.pagingEnabled = pagingEnabled;
    scrollview.scrollsToTop = scrollsToTop;
    scrollview.scrollEnabled = YES;
    scrollview.contentSize = contentsize;
    [superview addSubview:scrollview];
    
    return scrollview;
}

@end


@implementation UITableView (UIHelp)

+ (instancetype)jh_tableViewWithStyle:(UITableViewStyle)tableViewStyle
                    separatorStyle:(UITableViewCellSeparatorStyle)separatorStyle
                            target:(id)target
                    addToSuperView:(UIView *)superview

{
    UITableView *tableView = [[self alloc] initWithFrame:CGRectZero style:tableViewStyle];
    tableView.separatorStyle = separatorStyle;
    tableView.dataSource = target;
    tableView.delegate = target;
    [superview addSubview:tableView];
    return tableView;
}
@end

@implementation UITextField (UIHelp)

+ (instancetype)jh_textFieldWithFont:(NSInteger)font textAlignment:(NSTextAlignment)textAlignment textColor:(UIColor *)textColor placeholderText:(NSString *)placeholderText placeholderColor:(UIColor *)placeholderColor addToSupView:(UIView *)superView
{
    UITextField *textField = [self jh_textFieldWithFont:font textAlignment:textAlignment textColor:textColor addToSupView:superView];
    textField.attributedPlaceholder=[[NSAttributedString alloc]initWithString:placeholderText attributes:@{NSForegroundColorAttributeName:placeholderColor}];
    [superView addSubview:textField];
    return textField;
}

+ (instancetype)jh_textFieldWithFont:(NSInteger)font textAlignment:(NSTextAlignment)textAlignment textColor:(UIColor *)textColor addToSupView:(UIView *)superView
{
    UITextField *textField = [self new];
    textField.textAlignment = textAlignment;
    textField.textColor = textColor;
    textField.font = [UIFont systemFontOfSize:font];
    [superView addSubview:textField];
    
    return textField;
}

@end

#import <objc/runtime.h>
const char *jh_gestureBlockKey = "jh_gestureBlockKey";
@implementation UIView (Gesture)

- (void)setJh_tapGesture:(dispatch_block_t)jh_tapGesture {
    objc_setAssociatedObject(self, &jh_gestureBlockKey, jh_tapGesture, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (dispatch_block_t)jh_tapGesture {
    return objc_getAssociatedObject(self, &jh_gestureBlockKey);
}

-(void)jh_addTapGesture:(dispatch_block_t)block{
    self.jh_tapGesture = block; // 把block赋值给self.tapBlock, 可以在当前函数之外执行该回调
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *jh_tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(jh_tapGestureMethod)];
    [self addGestureRecognizer:jh_tapGesture];
}

-(void)jh_tapGestureMethod{
    if(self.jh_tapGesture){
        self.jh_tapGesture();
    }
    
}

@end

