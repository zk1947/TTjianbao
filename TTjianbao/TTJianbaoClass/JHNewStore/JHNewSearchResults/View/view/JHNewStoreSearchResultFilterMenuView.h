//
//  JHNewStoreSearchResultFilterMenuView.h
//  TTjianbao
//
//  Created by hao on 2021/8/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
//  筛选弹窗

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol JHNewStoreSearchResultFilterMenuViewDelegate <NSObject>
/// 筛选弹窗事件点击
/// @param serviceIndex 服务选中的index
/// @param lowPrice 输入的最低价格
/// @param highPrice 输入的最高价格
- (void)filterViewSelectedOfService:(NSInteger)serviceIndex lowPrice:(NSString *)lowPrice highPrice:(NSString *)highPrice isFilteredInfo:(BOOL)isFiltered;

@end

@interface JHNewStoreSearchResultFilterMenuView : UIView
@property (nonatomic, weak) id<JHNewStoreSearchResultFilterMenuViewDelegate> delegate;

- (void)show;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
