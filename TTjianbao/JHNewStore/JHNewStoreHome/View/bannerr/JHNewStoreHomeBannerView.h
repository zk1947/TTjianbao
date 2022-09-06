//
//  JHNewStoreHomeBannerView.h
//  TTjianbao
//
//  Created by user on 2021/2/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHNewStoreBannerModel;

NS_ASSUME_NONNULL_BEGIN

typedef void (^BannerDidClickBlock)(JHNewStoreBannerModel *bannerData);

@interface JHNewStoreHomeBannerView : UIView
@property (nonatomic, strong) NSArray<JHNewStoreBannerModel *> *bannerList;

+ (instancetype)bannerWithClickBlock:(BannerDidClickBlock)block;
+ (CGFloat)bannerHeight;

@end

NS_ASSUME_NONNULL_END
