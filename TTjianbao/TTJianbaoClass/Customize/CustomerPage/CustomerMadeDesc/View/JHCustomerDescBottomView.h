//
//  JHCustomerDescBottomView.h
//  TTjianbao
//
//  Created by user on 2020/10/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JHCustomerDescBottomBtnStyle) {
    JHCustomerDescBottomBtnStyle_Fav,            /* 点赞 */
    JHCustomerDescBottomBtnStyle_Share,          /* 分享 */
};

typedef void (^customerDescBtnActionBlock) (JHCustomerDescBottomBtnStyle style);
@interface JHCustomerDescBottomView : UIView
- (void)customerDescBtnAction:(customerDescBtnActionBlock)clickBlock;
- (void)setFavBtnCount:(NSInteger)praiseNum;
- (void)setFavBtnStatus:(BOOL)isSelected;
@end

NS_ASSUME_NONNULL_END
