//
//  JHC2CClassViewController.m
//  TTjianbao
//
//  Created by hao on 2021/5/27.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CClassViewController.h"
#import "JHEasyPollSearchBar.h"
#import "JHNewPublishChannelCell.h"
#import "JHNewPublishSubCateCollectionCell.h"
#import "JHNewPublishSubHeaderView.h"
#import "ZQSearchViewController.h"
#import "JHC2CClassResultViewController.h"
#import "JHC2CSearchResultViewController.h"

#import "JHPublishCateModel.h"
#import "TTjianbaoHeader.h"
#import "JHC2CClassBusiness.h"
#import "JHDiscoverSearchViewModel.h"


@interface JHC2CClassViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, ZQSearchViewDelegate>
@property (nonatomic, strong) NSArray <JHNewStoreTypeTableCellViewModel*>*dataArray;
@property(nonatomic, strong)  JHEasyPollSearchBar * searchBar;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UICollectionView *rightCollectionView;

@property(nonatomic, assign) BOOL collectionScrolling;

@end

@implementation JHC2CClassViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //曝光埋点
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:@{
        @"page_name":@"集市商品分类页"
    } type:JHStatisticsTypeSensors];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setItems];
    [self layoutItems];
    [self loadData];
}

#pragma mark - UI
- (void)setItems {
    //搜索框
    [self.jhNavView addSubview:self.searchBar];
    //左边一级分类
    [self.view addSubview:self.leftTableView];
    //右边二级分类
    [self.view addSubview:self.rightCollectionView];
    
}
- (void)layoutItems{
    [self.jhLeftButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.jhNavView);
        make.left.equalTo(self.jhNavView).offset(12);
        make.size.mas_equalTo(CGSizeMake(30, UI.navBarHeight));
    }];
    [self.searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.jhLeftButton.mas_right);
        make.centerY.equalTo(self.jhLeftButton);
        make.height.equalTo(@30);
        make.right.equalTo(self.jhNavView).offset(-12);
    }];
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.equalTo(@0);
        make.top.equalTo(self.jhNavView.mas_bottom);
        make.width.equalTo(@90);
    }];
    [self.rightCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTableView.mas_right);
        make.right.bottom.equalTo(@0);
        make.top.equalTo(self.leftTableView);
    }];
}

#pragma mark - Action
//进入查看全部
- (void)enterAlltypeWithSection:(NSInteger)section{
    JHNewStoreTypeTableCellViewModel *viewModel = self.dataArray[section];
    JHNewStoreTypeModel *model = viewModel.dataModel;
    
    JHC2CClassResultViewController *listVC = [[JHC2CClassResultViewController alloc] init];
    listVC.cateId = [NSString stringWithFormat:@"%ld",(long)model.ID];
    listVC.cateName = model.cateName;
    listVC.cateLevel = @"1";//一级分类
    [self.navigationController pushViewController:listVC animated:YES];

}

//进入搜索页
- (void)enterSearchVC {
    JHC2CSearchResultViewController *resultVC = [[JHC2CSearchResultViewController alloc]init];
    ZQSearchFrom from = ZQSearchFromC2C;
    ZQSearchViewController *vc = [[ZQSearchViewController alloc] initSearchViewWithFrom:from resultController:resultVC];
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:NO];
}



#pragma mark - LoadData
- (void)loadData {
    //获取热搜热词列表
    [JHDiscoverSearchViewModel getC2CHotKeyHordData:^(id  _Nullable respObj, BOOL hasError) {
        if (!hasError) {
            RequestModel * respondObject = (RequestModel *)respObj;
            NSArray *hotKeys = [JHHotWordModel mj_objectArrayWithKeyValuesArray:respondObject.data].copy;
            self.searchBar.placeholderArray = [NSMutableArray arrayWithArray:hotKeys];
        }
    }];
    //获取分类列表
    [JHC2CClassBusiness requestClassListCompletion:^(NSError * _Nullable error, NSArray<JHNewStoreTypeTableCellViewModel *> * _Nullable models) {
        if (!error) {
            self.dataArray = models;
            [self reloadData];
        }
    }];
    
}
- (void)reloadData{
    //增加底部空白
    JHNewStoreTypeTableCellViewModel *model = self.dataArray.lastObject;
    CGFloat  addHeight = fabs(self.rightCollectionView.mj_h - 50 - ceil(model.children.count/3.0) * 100);
    self.rightCollectionView.contentInset = UIEdgeInsetsMake(0, 0, addHeight, 0);
    [self.leftTableView reloadData];
    [self.rightCollectionView reloadData];
    if (self.dataArray.count > 0) {
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    }

}

#pragma mark - Delegate
#pragma mark - ZQSearchViewDelegate
- (void)searchFuzzyResultWithKeyString:(NSString *)keyString Data:(id<ZQSearchData>)data resultController:(UIViewController *)resultController From:(ZQSearchFrom)from{
    JHC2CSearchResultViewController *vc = (JHC2CSearchResultViewController *)resultController;
    [vc refreshSearchResult:keyString from:from keywordSource:data];
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.rightCollectionView] && !self.collectionScrolling) {
        NSArray<NSIndexPath *> *arr =  [self.rightCollectionView indexPathsForVisibleSupplementaryElementsOfKind:UICollectionElementKindSectionHeader];
        if (arr.count == 0) {return;}
        arr = [arr sortedArrayUsingComparator:^NSComparisonResult(NSIndexPath * _Nonnull obj1, NSIndexPath*  _Nonnull obj2) {
            return  obj1.section < obj2.section ? NSOrderedAscending : NSOrderedDescending;
        }];
        NSIndexPath *path = [NSIndexPath indexPathForRow:arr.firstObject.section inSection:0];
        if(self.leftTableView.indexPathForSelectedRow.row == path.row){return;}
        [self.leftTableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
}


#pragma mark -- UICollectionViewDatasource and delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    JHNewStoreTypeTableCellViewModel *model = self.dataArray[section];
    return model.children.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        JHNewPublishSubHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([JHNewPublishSubHeaderView class]) forIndexPath:indexPath];
        JHNewStoreTypeTableCellViewModel *viewModel = self.dataArray[indexPath.section];
        view.section = indexPath.section;
        @weakify(self);
        [view setShowAllActionBlock:^(NSInteger section) {
            @strongify(self);
            [self enterAlltypeWithSection:section];
        }];
        view.title = viewModel.cateName;
        return view;
    } else {
        return nil;
    }
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHNewPublishSubCateCollectionCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHNewPublishSubCateCollectionCell class]) forIndexPath:indexPath];
    JHNewStoreTypeTableCellViewModel *viewModel = self.dataArray[indexPath.section];
    if (viewModel.children.count > indexPath.row) {
        collectionCell.viewModel = viewModel.children[indexPath.row];
    }
    return collectionCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dataArray.count > indexPath.section && self.dataArray[indexPath.section].children.count > indexPath.row) {
        JHNewStoreTypeTableCellViewModel *viewModel = self.dataArray[indexPath.section].children[indexPath.row];
        JHNewStoreTypeModel *model = viewModel.dataModel;
        
        JHC2CClassResultViewController *listVC = [[JHC2CClassResultViewController alloc]init];
        listVC.cateId = [NSString stringWithFormat:@"%ld",(long)model.ID];
        listVC.cateName = model.cateName;
        listVC.cateLevel = @"2";//二级分类
        [self.navigationController pushViewController:listVC animated:YES];

    }
}


#pragma mark -- <UITableViewDelegate and UITableViewDataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JHNewPublishChannelCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([JHNewPublishChannelCell class]) forIndexPath:indexPath];
    JHNewStoreTypeTableCellViewModel *viewModel = self.dataArray[indexPath.row];
    cell.viewModel = viewModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.dataArray[indexPath.row].children.count || (self.rightCollectionView.contentSize.height < self.rightCollectionView.mj_h)) {return;}
    [self.rightCollectionView layoutIfNeeded];
    UICollectionViewLayoutAttributes *attributes =[self.rightCollectionView layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.row]];
    CGRect rect = attributes.frame;
    CGPoint point = CGPointMake(0, rect.origin.y - 50);
    self.collectionScrolling = YES;
    self.leftTableView.userInteractionEnabled = NO;
    [self.rightCollectionView setContentOffset:point animated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.collectionScrolling = NO;
        self.leftTableView.userInteractionEnabled = YES;
    });
}


#pragma mark - Lazy

- (UITableView *)leftTableView{
    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.tableFooterView = [UIView new];
        _leftTableView.rowHeight = 50;
        _leftTableView.backgroundColor = HEXCOLOR(0xF8F8F8);
        [_leftTableView registerClass:[JHNewPublishChannelCell class] forCellReuseIdentifier:NSStringFromClass([JHNewPublishChannelCell class])];
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.showsHorizontalScrollIndicator = NO;
        _leftTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _leftTableView.contentInset = UIEdgeInsetsMake(0, 0, UI.bottomSafeAreaHeight, 0);
    }
    return _leftTableView;
}

- (UICollectionView *)rightCollectionView{
    if (!_rightCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(87, 100);
        layout.minimumLineSpacing = 1.0;
        layout.minimumInteritemSpacing = 1.0;
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
        layout.headerReferenceSize = CGSizeMake(ScreenW-self.leftTableView.width, 50);
        
        _rightCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _rightCollectionView.delegate = self;
        _rightCollectionView.dataSource = self;
        _rightCollectionView.showsVerticalScrollIndicator = NO;
        _rightCollectionView.contentInset = UIEdgeInsetsMake(0, 0, UI.bottomSafeAreaHeight, 0);
        [_rightCollectionView registerClass:[JHNewPublishSubCateCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([JHNewPublishSubCateCollectionCell class])];
        
        [_rightCollectionView registerClass:[JHNewPublishSubHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([JHNewPublishSubHeaderView class])];
        _rightCollectionView.backgroundColor = [UIColor whiteColor];
    }
    return _rightCollectionView;
}

- (JHEasyPollSearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [JHEasyPollSearchBar new];
        _searchBar.backgroundColor = kColorFFF;
        _searchBar.layer.borderColor = HEXCOLOR(0xFFD70F).CGColor;
        _searchBar.layer.borderWidth = 1.5;
        _searchBar.layer.cornerRadius = 15.0;
        _searchBar.layer.masksToBounds = YES;
        _searchBar.placeholder = @"翡翠吊坠";
        @weakify(self);
        _searchBar.didSelectedBlock = ^(NSInteger selectedIndex, BOOL isLeft) {
            @strongify(self);
            [self enterSearchVC];
        };
    }
    return _searchBar;
}



@end
