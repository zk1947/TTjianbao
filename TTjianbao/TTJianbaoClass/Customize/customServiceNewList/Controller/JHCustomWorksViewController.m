//
//  JHCostomWorksViewController.m
//  TTjianbao
//
//  Created by 王记伟 on 2020/10/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "JHCustomWorksViewController.h"
#import "JHMallGroupCategoryTitleView.h"
#import "JHMallCateModel.h"
#import "JHCustomNewCollectionViewCell.h"
#import "JHCustomWorksModel.h"
#import "JHRefreshNormalFooter.h"
#import "JHMallCateViewModel.h"
#import "JHEmptyCollectionCell.h"
#import "JHCustomerDescInProcessViewController.h"
#import "JHGrowingIO.h"

@interface JHCustomWorksViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    NSInteger PageNum;
    NSInteger pagesize;
}
@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
/** 列表头菜单*/
@property (nonatomic, strong) JHMallGroupCategoryTitleView *categoryTitleView;
/** 数据源*/
@property (nonatomic,strong) NSMutableArray <JHCustomWorksModel *> *dataModes;
@property (nonatomic, strong) NSArray *tagsArrays;
@property (nonatomic, assign) NSInteger customizeFeeId;
@property (nonatomic, copy) NSString *tagName;
@end

@implementation JHCustomWorksViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    pagesize = 20;
    PageNum = 0;;
    self.view.backgroundColor = [UIColor whiteColor];
    [self configUI];
//    [self loadTagsData];
//    [self loadListData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [JHHomeTabController setSubScrollView:self.collectionView];
}

- (void)configUI{
    [self.view addSubview:self.collectionView];
    [self.collectionView addSubview:self.categoryTitleView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}
- (void)reloadNewData{
    PageNum = 0;
    pagesize = 20;
    self.customizeFeeId = 0;
    self.tagName = @"推荐";
    [self loadTagsData];
    [self loadListData];
}

- (void)loadTagsData{
    NSString *url = FILE_BASE_STRING(@"/anon/customize/fee/works-template-list?filterFeeFlag=0");
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        NSArray *tagsArrays = [JHMallCateModel mj_objectArrayWithKeyValuesArray:respondObject.data[@"templates"]];
        self.tagsArrays = tagsArrays;
        [self.categoryTitleView setData:tagsArrays];
        if (tagsArrays.count > 0) {
            self.categoryTitleView.frame = CGRectMake(0, 0, ScreenW, 40);
        }
        self.categoryTitleView.selectIndex = 0;
        [self.categoryTitleView.collectionView reloadData];
        [self.collectionView reloadData];
    }
    failureBlock:^(RequestModel *respondObject) {
        
    }];
}

- (void)loadListData{
    NSString *url = FILE_BASE_STRING(@"/anon/appraisal/customizeWorks/list");
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageSize"] = @(pagesize);
    params[@"pageIndex"] = @(PageNum);
    params[@"customizeFeeId"] = @(self.customizeFeeId);
    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
    
        NSArray *arr = [JHCustomWorksModel mj_objectArrayWithKeyValuesArray:respondObject.data];
         if (PageNum == 0) {
             self.dataModes = [NSMutableArray arrayWithArray:arr];
         }else {
             [self.dataModes addObjectsFromArray:arr];
         }
        if (arr.count >= 20) {
            PageNum += 1;
            [self.collectionView.mj_footer resetNoMoreData];
            [self.collectionView.mj_footer endRefreshing];
            self.collectionView.mj_footer.hidden = NO;
        }else{
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
            self.collectionView.mj_footer.hidden = YES;
        }
         [self.collectionView reloadData];
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        [self.collectionView jh_endRefreshing];
//        [self.collectionView.mj_footer endRefreshing];
//        self.collectionView.mj_footer.hidden = YES;
    }];
}


#pragma mark -collectionview 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataModes.count > 0 ? self.dataModes.count: 1;  //每个section的Item数;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataModes.count == 0) {
        JHEmptyCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHEmptyCollectionCell class]) forIndexPath:indexPath];
        return cell;
    }
    
    JHCustomNewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHCustomNewCollectionViewCell class]) forIndexPath:indexPath];
    cell.model = self.dataModes[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataModes.count == 0) {
        return;
    }
    JHCustomWorksModel *model = self.dataModes[indexPath.row];
    JHCustomerDescInProcessViewController *Vc = [[JHCustomerDescInProcessViewController alloc] init];
    Vc.customizeOrderId = model.customizeOrderId;
    Vc.from = @"dz_works";
    [JHGrowingIO trackEventId:JHTrackCustomizelive_dz_works_in variables:@{@"from":@"dz_works",@"channelLocalId":model.customerId,@"tabname":self.tagName}];
    [self.navigationController pushViewController:Vc animated:YES];
}
#pragma mark - UICollectionViewLayoutDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataModes.count == 0) {
        return self.collectionView.size;
    }
    CGFloat itemW = (ScreenW - 25) / 2 ;
    return CGSizeMake(itemW, itemW + 63);
    
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return  UIEdgeInsetsMake(10, 10, 5, 10);
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableView = nil;
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableViewIdentifer" forIndexPath:indexPath];
            return header;
        }
        return reusableView;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
      if (self.tagsArrays.count > 0){
            return CGSizeMake(ScreenW, 40);
        }
    return CGSizeZero;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.scrollCallback(scrollView);
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@NO];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    BOOL scrollToScrollStop = !scrollView.tracking && !scrollView.dragging && !scrollView.decelerating;
    if (scrollToScrollStop) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    if (!decelerate) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
    }

}

- (void)scrollViewDidEndScroll {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
}

#pragma mark - JXPagingViewListViewDelegate
- (UIScrollView *)listScrollView {
    return self.collectionView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (UIView *)listView {
    return self.view;
}
#pragma mark -UI绘制
-(JHMallGroupCategoryTitleView *)categoryTitleView{
    if(_categoryTitleView == nil)
    {
        _categoryTitleView = [[JHMallGroupCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 0)];
        @weakify(self);
        _categoryTitleView.clickItemBlock = ^(JHMallCateViewModel * _Nonnull vm, NSInteger currentIndex) {
            @strongify(self);
            self.tagName = vm.name;
            [JHGrowingIO trackEventId:JHTrackCustomizelive_tab_works_click variables:@{@"tabname":vm.name}];
            NSString *string = vm.Id;
            self.customizeFeeId = string.integerValue;
            PageNum = 0;
            [self.dataModes removeAllObjects];
            [self loadListData];
        };
    }
    return _categoryTitleView;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;// 设置item的大小

        // 设置每个分区的 上左下右 的内边距
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = HEXCOLOR(0xf5f6fa);
        [_collectionView registerClass:[JHCustomNewCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHCustomNewCollectionViewCell class])];
        [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"UICollectionReusableViewIdentifer"];
        [_collectionView registerClass:[JHEmptyCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([JHEmptyCollectionCell class])];
        JH_WEAK(self)
        _collectionView.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
            JH_STRONG(self)
            [self loadListData];
        }];
    }
    return _collectionView;
}

- (NSMutableArray<JHCustomWorksModel *> *)dataModes{
    if (_dataModes == nil) {
        _dataModes = [NSMutableArray array];
    }
    return _dataModes;
}

@end
