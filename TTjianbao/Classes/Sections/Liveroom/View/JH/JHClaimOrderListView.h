//
//  JHClaimOrderListView.h
//  TTjianbao
//
//  Created by yaoyao on 2019/2/26.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHClaimOrderListView : UIControl
- (void)showAlert;
- (void)hiddenAlert;
- (void)catchImage:(UIImage *)image;
@property (nonatomic, copy) JHActionBlock clickImage;
@property (nonatomic, assign) BOOL isAppraising;


@end

NS_ASSUME_NONNULL_END
