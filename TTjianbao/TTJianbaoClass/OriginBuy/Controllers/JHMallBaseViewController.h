//
//  JHMallBaseViewController.h
//  TTjianbao
//
//  Created by jiangchao on 2020/7/30.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JHBaseViewExtController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JHMallBaseViewController : JHBaseViewExtController
@property (nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic,assign) BOOL isAutoScroll;
@property (nonatomic, assign) NSInteger currentIndex;

- (void)loadData; //加载新数据
-(void)refreshData:(NSInteger)currentIndex;   //触发下拉刷新
-(void)srollToTop;  //滚动到顶部
-(BOOL)isRefreshing;   //判断是否处于刷新中
-(void)shutdownPlayStream;  //关闭拉流
-(void)beginPullSteam;    //开始拉流
@end

NS_ASSUME_NONNULL_END
