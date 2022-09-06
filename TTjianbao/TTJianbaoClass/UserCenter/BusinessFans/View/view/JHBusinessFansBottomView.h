//
//  JHBusinessFansBottomView.h
//  TTjianbao
//
//  Created by user on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JHBusinessFansBottomBtnStyle) {
    JHCustomerDescBottomBtnStyle_up,            /* 点赞 */
    JHCustomerDescBottomBtnStyle_down,          /* 分享 */
};

typedef void (^businessFansBtnActionBlock) (JHBusinessFansBottomBtnStyle style);
@interface JHBusinessFansBottomView : UIView
- (void)renameBtns:(NSArray<NSString *>*)array;
- (void)businessFansBtnAction:(businessFansBtnActionBlock)clickBlock;
- (void)setNextButtonStatus:(BOOL)canClick;
@end


NS_ASSUME_NONNULL_END
