//
//  JHRecycleGoodsDetailBottomView.h
//  TTjianbao
//
//  Created by user on 2021/5/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JHRecycleGoodsDetailBottomBtnStyle) {
    JHRecycleGoodsDetailBottomBtnStyle_wantRecycle,        /* 我要回收 */
    JHRecycleGoodsDetailBottomBtnStyle_wantMoney,          /* 我要还钱 */
};

typedef void (^recycleBottomActionBlock) (JHRecycleGoodsDetailBottomBtnStyle style);


@interface JHRecycleGoodsDetailBottomView : UIView
- (void)recycleBottomAction:(recycleBottomActionBlock)clickBlock;
@end




NS_ASSUME_NONNULL_END
