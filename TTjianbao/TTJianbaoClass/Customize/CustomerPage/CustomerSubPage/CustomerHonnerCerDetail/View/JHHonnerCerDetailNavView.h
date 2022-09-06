//
//  JHHonnerCerDetailNavView.h
//  TTjianbao
//
//  Created by user on 2020/10/27.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JHHonnerCerDetailButtonStyle) {
    JHHonnerCerDetailButtonStyle_Back,           /* 返回 */
    JHHonnerCerDetailButtonStyle_Delete,         /* 分享 */
    JHHonnerCerDetailButtonStyle_Share           /* 删除 */
};

typedef void (^honnerCerNavButtonClickBlock) (JHHonnerCerDetailButtonStyle style);
@interface JHHonnerCerDetailNavView : UIView
@property (nonatomic, assign) BOOL isAnchor; /// 是否是主播
- (void)honnerCerNavViewBtnAction:(honnerCerNavButtonClickBlock)clickBlock;
- (void)reloadHCInfoName:(NSString *)name;
@end


NS_ASSUME_NONNULL_END
