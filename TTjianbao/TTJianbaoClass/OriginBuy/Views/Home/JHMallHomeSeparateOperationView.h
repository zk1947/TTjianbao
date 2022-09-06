//
//  JHMallHomeSeparateOperationView.h
//  TTjianbao
//  等分广告位
//  Created by wangjianios on 2020/12/3.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 等分广告位
@interface JHMallHomeSeparateOperationView : UIView

/// 运营位背景图
@property (nonatomic, copy) NSString *imageUrl;

/// 等分数量（默认1）
@property (nonatomic, assign) NSInteger separateCount;

/// 比例划分
@property (nonatomic, copy) NSString *moreHotImgProportion;

/// 点击回调
@property (nonatomic, copy) void (^selectedIndex) (NSInteger index);

/// 宽高比 60.f/351.f
+ (CGSize)viewSize;

@end

NS_ASSUME_NONNULL_END
