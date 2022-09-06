//
//  JHRecycleHomeSubGoodsViewController.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleHomeSubGoodsViewController.h"
#import "JHRecycleHomeGoodsCollectionViewCell.h"
#import "YDRefreshFooter.h"
#import <MJRefresh.h>
#import "JHRefreshGifHeader.h"
#import "JHRecycleHomeGoodsViewModel.h"
#import "JHRecycleHomeGoodsModel.h"
#import "JHRecycleGoodsDetailInfoViewController.h"

@interface JHRecycleHomeSubGoodsViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) JHRecycleHomeGoodsViewModel *goodsViewModel;
@end

@implementation JHRecycleHomeSubGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    

    [self updateLoadData:YES];
    [self configData];
}

#pragma mark - UI

#pragma mark - LoadData
- (void)updateLoadData:(BOOL)isRefresh {
    NSMutableDictionary *dicData = [NSMutableDictionary dictionary];
    dicData[@"classifyId"] = self.productCateId.length>0 ? @([self.productCateId integerValue]) : @"";//分类ID
    dicData[@"imageType"] = @"m";//图片类型
    dicData[@"isRefresh"] = @(isRefresh);
    [self.goodsViewModel.updateGoodsListCommand execute:dicData];
}

- (void)loadMoreData{
    [self updateLoadData:NO];
}


- (void)configData{
    @weakify(self)
    //刷新数据
    [self.goodsViewModel.updateGoodsListSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView.mj_header endRefreshing];
        //刷新数据，判断空页面
        [self.collectionView jh_reloadDataWithEmputyView];
        //当数据超过一屏后才显示“已经到底”文案
        if (self.goodsViewModel.goodsListDataArray.count > 6) {
            ((YDRefreshFooter *)_collectionView.mj_footer).showNoMoreString = YES;
        }

    }];
    //更多数据
    [self.goodsViewModel.moreGoodsListSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.collectionView.mj_footer endRefreshing];
        [self.collectionView reloadData];

    }];
    //没有更多数据
    [self.goodsViewModel.noMoreDataSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
    }];
    //请求出错
    [self.goodsViewModel.errorRefreshSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        
    }];
}

#pragma mark - Action

#pragma mark - Delegate
#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.goodsViewModel.goodsListDataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHRecycleHomeGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHRecycleHomeGoodsCollectionViewCell class]) forIndexPath:indexPath];
    JHRecycleHomeGoodsResultListModel *goodsListModel = self.goodsViewModel.goodsListDataArray[indexPath.row];
    [cell bindViewModel:goodsListModel params:nil];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JHRecycleGoodsDetailInfoViewController *vc = [[JHRecycleGoodsDetailInfoViewController alloc] init];
    JHRecycleHomeGoodsResultListModel *goodsListModel = self.goodsViewModel.goodsListDataArray[indexPath.row];
    vc.productId = goodsListModel.productId;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Lazy

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 9;
        flowLayout.minimumInteritemSpacing = 9;
        flowLayout.itemSize = CGSizeMake((ScreenWidth-24-9)/2, (ScreenWidth-24-9)/2+37.f);
        flowLayout.sectionInset = UIEdgeInsetsMake(12, 12, 12, 12);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = HEXCOLOR(0xF5F5F8);
        [_collectionView registerClass:[JHRecycleHomeGoodsCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHRecycleHomeGoodsCollectionViewCell class])];
        
        @weakify(self)
        _collectionView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
            @strongify(self)
            [self updateLoadData:YES];
        }];
        _collectionView.mj_footer = [YDRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        
    }
    return _collectionView;
}
- (JHRecycleHomeGoodsViewModel *)goodsViewModel{
    if (!_goodsViewModel) {
        _goodsViewModel = [[JHRecycleHomeGoodsViewModel alloc] init];
    }
    return _goodsViewModel;
}
@end
