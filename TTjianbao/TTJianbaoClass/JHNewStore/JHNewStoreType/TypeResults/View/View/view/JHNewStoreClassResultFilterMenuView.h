//
//  JHNewStoreClassResultFilterMenuView.h
//  TTjianbao
//
//  Created by hao on 2021/8/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
//  筛选弹窗

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JHNewStoreClassResultFilterMenuViewDelegate <NSObject>
/// 筛选弹窗事件点击
/// @param serviceIndex 服务选中的index
/// @param isSelected 是否选中拍卖按钮
/// @param lowPrice 输入的最低价格
/// @param highPrice 输入的最高价格
- (void)filterViewSelectedOfService:(NSInteger)serviceIndex auction:(BOOL)isSelected lowPrice:(NSString *)lowPrice highPrice:(NSString *)highPrice isFilteredInfo:(BOOL)isFiltered;

@end

@interface JHNewStoreClassResultFilterMenuView : UIView
@property (nonatomic, weak) id<JHNewStoreClassResultFilterMenuViewDelegate> delegate;
///第几个标签 0：全部 1：拍卖  2：一口价
@property (nonatomic, assign) NSInteger titleTagIndex;

- (void)show;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
