//
//  JHRefreshGifHeader.m
//  TTjianbao
//
//  Created by jiangchao on 2019/3/20.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHRefreshGifHeader.h"

@implementation JHRefreshGifHeader

- (void)prepare
{
    [super prepare];
    self.automaticallyChangeAlpha=YES;
    self.lastUpdatedTimeLabel.hidden = YES;
    self.stateLabel.hidden = YES;
    
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
      [idleImages addObject:[UIImage imageNamed:@"loading00011"]];
    for (NSUInteger i =0; i<=11; i++) {
         UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading000%zd",i]];
        [idleImages addObject:image];
    }
    // [idleImages addObject:[UIImage imageNamed:@"loading00010"]];
    
    // 设置即将刷新状态的动画图片（一松开就会刷新的状态）
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i =12; i<=23; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading000%zd",i]];
//        NSLog(@"%@",[NSString stringWithFormat:@"loading000%zd",i]);
        [refreshingImages addObject:image];
    }
    
    // [self setImages:idleImages forState:MJRefreshStatePulling];
     [self setImages:idleImages forState:MJRefreshStateIdle];
    // 设置正在刷新状态的动画图片

     [self setImages:refreshingImages   forState:MJRefreshStateRefreshing];
}

///解决下拉刷新后顶部留白的问题

- (void)placeSubviews {
    [super placeSubviews];
    self.mj_y = - self.mj_h - self.ignoredScrollViewContentInsetTop;
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        if ([self.scrollView isKindOfClass:[UITableView class]]) {
//            UITableView *tableView = (UITableView *)self.scrollView;
//            tableView.estimatedRowHeight = 0.1;
//            tableView.estimatedSectionFooterHeight = 0.1;
//            tableView.estimatedSectionHeaderHeight = 0.1;
//        }
    }
}


@end
