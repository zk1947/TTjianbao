//
//  JHStoreHomeBannerView.h
//  TTjianbao
//
//  Created by wuyd on 2019/11/21.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BannerCustomerModel;

NS_ASSUME_NONNULL_BEGIN

typedef void (^BannerDidClickBlock)(BannerCustomerModel *bannerData, NSInteger index);

@interface JHStoreHomeBannerView : UIView

@property (nonatomic, strong) NSArray<BannerCustomerModel *> *bannerList;

+ (instancetype)bannerWithClickBlock:(BannerDidClickBlock)block;
+ (CGFloat)bannerHeight;

@end

NS_ASSUME_NONNULL_END
