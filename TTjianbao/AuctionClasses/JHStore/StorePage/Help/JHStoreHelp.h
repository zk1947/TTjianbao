//
//  JHStoreHelp.h
//  TTjianbao
//
//  Created by wuyd on 2020/2/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JXPageListView.h"

NS_ASSUME_NONNULL_BEGIN

static const CGFloat JXPageHeightForHeaderInSection = 44;

@interface JHStoreHelp : NSObject

///pageListView
+ (JXPageListView *)pageListWithDelegate:(id)delegate;

///专题列表页：categoryView
+ (JXCategoryTitleView *)titleCategoryViewWithDelegate:(id)delegate;

///hot标签
+ (UIView *)hotImageView;

///为Label设置价格“¥”，默认前缀字号12
+ (void)setPrice:(NSString *)price forLabel:(UILabel *)label;
///为Label设置价格“¥”
+ (void)setPrice:(NSString *)price prefixFont:(UIFont *)font prefixColor:(UIColor *)color forLabel:(UILabel *)label;

+ (void)setNewPrice:(NSString *)price forLabel:(UILabel *)label Color:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
