//
//  JHBuyAppraiseSeparateOperationView.h
//  TTjianbao
//
//  Created by wangjianios on 2021/2/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHBuyAppraiseSeparateOperationView : UIView

/// 刷新数据
- (void)refreshData;

/// 宽高比 70.f/351.f
+ (CGSize)viewSize;

/// 宽高比 70.f/351.f
+ (CGFloat)viewHeight;

@property (nonatomic, copy) void (^ hiddenBlock) (BOOL hidden);

@end

NS_ASSUME_NONNULL_END
