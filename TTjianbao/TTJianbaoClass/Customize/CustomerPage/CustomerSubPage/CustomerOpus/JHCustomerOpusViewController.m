//
//  JHCustomerOpusViewController.m
//  TTjianbao
//
//  Created by user on 2020/10/26.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomerOpusViewController.h"
#import "JHCustomerOpusCollectionViewCell.h"
#import "UIScrollView+JHEmpty.h"
#import "UIScrollView+MJRefresh.h"
#import "JHCustomerDescInProcessViewController.h"

@interface JHCustomerOpusViewController () <
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>
@property (nonatomic,   copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UICollectionView *contentCollectionView;
@property (nonatomic, strong) NSMutableArray   *dataSourceArray;
@property (nonatomic, assign) NSInteger pageIndex;
@end

@implementation JHCustomerOpusViewController
- (void)dealloc {
    NSLog(@"%s",__func__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0xF5F6FA);
    [self removeNavView];
    self.pageIndex = 0;
    [self setupViews];
    [self loadData];
    
//    @weakify(self);
//    [self.contentCollectionView jh_headerWithRefreshingBlock:^{
//        @strongify(self);
//        [self loadData];
//    } footerWithRefreshingBlock:^{
//        @strongify(self);
//        [self loadMoreData];
//    }];
//
    @weakify(self);
    self.contentCollectionView.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self loadMoreData];
    }];
    
}

- (void)loadData {
    NSInteger customerId = [self.roomModel.anchorId integerValue];
//    NSInteger customizeFeeId = 0;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
        @"customerId":@(customerId),
//        @"customizeFeeId":@(customizeFeeId),
        @"pageIndex":@(self.pageIndex),
        @"pageSize":@(20)
    }];
    @weakify(self);
    NSString *url = FILE_BASE_STRING(@"/anon/appraisal/customizeWorks/list");
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        [JHDispatch ui:^{
            @strongify(self);
            [self.dataSourceArray removeAllObjects];
            self.dataSourceArray = [JHCustomerWorksListInfo mj_objectArrayWithKeyValuesArray:respondObject.data];
            if (self.dataSourceArray.count == 0) {
                [self.contentCollectionView jh_reloadDataWithEmputyView];
                self.contentCollectionView.mj_footer.hidden = YES;
                return;
            }
            [self.contentCollectionView reloadData];
            if (self.dataSourceArray.count<20) {
                [self.contentCollectionView jh_footerStatusWithNoMoreData:YES];
                self.contentCollectionView.mj_footer.hidden =YES;
            } else {
                self.pageIndex ++;
                [self.contentCollectionView jh_footerStatusWithNoMoreData:NO];
                self.contentCollectionView.mj_footer.hidden = NO;
            }
        }];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [JHDispatch ui:^{
            @strongify(self);
            [self.contentCollectionView jh_reloadDataWithEmputyView];
            self.contentCollectionView.mj_footer.hidden=YES;
        }];
    }];
}

- (void)loadMoreData {
    NSInteger customerId = [self.roomModel.anchorId integerValue];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:@{
        @"customerId":@(customerId),
        @"pageIndex":@(self.pageIndex),
        @"pageSize":@(20)
    }];
    @weakify(self);
    NSString *url = FILE_BASE_STRING(@"/anon/appraisal/customizeWorks/list");
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        [JHDispatch ui:^{
            @strongify(self);
            [self.dataSourceArray addObjectsFromArray:[JHCustomerWorksListInfo mj_objectArrayWithKeyValuesArray:respondObject.data]];
            [self.contentCollectionView reloadData];
            self.pageIndex ++;
            if ([JHCustomerWorksListInfo mj_objectArrayWithKeyValuesArray:respondObject.data].count<20) {
                [self.contentCollectionView jh_footerStatusWithNoMoreData:YES];
                self.contentCollectionView.mj_footer.hidden =YES;
            } else {
                [self.contentCollectionView jh_footerStatusWithNoMoreData:NO];
                self.contentCollectionView.mj_footer.hidden = NO;
            }
        }];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [JHDispatch ui:^{
            @strongify(self);
            [self.contentCollectionView jh_footerStatusWithNoMoreData:YES];
            self.contentCollectionView.mj_footer.hidden = YES;
        }];
    }];
}




- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

- (void)setupViews {
    UICollectionViewFlowLayout *layout                   = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing                       = 5.f;
    layout.minimumLineSpacing                            = 5.f;
    layout.scrollDirection                               = UICollectionViewScrollDirectionVertical;
    UICollectionView *contentCollectionView              = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    contentCollectionView.backgroundColor                = HEXCOLOR(0xF5F6FA);
    contentCollectionView.delegate                       = self;
    contentCollectionView.dataSource                     = self;
    contentCollectionView.showsVerticalScrollIndicator   = NO;
    [self.view addSubview:contentCollectionView];
    self.contentCollectionView                           = contentCollectionView;

    [contentCollectionView registerClass:[JHCustomerOpusCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHCustomerOpusCollectionViewCell class])];
    [contentCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(5.f, 10.f, 10.f, 10.f));
    }];
}

#pragma mark scrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
    !self.scrollCallback ?: self.scrollCallback(scrollView);
    NSLog(@"%lf",scrollView.contentOffset.y);
}

#pragma mark - JXPagingViewListViewDelegate
- (UIView *)listView {
    return self.view;
}

- (UIScrollView *)listScrollView {
    return self.contentCollectionView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Delegate DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHCustomerOpusCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHCustomerOpusCollectionViewCell class]) forIndexPath:indexPath];
    [cell setViewModel:self.dataSourceArray[indexPath.row]];
    return cell;
}

#pragma mark - FlowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
   return CGSizeMake((ScreenWidth - 25.f)/2.f, (ScreenWidth - 25.f)/2.f + 63.f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JHCustomerWorksListInfo *infoModel = self.dataSourceArray[indexPath.row];
    if (infoModel) {
        JHCustomerDescInProcessViewController *vc = [[JHCustomerDescInProcessViewController alloc] init];
        vc.customizeOrderId = infoModel.customizeOrderId;
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    }
}


@end
