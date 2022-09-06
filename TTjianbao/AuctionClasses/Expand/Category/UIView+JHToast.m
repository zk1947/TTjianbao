//
//  UIView+JHToast.m
//  TTjianbao
//
//  Created by mac on 2019/6/6.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "UIView+JHToast.h"
#import "UIView+NTES.h"
#import "MBProgressHUD.h"

@implementation UIView (JHToast)
- (void)showAnimalToast:(NSString *)message {
    [self showAnimalToast:message startY:0.f];
}
- (void)showAnimalToast:(NSString *)message startY:(CGFloat)starty {

    UIView *toast = [self makeViewForMessage:message];
    toast.top = starty;
    toast.alpha = 0.0;
    
    [self addSubview:toast];
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         toast.alpha = 1;
                         toast.top = 25;
                     } completion:^(BOOL finished) {
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             [UIView animateWithDuration:0.25
                                                   delay:0.0
                                                 options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                                              animations:^{
                                                  toast.top = starty;
                                                  toast.alpha = 0;
                                              } completion:^(BOOL finished) {
                                                  [toast removeFromSuperview];
                                              }];

                         });
                     }];
}



- (UIView *)makeViewForMessage:(NSString *)message {
    if(message == nil) return nil;
    
    UILabel *messageLabel = nil;
 
    UIView *wrapperView = [[UIView alloc] init];
    wrapperView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin);
    wrapperView.layer.cornerRadius = 10;
    wrapperView.layer.masksToBounds = YES;
    wrapperView.backgroundColor = [UIColor colorWithRed:0.f green:0.f blue:0.f alpha:0.8];
    
    if (message != nil) {
        messageLabel = [[UILabel alloc] init];
        messageLabel.numberOfLines = 0;
        messageLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
        
        messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
        messageLabel.textColor = [UIColor whiteColor];
        messageLabel.backgroundColor = [UIColor clearColor];
        messageLabel.alpha = 1.0;
        messageLabel.text = message;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        
        CGSize expectedSizeMessage = [self sizeForString:message font:messageLabel.font constrainedToSize:CGSizeMake(self.width-60, CGFLOAT_MAX) lineBreakMode:messageLabel.lineBreakMode];
        messageLabel.frame = CGRectMake(0.0, 0.0, expectedSizeMessage.width, expectedSizeMessage.height);
    }
    
    
    // messageLabel frame values
    CGFloat messageWidth, messageHeight, messageLeft, messageTop;
    
    if(messageLabel != nil) {
        messageWidth = messageLabel.bounds.size.width;
        messageHeight = messageLabel.bounds.size.height;
        messageLeft = 10;
        messageTop = 5;
    } else {
        messageWidth = messageHeight = messageLeft = messageTop = 0.0;
    }
    
    CGFloat wrapperWidth = messageLeft*2+messageWidth;
    CGFloat wrapperHeight = messageHeight+2*messageTop;
    
    wrapperView.frame = CGRectMake(0.0, 0.0, wrapperWidth, wrapperHeight);
    wrapperView.center = CGPointMake(self.center.x, wrapperView.center.y);
    
    wrapperView.layer.cornerRadius = wrapperHeight>30?15.:wrapperHeight/2.f;
    if(messageLabel != nil) {
        messageLabel.frame = CGRectMake(messageLeft, messageTop, messageWidth, messageHeight);
        [wrapperView addSubview:messageLabel];
    }
    
    
    return wrapperView;
}


- (CGSize)sizeForString:(NSString *)string font:(UIFont *)font constrainedToSize:(CGSize)constrainedSize lineBreakMode:(NSLineBreakMode)lineBreakMode {
    if ([string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineBreakMode = lineBreakMode;
        NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
        CGRect boundingRect = [string boundingRectWithSize:constrainedSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
        return CGSizeMake(ceilf(boundingRect.size.width), ceilf(boundingRect.size.height));
    }else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        return [string sizeWithFont:font constrainedToSize:constrainedSize lineBreakMode:lineBreakMode];
#pragma clang diagnostic pop
    }
}

-(void)showProgressHUDWithProgress:(CGFloat)progress WithTitle:(NSString*)title{
    [self hideProgressHUD];
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:self];
    hud.removeFromSuperViewOnHide = YES;
    [hud showAnimated:YES];
    //设置菊花框为白色
    hud.contentColor = [UIColor whiteColor];
    //背景色黑色半透明
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    hud.label.font = [UIFont systemFontOfSize:15];
    hud.label.textColor = kColorFFF;
    CGFloat proF = [NSString stringWithFormat:@"%.2f",progress].floatValue;
    NSString *proS = [NSString stringWithFormat:@"%.0f",proF*100];
    hud.label.text = [NSString stringWithFormat:@"%@ %@%%",title,proS];
    [self addSubview:hud];
}


-(void)hideProgressHUD{
    MBProgressHUD *hud = [self HUDForView:self];
    if (hud != nil) {
        hud.removeFromSuperViewOnHide = YES;
        [hud hideAnimated:YES];
    }
}

- (MBProgressHUD *)HUDForView:(UIView *)view {
    NSEnumerator *subviewsEnum = [view.subviews reverseObjectEnumerator];
    for (UIView *subview in subviewsEnum) {
        if ([subview isKindOfClass:[MBProgressHUD class]]) {
            MBProgressHUD *hud = (MBProgressHUD *)subview;
            return hud;
        }
    }
    return nil;
}
@end
