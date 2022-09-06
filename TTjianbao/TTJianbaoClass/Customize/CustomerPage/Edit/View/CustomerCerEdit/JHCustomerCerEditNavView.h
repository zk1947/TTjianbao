//
//  JHCustomerCerEditNavView.h
//  TTjianbao
//
//  Created by user on 2020/10/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JHHonnerCerEditButtonStyle) {
    JHHonnerCerEditButtonStyle_Back,           /* 返回 */
    JHHonnerCerEditButtonStyle_Save            /* 删除 */
};

typedef void (^honnerCerEditNavButtonClickBlock) (JHHonnerCerEditButtonStyle style);
@interface JHCustomerCerEditNavView : UIView
- (void)honnerCerEditNavViewBtnAction:(honnerCerEditNavButtonClickBlock)clickBlock;
- (void)reloadHCInfoName:(NSString *)name btnName:(NSString *)btnName;
@end


NS_ASSUME_NONNULL_END
