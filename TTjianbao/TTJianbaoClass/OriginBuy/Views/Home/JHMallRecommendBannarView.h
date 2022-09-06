//
//  JHMallRecommendBannarView.h
//  TTjianbao
//
//  Created by wangjianios on 2020/12/4.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHMallBannerModel;

NS_ASSUME_NONNULL_BEGIN

@interface JHMallRecommendBannarView : UIView

///存储图片的数组
@property (nonatomic, copy) NSArray <JHMallBannerModel *> *bannarArray;

+ (CGSize)viewSize;

@end

NS_ASSUME_NONNULL_END
