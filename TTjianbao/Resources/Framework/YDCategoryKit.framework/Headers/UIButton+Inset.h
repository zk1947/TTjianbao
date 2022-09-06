//
//  UIButton+Inset.h
//  YDCategoryKit
//
//  Created by WU on 2018/1/10.
//  Copyright © 2018年 WU. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MRImageInsetStyle) {
    MRImageInsetStyleLeft,  //图片在左，文字在右
    MRImageInsetStyleRight, //图片在右，文字在左
    MRImageInsetStyleTop,   //图片在上，文字在下
    MRImageInsetStyleBottom //图片在下，文字在右
};

@interface UIButton (Inset)

- (void)setImageInsetStyle:(MRImageInsetStyle)insetStyle spacing:(CGFloat)spacing;

@end
