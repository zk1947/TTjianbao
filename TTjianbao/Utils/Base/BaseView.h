//
//  BaseView.h
//  TTjianbao
//
//  Created by jiang on 2019/7/8.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TTjianbaoHeader.h"
#import "TTjianbaoMarcoKeyword.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseView : UIView
- (void)showDefaultImageWithView:(UIView *)superView;
- (void)hiddenDefaultImage;
 //设置 左上和右上为圆角
- (void)setCornerForView;
- (void)setCornerForViewWithTop:(CGFloat)top;
//设置view渐变色
- (void)setGradientWithTop:(CGFloat)top;
- (void)hiddenAlert;
- (void)showAlert;
@end

NS_ASSUME_NONNULL_END
    
