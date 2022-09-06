//
//  JHCaptureView.h
//  TTjianbao
//
//  Created by yaoyao on 2018/12/18.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IJKSDLGLView.h"

@interface JHCaptureView : NTESIJKSDLGLView

- (void) render: (NSData *)yuvData
          width:(NSUInteger)width
         height:(NSUInteger)height;

@end
