//
//  JHNewStoreSearchResultHeaderTagsView.h
//  TTjianbao
//
//  Created by hao on 2021/8/5.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
//  头部按钮选择view

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
///排序类型 0:综合 1:价格升序 2:价格降序 3:马上开拍 4:最新上架 5:即将截拍
typedef NS_ENUM(NSInteger, JHNewStorePriceSortType) {
    JHNewStorePriceSortTypeDismiss           = -1,     //取消弹窗
    JHNewStorePriceSortTypeDefault           = 0,     //综合排序
    JHNewStorePriceSortTypeIncrease          = 1,     //升序
    JHNewStorePriceSortTypeDecrease          = 2,     //降序
    JHNewStorePriceSortTypeStartAuction      = 3,     //马上开拍
    JHNewStorePriceSortTypeLatest            = 4,     //最新上架
    JHNewStorePriceSortTypeStopAuction       = 5,     //即将截拍
    
};
@protocol JHNewStoreSearchResultHeaderTagsViewDelegate <NSObject>

/// tags标签事件点击
/// @param selectedIndex 选中的index
- (void)tagsViewSelectedOfSortMenuView:(BOOL)dismiss;

/// 排序事件点击
/// @param sortType 选中的type
- (void)sortViewSelectedOfIndex:(JHNewStorePriceSortType)sortType;

/// 筛选弹窗事件点击
/// @param serviceIndex 服务选中的index
/// @param lowPrice 输入的最低价格
/// @param highPrice 输入的最高价格
- (void)filterViewSelectedOfService:(NSInteger)serviceIndex lowPrice:(NSString *)lowPrice highPrice:(NSString *)highPrice;

@optional
/// tags标签事件点击
/// @param selectedIndex 选中的index
- (void)tagsViewSelectedOfIndex:(NSInteger)selectedIndex;

@end

@interface JHNewStoreSearchResultHeaderTagsView : UIView
@property (nonatomic, weak) id<JHNewStoreSearchResultHeaderTagsViewDelegate> delegate;
///排序type
@property (nonatomic, assign) JHNewStorePriceSortType sortType;
/////返回的聚合分类数组
//@property (nonatomic,   copy) NSArray *subCateIds;
/////所选标题index 0全部 1拍卖 2一口价
//@property (nonatomic, assign) NSInteger titleIndex;

///选择条件标题列表
@property (nonatomic,   copy) NSArray *tagArray;
///默认选择
@property (nonatomic, assign) NSInteger defaultIndex;


///进入当前页面时之前页面的弹窗收起
- (void)viewControllerWillAppear;

@end

NS_ASSUME_NONNULL_END
