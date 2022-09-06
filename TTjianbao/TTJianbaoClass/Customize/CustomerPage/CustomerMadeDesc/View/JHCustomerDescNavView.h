//
//  JHCustomerDescNavView.h
//  TTjianbao
//
//  Created by user on 2020/10/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JHCustomerDescNavButtonStyle) {
    JHCustomerDescNavButtonStyle_Back,           /* 返回 */
    JHCustomerDescNavButtonStyle_Share,          /* 分享 */
    JHCustomerDescNavButtonStyle_Hidden,         /* 隐藏 */
};

typedef void (^customerDescNavButtonClickBlock) (JHCustomerDescNavButtonStyle style);
@interface JHCustomerDescNavView : UIView
- (void)customerDescNavViewBtnAction:(customerDescNavButtonClickBlock)clickBlock;
- (void)moreViewRelease;
- (void)removeNavSubViews;
- (void)setMoreStatus:(BOOL)hasHidden;
- (void)setNavImg:(BOOL)isChange;

- (void)changeNavBackBlack:(BOOL)isChange; /// 返回按钮使用黑色
- (void)showHiddenButton:(BOOL)isShow;

@end




NS_ASSUME_NONNULL_END
