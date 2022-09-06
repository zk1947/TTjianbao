//
//  JHRecycleNodeGuideCell.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//
#define kMaxSection 100

#import "JHRecycleNodeGuideCell.h"
#import "JHRecycleGuideCollectionViewCell.h"
#import "JHPageControl.h"
#import "JHRecycleItemViewModel.h"
#import "JHRecycleDetailViewController.h"
#import "JHRecycleOrderDetailViewController.h"

@interface JHRecycleNodeGuideCell ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray *dataArray;
@property (nonatomic, strong) NSMutableArray *cellData;//模型数组
//@property (nonatomic, assign) NSTimeInterval duringTime;// 间隔时间，0表示不自动滚动
//@property (nonatomic, strong) NSTimer *timer;
//@property (nonatomic, strong) NSLock *mLock;

@property (nonatomic, strong) JHPageControl *pageControl;

@end

@implementation JHRecycleNodeGuideCell

//- (void)dealloc{
//    NSLog(@"dealloc==%@=释放了～～",[self class]);
//    [self closeTimer];
//}


#pragma mark  - UI

- (void)configUI{
    [self.backView addSubview:self.collectionView];
    [self.backView addSubview:self.pageControl];

//    self.duringTime = 4;
//    self.mLock = [[NSLock alloc] init];

}


#pragma mark  - LoadData
- (void)bindViewModel:(id)dataModel{
    JHRecycleItemViewModel *itemViewModel = dataModel;
    
    self.dataArray = itemViewModel.dataModel;
    self.pageControl.hidden = self.dataArray.count <= 1;
    self.pageControl.numberOfPages = self.dataArray.count;
    
    // 生成数据源
    self.cellData = [[NSMutableArray alloc] init];
    if (self.dataArray.count > 1) {
//        [self.mLock lock];
//        [self closeTimer];

        for (int i=0; i<kMaxSection; i++) {
            for (int j=0; j<self.dataArray.count; j++) {
                [self.cellData addObject:@(j)];
            }
        }
        [self.collectionView reloadData];
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:(kMaxSection/2) * self.dataArray.count inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];

//        [self openTimer];
//        [self.mLock unlock];
    }else{
        [self.cellData addObject:@(0)];
    }
}

#pragma mark  - Action
///去掉自动滚动
//- (void)closeTimer {
//    if (self.timer) {
//        [self.timer invalidate];
//        self.timer = nil;
//    }
//}
//- (void)openTimer {
//    if (self.duringTime > 0.8) {
//        @weakify(self)
//        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.duringTime repeats:YES block:^(NSTimer * _Nonnull timer) {
//            @strongify(self)
//            [self onTimer];
//        }];
//        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
//    }
//}
//- (void)onTimer {
//    if (self.cellData.count > 0) {
//        NSArray *array = [self.collectionView indexPathsForVisibleItems];
//        if (array.count == 0) return ;
//
//        NSIndexPath *indexPath = array[0];
//        NSInteger row = indexPath.row;
//
//        if (row % self.dataArray.count == 0) {
//            row = (kMaxSection/2) * self.dataArray.count;  /// 重新定位
//            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
//        }
//        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:row + 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
//
//        [self.pageControl setCurrentPage:(row + 1) % self.dataArray.count];
//    }
//}

#pragma mark  - 代理
#pragma mark - UICollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cellData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHRecycleGuideCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHRecycleGuideCollectionViewCell class]) forIndexPath:indexPath];
    NSInteger index = [self.cellData[indexPath.row] integerValue];
    JHHomeOrderInfoListModel *orderListModel = self.dataArray[index];
    [cell bindViewModel:orderListModel params:nil];


    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    NSInteger index = [self.cellData[indexPath.row] integerValue];
    JHHomeOrderInfoListModel *orderListModel = self.dataArray[index];
    
    NSString *typeStr = @"";
    if (orderListModel.productStatus == 8) {//待确认报价
        JHRecycleDetailViewController *detailVC = [[JHRecycleDetailViewController alloc] init];
        detailVC.productId = orderListModel.productId;
        [JHRootController.currentViewController.navigationController pushViewController:detailVC animated:YES];
        typeStr = @"待确认交易";
    }else if (orderListModel.productStatus == 19){//待发货
        JHRecycleOrderDetailViewController *orderVC = [[JHRecycleOrderDetailViewController alloc] init];
        orderVC.orderId = orderListModel.orderId;
        [JHRootController.currentViewController.navigationController pushViewController:orderVC animated:YES];
        typeStr = @"待发货";
    }
    [JHAllStatistics jh_allStatisticsWithEventId:@"clickProcessNode" params:@{
        @"node_name":typeStr,
        @"page_position":@"recycleHome"
    } type:JHStatisticsTypeSensors];

}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int index = ((int)(scrollView.contentOffset.x / scrollView.frame.size.width)) % self.dataArray.count;
    // 动画停止, 重新定位到第50组模型
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:(kMaxSection/2) * self.dataArray.count + index inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];

}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int index = ((int)(scrollView.contentOffset.x / scrollView.frame.size.width)) % self.dataArray.count;
    // 设置 PageControl
    [self.pageControl setCurrentPage:index];
}


#pragma mark  - 懒加载
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(ScreenWidth, 80);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.minimumInteritemSpacing = 0;

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 80) collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.alwaysBounceHorizontal = YES;
        _collectionView.alwaysBounceVertical = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[JHRecycleGuideCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHRecycleGuideCollectionViewCell class])];
    }
    return _collectionView;
}
- (JHPageControl *)pageControl{
    if (_pageControl == nil) {
        _pageControl = [[JHPageControl alloc] initWithFrame:CGRectMake(0, 80-15, ScreenWidth-24, 10)];
        _pageControl.numberOfPages = 0; //点的总个数
        _pageControl.pointSize = 4;
        _pageControl.otherMultiple = 1; //其他点w是h的倍数(圆点)
        _pageControl.currentMultiple = 3; //选中点的宽度是高度的倍数(设置长条形状)
        _pageControl.pageControlAlignment = JHPageControlAlignmentMiddle; //居中显示
        _pageControl.otherColor = kColorEEE; //非选中点的颜色
        _pageControl.currentColor = kColorMain; //选中点的颜色
    }
    return _pageControl;
}
- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}
@end
