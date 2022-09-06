//
//  JHShopHomeNavigationBar.h
//  TTjianbao
//
//  Created by apple on 2019/11/21.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class JHSellerInfo;

@protocol JHShopHomeNavigationBarDelegate <NSObject>

@optional
- (void)attentionShop:(BOOL)isFollow;
- (void)enterShopOwerHomePage;
- (void)leftButtonAction;
- (void)rightButtonAction;


@end


@interface JHShopHomeNavigationBar : UIView

@property (nonatomic, weak) id<JHShopHomeNavigationBarDelegate> delegate;

@property (nonatomic, strong) JHSellerInfo *sellerInfo;
@property (nonatomic, strong) UIView *blackView;
@property (nonatomic, strong) UIButton *leftButton;
@property (nonatomic, strong) UIButton *rightButton;
///是否关注
@property (nonatomic, assign) BOOL isFollow;

- (void)showOriginView;
- (void)showDragUpView;

- (void)changeBarTop:(CGFloat)top;
- (void)changeBarHeight:(CGFloat)barHeight;
- (void)layoutBar;

@end

NS_ASSUME_NONNULL_END
