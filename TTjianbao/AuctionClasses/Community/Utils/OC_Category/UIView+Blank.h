//
//  UIView+Blank.h
//  Cooking-Home
//
//  Created by wubin on 2018/1/6.
//  Copyright © 2018年 ASYD. All rights reserved.
//  空页面/加载失败页面配置
//

#import <UIKit/UIKit.h>

@class UIBlankView;

/** 页面类型 */
typedef NS_ENUM(NSInteger, YDBlankType)
{
    YDBlankTypeNone = 0,
    YDBlankTypeNoUserFollow,            //关注列表
    YDBlankTypeNoUserFans,              //粉丝列表
    YDBlankTypeNoStoreHomeList,         //商城首页主列表
    YDBlankTypeNoGoodsList,             //商城首页-分类标签下的商品列表
    YDBlankTypeNoAllTopicList,          //全部话题列表
    YDBlankTypeNoAllTopicSearchList,    //全部话题搜索列表
    YDBlankTypeNoShopList,              //店铺列表
    YDBlankTypeNoShopSearchList,        //店铺搜索列表
    YDBlankTypeNoCollectionList,        //我的收藏列表
    YDBlankTypeNoSearchResult,          //商城搜索结果落地页
    YDBlankTypeNoValidVoucherList,      //没有可发放的代金券数据
    YDBlankTypeNoShopWindowList,        //没有搜到商品，看看其他的吧~
    YDBlankTypeNoPlateSelectList,       //没有发布页版块选择列表
};

@interface UIView (Blank)

@property (nonatomic, strong) UIBlankView *blankView;

- (void)configBlankType:(YDBlankType)blankType hasData:(BOOL)hasData hasError:(BOOL)hasError reloadBlock:(void(^)(id sender))block;
- (void)configBlankType:(YDBlankType)blankType hasData:(BOOL)hasData hasError:(BOOL)hasError offsetY:(CGFloat)offsetY reloadBlock:(void(^)(id sender))block;

@end


#pragma mark -
#pragma mark - UIBlankView
@interface UIBlankView : UIView

@property (nonatomic, copy) void(^clickButtonBlock)(YDBlankType curType); //其他按钮 Block

- (void)configWithType:(YDBlankType)blankType hasData:(BOOL)hasData hasError:(BOOL)hasError offsetY:(CGFloat)offsetY reloadBlock:(void(^)(id sender))block;

@end
