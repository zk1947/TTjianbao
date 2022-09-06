//
//  JHShopWindowReusableView.h
//  TTjianbao
//
//  Created by apple on 2019/11/21.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHShopWindowInfo;

NS_ASSUME_NONNULL_BEGIN

@interface JHShopWindowReusableView : UICollectionReusableView

@property (nonatomic, strong) JHShopWindowInfo *headerInfo;

@property (nonatomic, copy) void(^timerBlock)(void);

+ (CGFloat)headerHeight;

- (void)scrollViewDidScroll:(CGFloat)contentOffsetY;

@end

NS_ASSUME_NONNULL_END
