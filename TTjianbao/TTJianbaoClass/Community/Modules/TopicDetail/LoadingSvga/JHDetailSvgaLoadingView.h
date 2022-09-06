//
//  JHDetailSvgaLoadingView.h
//  TTjianbao
//
//  Created by wangjianios on 2020/9/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHDetailSvgaLoadingView : UIView


-(instancetype)initWithFrame:(CGRect)frame placeholderImage:(NSString *)placeholderImage;


- (void)showLoading;

- (void)dismissLoading;

@end

NS_ASSUME_NONNULL_END
