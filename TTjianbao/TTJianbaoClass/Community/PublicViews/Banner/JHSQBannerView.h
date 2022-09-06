//
//  JHSQBannerView.h
//  TTjianbao
//
//  Created by wuyd on 2020/6/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BannerCustomerModel;

NS_ASSUME_NONNULL_BEGIN

typedef void (^BannerClickBlock)(BannerCustomerModel *bannerData, NSInteger selectIndex);

@interface JHSQBannerView : UIView

@property (nonatomic, assign) JHBannerAdType type;

@property (nonatomic, strong) NSArray<BannerCustomerModel *> *bannerList;
@property (nonatomic, copy) dispatch_block_t growingClickBlock;

@property(nonatomic) BOOL notCornerRadius;
+ (instancetype)bannerWithClickBlock:(BannerClickBlock)block;
/// 初始化轮播图
/// @param bannerHeight 轮播图高度
/// @param block block description
+ (instancetype)bannerWithHeight:(CGFloat)bannerHeight ClickBlock:(BannerClickBlock)block;
+ (CGFloat)bannerHeight;


/// 初始化
/// @param frame banner大小
/// @param andEdge 内部间距
/// @param block block description
- (instancetype)initWithFrame:(CGRect)frame andEdge:(UIEdgeInsets)edge andClickBlock:(BannerClickBlock)block;
@end

NS_ASSUME_NONNULL_END
