//
//  JHNewShopDetailClassView.m
//  TTjianbao
//
//  Created by hao on 2021/7/29.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewShopDetailClassView.h"
#import "JHNewPublishChannelCell.h"
#import "JHNewPublishSubCateCollectionCell.h"
#import "JHNewPublishSubHeaderView.h"
#import "JHNewShopClassResultViewController.h"

//#import "JHPublishCateModel.h"
//#import "TTjianbaoHeader.h"
#import "JHNewStoreTypeTableCellViewModel.h"

@interface JHNewShopDetailClassView ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UICollectionView *rightCollectionView;
@property (nonatomic, strong) NSArray <JHNewStoreTypeTableCellViewModel*>*dataArray;
@property(nonatomic, assign) BOOL collectionScrolling;

@end

@implementation JHNewShopDetailClassView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubviews];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.equalTo(self);
        make.width.equalTo(@90);
    }];
    [self.rightCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftTableView.mas_right);
        make.right.bottom.equalTo(self);
        make.top.equalTo(self.leftTableView);
    }];
    
    [self jh_cornerRadius:10.0 rectCorner:UIRectCornerTopLeft|UIRectCornerTopRight bounds:self.bounds];
}

#pragma mark - UI
- (void)initSubviews{
    //左边一级分类
    [self addSubview:self.leftTableView];
    //右边二级分类
    [self addSubview:self.rightCollectionView];
    
}

#pragma mark - LoadData
- (void)setShopInfoModel:(JHNewShopDetailInfoModel *)shopInfoModel{
    _shopInfoModel = shopInfoModel;
    
    [self loadData];
}
- (void)loadData {
    //获取分类列表
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/api/mall/frontCate/listFrontCateTreeByShopId") Parameters:@{@"shopId":self.shopInfoModel.shopId} requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        NSMutableArray<JHNewStoreTypeModel* > *modeArr = [JHNewStoreTypeModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        if (modeArr) {
            NSMutableArray *viewModelArr = [NSMutableArray arrayWithCapacity:0];
            [modeArr enumerateObjectsUsingBlock:^(JHNewStoreTypeModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [viewModelArr addObject:[JHNewStoreTypeTableCellViewModel viewModelWithNewStoryTypeModel:obj]];
            }];
            self.dataArray = viewModelArr;
            [self reloadData];

        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        JHTOAST(respondObject.message);
    }];
    
}
- (void)reloadData{
    //增加底部空白
    JHNewStoreTypeTableCellViewModel *model = self.dataArray.lastObject;
    CGFloat  addHeight = fabs(self.rightCollectionView.mj_h - 50 - ceil(model.children.count/3.0) * 100);
    self.rightCollectionView.contentInset = UIEdgeInsetsMake(0, 0, addHeight, 0);
    [self.leftTableView reloadData];
    //刷新数据，判断空页面
    [self.rightCollectionView jh_reloadDataWithEmputyView];
    if (self.dataArray.count > 0) {
        [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
    }

}


#pragma mark - Action
//进入查看全部
- (void)enterAlltypeWithSection:(NSInteger)section{
    JHNewStoreTypeTableCellViewModel *viewModel = self.dataArray[section];
    JHNewStoreTypeModel *model = viewModel.dataModel;
    
    JHNewShopClassResultViewController *classResultVC = [[JHNewShopClassResultViewController alloc] init];
    classResultVC.shopInfoModel = self.shopInfoModel;
    classResultVC.cateId = model.ID;
    [JHRootController.currentViewController.navigationController pushViewController:classResultVC animated:YES];

}

#pragma mark - Delegate
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


#pragma mark - UICollectionViewDatasource and delegate
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
        
        JHNewShopClassResultViewController *classResultVC = [[JHNewShopClassResultViewController alloc] init];
        classResultVC.shopInfoModel = self.shopInfoModel;
        classResultVC.cateId = model.ID;
        [JHRootController.currentViewController.navigationController pushViewController:classResultVC animated:YES];
    }
}


#pragma mark - UITableViewDelegate and UITableViewDataSource
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


@end
