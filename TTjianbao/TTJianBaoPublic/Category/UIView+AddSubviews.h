//
//  UIView+AddSubviews.h
//  TTjianbao
//
//  Created by plz on 2021/5/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (AddSubviews)

- (void)addSubviews:(NSArray<UIView *> *)subviews;

/**
 渲染 tableview section 卡片式圆角样式 圆角默认 15
 @param cell cell
 @param indexPath indexPath
 @param tableView tableView
 @param cornerRadius cornerRadius
 @return 圆角view
 */
- (UIView *)renderCornerRadiusWithCell:(UITableViewCell *)cell
                             indexPath:(NSIndexPath *)indexPath
                             tableView:(UITableView *)tableView
                          cornerRadius:(CGFloat)cornerRadius;

/**
 渲染 tableview section 卡片式圆角样式
 @param cell cell
 @param indexPath indexPath
 @param tableView tableView
 @param cornerRadius 卡片圆角度
 @return 圆角view
 */
- (UIView *)renderCornerRadiusWithCell:(UITableViewCell *)cell
                             indexPath:(NSIndexPath *)indexPath
                             tableView:(UITableView *)tableView
                          cornerRadius:(CGFloat)cornerRadius;


/**
 渲染 tableview cell 卡片式四角全圆角样式 圆角默认 6
 @param cell cell
 @return 圆角view
 */
- (UIView *)renderAllCornerRadiusWithCell:(UITableViewCell *)cell;

/**
 渲染 tableview cell 卡片式四角全圆角样式
 @param cell cell
 @param cornerRadius 卡片圆角度
 @return 圆角view
 */
- (UIView *)renderAllCornerRadiusWithCell:(UITableViewCell *)cell cornerRadius:(CGFloat)cornerRadius;

@end

NS_ASSUME_NONNULL_END
