//
//  JHShopInfoView.h
//  TTjianbao
//
//  Created by apple on 2019/12/16.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHSellerInfo;


typedef void(^JHFocusBlock)(void);



@interface JHShopInfoView : UIView

@property (nonatomic, strong) JHSellerInfo *sellerInfo;

@property (nonatomic, assign) BOOL isFocus; ///关注

@property (nonatomic, copy) JHFocusBlock focusBlock;





@end

NS_ASSUME_NONNULL_END
