//
//  YDBaseNavigationBar.h
//  TTjianbao
//
//  Created by wuyd on 2019/8/4.
//  Copyright © 2019 Netease. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface YDBaseNavigationBar : BaseView

@property (nonatomic, strong) UIImageView *backgroundView; //背景
@property (nonatomic, strong) UIButton *leftBtn; //左侧按钮（返回按钮）
@property (nonatomic, strong) UIButton *rightBtn; //右侧按钮
@property (nonatomic, strong) UILabel *titleLabel; //标题
@property (nonatomic, strong) UILabel *subTitleLabel; //副标题
@property (nonatomic, strong) UIView *titleView;
/** 导航栏底部分割线，默认隐藏 */
@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic,   copy) NSString *title; //标题
@property (nonatomic,   copy) NSString *subTitle; //副标题
@property (nonatomic, strong) UIImage *leftImage; //左侧按钮图标
@property (nonatomic, strong) UIImage *rightImage; //右侧按钮图标
@property (nonatomic,   copy) NSString *rightTitle; //右侧按钮标题

+ (instancetype)naviBar;

- (void)showBackButton; ///显示返回按钮
- (void)hideBackButton; ///隐藏返回按钮

@end

NS_ASSUME_NONNULL_END
