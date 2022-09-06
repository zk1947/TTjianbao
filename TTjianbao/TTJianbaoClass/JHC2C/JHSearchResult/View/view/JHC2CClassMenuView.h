//
//  JHC2CClassMenuView.h
//  TTjianbao
//
//  Created by hao on 2021/5/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
//  分类列表弹窗

#import <UIKit/UIKit.h>
#import "JHC2CSearchResultBusiness.h"

NS_ASSUME_NONNULL_BEGIN

@protocol JHC2CClassMenuViewDelegate <NSObject>
/// 分类弹窗事件点击
/// @param subClassModel 选中的子分类model
/// @param selectAllClass 是否选择子类的全部按钮
/// @param dismiss 点击背景
- (void)classViewDidSelect:(JHNewStoreTypeTableCellViewModel* )subClassModel selectAllClass:(BOOL)selectAllClass dismissView:(BOOL)dismiss;

@end

@interface JHC2CClassMenuView : UIView
@property (nonatomic,   weak) id<JHC2CClassMenuViewDelegate> delegate;
///页面来源 0:C2C  1:B2C
@property (nonatomic, assign) NSInteger fromStatus;
@property (nonatomic,   copy) NSArray *subCateIds;
@end

NS_ASSUME_NONNULL_END
