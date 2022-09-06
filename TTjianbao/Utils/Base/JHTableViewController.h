//
//  JHTableViewController.h
//  TTjianbao
//
//  Created by apple on 2019/11/7.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//
#import "JHBaseViewExtController.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, JHScrollDirectType)
{
    JHScrollDirectTypeDefault, //scroll begin 时, 默认状态
    JHScrollDirectTypeUp,
    JHScrollDirectTypeDown,
    JHScrollDirectTypeEnd //scroll end
};

@protocol JHTableViewDelegate <NSObject>

@optional
- (void)JHScrollViewDidScroll:(UIScrollView *)scrollView scrollDirect:(JHScrollDirectType)directType;

@end

@interface JHTableViewController : JHBaseViewExtController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) id <JHTableViewDelegate> jhDelegate;
@property (nonatomic, assign) JHScrollDirectType scrollDirectType;
@property (nonatomic, strong) UITableView* jhTableView;

//添加刷新
- (void)addRefreshView;
//刷新完成后,关闭
- (void)hideRefreshView;
//添加加载更多
- (void)addLoadMoreView;
//加载完成后,关闭
- (void)hideLoadMoreView;
//隐藏加载更多,且不许再上拉加载
- (void)hideLoadMoreWithNoData;
////显示empty页面
//- (void)showDefaultImageWithView:(UIView *)superView;
////隐藏empty页面
//- (void)hiddenDefaultImage;
@end

NS_ASSUME_NONNULL_END
