//
//  YYAnimatedImageView+OLELayer.m
//  TTjianbao
//
//  Created by jiangchao on 2020/10/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "YYAnimatedImageView+OLELayer.h"

@implementation YYAnimatedImageView (OLELayer)
+ (void)load {
    
    Method displayLayerMethod = class_getInstanceMethod(self, @selector(displayLayer:));
   
    Method displayLayerNewMethod = class_getInstanceMethod(self, @selector(displayLayerNew:));
 
    method_exchangeImplementations(displayLayerMethod, displayLayerNewMethod);
}

- (void)displayLayerNew:(CALayer *)layer {
    
    Ivar imgIvar = class_getInstanceVariable([self class], "_curFrame");
    UIImage *img = object_getIvar(self, imgIvar);
    if (img) {
        layer.contents = (__bridge id)img.CGImage;
    } else {
        if (@available(iOS 14.0, *)) {
            [super displayLayer:layer];
        }
    }
}
@end
