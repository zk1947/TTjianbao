//
//  JHNewShopDetailHeaderView.h
//  TTjianbao
//
//  Created by haozhipeng on 2021/2/3.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
//  商铺头部

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class JHNewShopDetailInfoModel;

@interface JHNewShopDetailHeaderView : UIView
///优惠券view
@property (nonatomic, strong) UIView *couponView;
@property (nonatomic, strong)JHNewShopDetailInfoModel *shopHeaderInfoModel;
///关注按钮点击回调
@property (nonatomic, copy) JHActionBlock followSuccessBlock;
///店铺信息点击回调
@property (nonatomic, copy) JHFinishBlock clickShopInfoBlock;
///关注状态
@property (nonatomic, assign) BOOL isFollowed;

///滚动下拉放大
- (void)updateImageHeight:(float)height;
///显示刷新动画
- (void)showLoading;
///隐藏刷新动画
- (void)dismissLoading;



@end

NS_ASSUME_NONNULL_END
