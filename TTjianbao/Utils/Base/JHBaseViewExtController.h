//
//  JHBaseViewExtController.h
//  TaoDangPuMall
//
//  Created by jiangchao on 2016/12/26.
//  Copyright © 2016年 jiangchao. All rights reserved.
//

#import "TTjianbaoHeader.h"
#import "JHBaseViewController.h"

@interface JHBaseViewExtController : JHBaseViewController

@property (nonatomic, strong) UIImageView* activityImage; //活动图标:右边"国庆钜惠"
@property (nonatomic, strong) UIImageView* backTopImage; //回到顶部图标

- (void)showDefaultImageWithView:(UIView *)superView;
- (void)setDefaultImageOffset:(CGFloat)offset andView:(UIView *)sView;
- (void)hiddenDefaultImage;
- (void)showBackTopImage;
- (void)showActivityImage;
- (void)showImageName:(NSString *)imageName title:(NSString *)string superview:(UIView *)view;

/**
 上拉加载 下拉刷新
 
 @param scrolle tableView
 @param target target
 @param refresh_selector refresh_selector
 @param loadmore_selector loadmore_selector
 */
- (void)setupScrollView:(UIScrollView *)scrollView
                 target:(id)target
            refreshData:(SEL)refresh_selector
           loadMoreData:(SEL)loadmore_selector;


//扩展一下
- (void)getAllUnreadMsgCount:(JHActionBlock)response;

/**
 创建并添加消息按钮

 @return 消息按钮
 */
- (UIButton *)createAddMsgBtn;

@end
