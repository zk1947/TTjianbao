//
//  UITextView+PlaceHolder.m
//  TTjianbao
//
//  Created by user on 2020/10/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "UITextView+PlaceHolder.h"
#import <objc/runtime.h>
#import "NSObject+Cast.h"

@implementation UITextView (PlaceHolder)
+ (void)load {
    // is this the best solution?
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
        class_getInstanceMethod(self.class, @selector(swizzledDealloc)));
}

- (void)swizzledDealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    UILabel *label = objc_getAssociatedObject(self, @selector(placeholderLabel));
    if (label) {
        for (NSString *key in self.class.observingKeys) {
            @try {
                [self removeObserver:self forKeyPath:key];
            } @catch (NSException *exception) {
                // Do nothing
            }
        }
    }
    [self swizzledDealloc];
}

#pragma mark - Class Methods
#pragma mark `defaultPlaceholderColor`
+ (UIColor *)defaultPlaceholderColor {
    static UIColor        *color = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UITextField *textField = [[UITextField alloc] init];
        textField.placeholder = @" ";
        [textField.attributedPlaceholder enumerateAttribute:NSForegroundColorAttributeName inRange:NSMakeRange(0, textField.attributedPlaceholder.length) options:1 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
            if (value) {
                color = [UIColor cast:value];
                *stop = YES;
            }
        }];
    });
    return color;
}

#pragma mark - `observingKeys`
+ (NSArray *)observingKeys {
    return @[@"attributedText",
             @"bounds",
             @"font",
             @"frame",
             @"text",
             @"textAlignment",
             @"textContainerInset"];
}

#pragma mark - Properties
#pragma mark `placeholderLabel`
- (UILabel *)placeholderLabel {
    UILabel *label = objc_getAssociatedObject(self, @selector(placeholderLabel));
    if (!label) {
        NSAttributedString *originalText = self.attributedText;
        self.text           = @" "; // lazily set font of `UITextView`.
        self.attributedText = originalText;

        label                        = [[UILabel alloc] init];
        label.textColor              = [self.class defaultPlaceholderColor];
        label.numberOfLines          = 0;
        label.userInteractionEnabled = NO;
        objc_setAssociatedObject(self, @selector(placeholderLabel), label, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(updatePlaceholderLabel)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];

        for (NSString *key in self.class.observingKeys) {
            [self addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:nil];
        }
    }
    return label;
}

#pragma mark `placeholder`
- (NSString *)placeholder {
    return self.placeholderLabel.text;
}

- (void)setPlaceholder:(NSString *)placeholder {
    self.placeholderLabel.text = placeholder;
    [self updatePlaceholderLabel];
}

- (NSAttributedString *)attributedPlaceholder {
    return self.placeholderLabel.attributedText;
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    self.placeholderLabel.attributedText = attributedPlaceholder;
    [self updatePlaceholderLabel];
}

#pragma mark `placeholderColor`
- (UIColor *)placeholderColor {
    return self.placeholderLabel.textColor;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    self.placeholderLabel.textColor = placeholderColor;
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    [self updatePlaceholderLabel];
}

#pragma mark - Update
- (void)updatePlaceholderLabel {
    if (self.text.length) {
        [self.placeholderLabel removeFromSuperview];
        return;
    }

    [self insertSubview:self.placeholderLabel atIndex:0];

    self.placeholderLabel.font          = self.font;
    self.placeholderLabel.textAlignment = self.textAlignment;

    // `NSTextContainer` is available since iOS 7
    CGFloat      lineFragmentPadding;
    UIEdgeInsets textContainerInset;

    #pragma deploymate push "ignored-api-availability"
    // iOS 7+
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1) {
        lineFragmentPadding = self.textContainer.lineFragmentPadding;
        textContainerInset  = self.textContainerInset;
    }
    #pragma deploymate pop

    // iOS 6
    else {
        lineFragmentPadding = 0;
        textContainerInset  = UIEdgeInsetsMake(8, 0, 8, 0);
    }

    CGFloat x      = lineFragmentPadding + textContainerInset.left;
    CGFloat y      = textContainerInset.top;
    CGFloat width  = CGRectGetWidth(self.bounds) - x - lineFragmentPadding - textContainerInset.right;
    CGFloat height = [self.placeholderLabel sizeThatFits:CGSizeMake(width, 0)].height;
    self.placeholderLabel.frame = CGRectMake(x, y, width, height);
}

@end
