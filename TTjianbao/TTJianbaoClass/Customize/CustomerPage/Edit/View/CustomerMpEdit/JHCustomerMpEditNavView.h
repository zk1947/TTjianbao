//
//  JHCustomerMpEditNavView.h
//  TTjianbao
//
//  Created by user on 2020/10/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JHCustomerMpEditNavButtonStyle) {
    JHCustomerMpEditNavButtonStyle_Back,           /* 返回 */
    JHCustomerMpEditNavButtonStyle_Save,           /* 保存 */
};

typedef void (^customerEditNavButtonClickBlock) (JHCustomerMpEditNavButtonStyle style);
@interface JHCustomerMpEditNavView : UIView
- (void)customerEditNavButtonAction:(customerEditNavButtonClickBlock)clickBlock;
- (void)reloadNavInfo:(UIImage *)image name:(NSString *)name subName:(NSString *)subName;
@end





NS_ASSUME_NONNULL_END
