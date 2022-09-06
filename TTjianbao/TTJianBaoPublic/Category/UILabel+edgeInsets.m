//
//  UILabel+edgeInsets.m
//  TTjianbao
//
//  Created by user on 2021/2/4.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "UILabel+edgeInsets.h"

@implementation UILabel (edgeInsets)

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod(self.class,
                                                           @selector(textRectForBounds:limitedToNumberOfLines:)),
                                   class_getInstanceMethod(self.class,
                                                           @selector(sxt_textRectForBounds:sxt_limitedToNumberOfLines:)));
    
    method_exchangeImplementations(class_getInstanceMethod(self.class,
                                                           @selector(drawTextInRect:)),
                                   class_getInstanceMethod(self.class,
                                                           @selector(sxt_drawTextInRect:)));
}

//runTime 关联
- (void)setEdgeInsets:(UIEdgeInsets)edgeInsets {
    //id  不让放struct 类型
    NSArray * arr = @[@(edgeInsets.top),@(edgeInsets.left),@(edgeInsets.bottom),@(edgeInsets.right)];
    objc_setAssociatedObject(self, @selector(edgeInsets), arr, OBJC_ASSOCIATION_RETAIN);
}

- (UIEdgeInsets)edgeInsets {
    NSArray * arr = objc_getAssociatedObject(self, @selector(edgeInsets));
    return UIEdgeInsetsMake([arr[0] floatValue], [arr[1] floatValue], [arr[2] floatValue], [arr[3] floatValue]);
}

#pragma mark -
// 修改绘制文字的区域，edgeInsets增加bounds
- (CGRect)sxt_textRectForBounds:(CGRect)bounds sxt_limitedToNumberOfLines:(NSInteger)numberOfLines {
    /*
     注意传入的UIEdgeInsetsInsetRect(bounds, self.edgeInsets),bounds是真正的绘图区域
     CGRect rect = [super textRectForBounds: limitedToNumberOfLines:numberOfLines];
     类别中不能使用 super  用黑魔法替换方法
     */
    CGRect rect = [self sxt_textRectForBounds:UIEdgeInsetsInsetRect(bounds,self.edgeInsets) sxt_limitedToNumberOfLines:numberOfLines];
    //根据edgeInsets，修改绘制文字的bounds
    rect.origin.x -= self.edgeInsets.left;
    rect.origin.y -= self.edgeInsets.top;
    rect.size.width += self.edgeInsets.left + self.edgeInsets.right;
    rect.size.height += self.edgeInsets.top + self.edgeInsets.bottom;
    return rect;
}

//绘制文字
- (void)sxt_drawTextInRect:(CGRect)rect {
    //令绘制区域为原始区域，增加的内边距区域不绘制
    [self sxt_drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}
@end
