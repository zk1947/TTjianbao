//
//  JHOrderListZhiFaListView.h
//  TTjianbao
//
//  Created by user on 2021/6/24.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHOrderListZhiFaListView : UIView
/**
 点击回调,返回所点的角标以及点击的内容
 */
@property(nonatomic,   copy) void(^didSelectedCallback)(NSInteger index, NSString * content);
/// 显示字体设置
@property(nonatomic, assign) UIFont  *cusFont;
/// 数据源 数据, 下拉列表的内容数组.
@property(nonatomic, strong) NSArray *arrMDataSource;
/// tableview以及cell的背景色, 如果不设置默认白色
@property(nonatomic, strong) UIColor *tabColor;
/// 文字的颜色, 默认黑色
@property(nonatomic, strong) UIColor *txtColor;

/// 不要背景
@property(nonatomic, assign) BOOL noBackImage;

@end

NS_ASSUME_NONNULL_END
