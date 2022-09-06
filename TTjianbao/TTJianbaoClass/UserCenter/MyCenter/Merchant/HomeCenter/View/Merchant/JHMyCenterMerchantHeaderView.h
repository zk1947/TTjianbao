//
//  JHMyCenterMerchantHeaderView.h
//  TTjianbao
//
//  Created by lihui on 2021/4/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHMyCenterMerchantHeaderView : UIView
+ (CGFloat)headerHeight;
@property (nonatomic, copy) void (^actionBlock)(NSInteger index);
///默认选中 默认是0
@property (nonatomic, assign) NSInteger defaultIndex;

@end

NS_ASSUME_NONNULL_END
