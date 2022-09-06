//
//  JHNewStoreClassResultHeaderTagsView.h
//  TTjianbao
//
//  Created by hao on 2021/8/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
//  头部按钮选择view

#import <UIKit/UIKit.h>
#import "JHNewStoreTypeTableCellViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, JHNewStorePriceSortType) {
    JHNewStorePriceSortTypeDismiss       = -1,     //取消弹窗
    JHNewStorePriceSortTypeDefault       = 0,     //综合排序
    JHNewStorePriceSortTypeIncrease      = 1,     //升序
    JHNewStorePriceSortTypeDecrease      = 2,     //降序
    JHNewStorePriceSortTypeAuction       = 3,     //马上开拍
    JHNewStorePriceSortTypeLatest        = 4,     //最新上架
};

@protocol JHNewStoreClassResultHeaderTagsViewDelegate <NSObject>
/// tags标签事件点击
/// @param selectedIndex 选中的index
- (void)tagsViewSelectedOfIndex:(NSInteger)selectedIndex selected:(BOOL)selected;

/// 排序事件点击
/// @param sortType 选中的type
- (void)sortViewSelectedOfIndex:(JHNewStorePriceSortType)sortType;

/// 分类弹窗事件点击
/// @param subClassModel 选中的子分类model
/// @param selectAllClass 是否选择子类的全部按钮
/// @param dismiss 点击背景
- (void)classViewDidSelect:(JHNewStoreTypeTableCellViewModel* )subClassModel selectAllClass:(BOOL)selectAllClass dismissView:(BOOL)dismiss;

/// 筛选弹窗事件点击
/// @param serviceIndex 服务选中的index
/// @param isSelected 是否选中拍卖按钮
/// @param lowPrice 输入的最低价格
/// @param highPrice 输入的最高价格
- (void)filterViewSelectedOfService:(NSInteger)serviceIndex auction:(BOOL)isSelected lowPrice:(NSString *)lowPrice highPrice:(NSString *)highPrice;

@end

@interface JHNewStoreClassResultHeaderTagsView : UIView
@property (nonatomic, weak) id<JHNewStoreClassResultHeaderTagsViewDelegate> delegate;
///排序type
@property (nonatomic, assign) JHNewStorePriceSortType sortType;
///返回的聚合分类数组
@property (nonatomic,   copy) NSArray *subCateIds;
///所选标题index 0全部 1拍卖 2一口价
@property (nonatomic, assign) NSInteger titleIndex;
///选择条件标题列表
@property (nonatomic,   copy) NSArray *tagArray;


///进入当前页面时之前页面的弹窗收起
- (void)viewControllerWillAppear;

@end

NS_ASSUME_NONNULL_END
