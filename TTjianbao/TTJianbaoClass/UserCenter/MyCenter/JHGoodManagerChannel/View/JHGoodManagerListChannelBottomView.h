//
//  JHGoodManagerListChannelBottomView.h
//  TTjianbao
//
//  Created by user on 2021/8/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JHGoodManagerListChannelBottomBtnStyle) {
    JHGoodManagerListChannelBottomBtnStyle_reset,        /* 重置 */
    JHGoodManagerListChannelBottomBtnStyle_makeSure,     /* 确认 */
};

typedef void (^goodManagerListChannelBottomActionBlock) (JHGoodManagerListChannelBottomBtnStyle style);

@interface JHGoodManagerListChannelBottomView : UIView
- (void)goodManagerListChannelBottomAction:(goodManagerListChannelBottomActionBlock)clickBlock;
@end

NS_ASSUME_NONNULL_END

