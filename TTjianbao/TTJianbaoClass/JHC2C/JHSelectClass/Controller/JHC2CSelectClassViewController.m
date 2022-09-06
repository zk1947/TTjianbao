//
//  JHC2CSelectClassViewController.m
//  TTjianbao
//
//  Created by hao on 2021/5/28.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CSelectClassViewController.h"
#import "JHNewPublishChannelCell.h"
#import "JHNewPublishSubCateCollectionCell.h"
#import "JHC2CSelectClassSubHeaderView.h"
#import "JHC2CClassBusiness.h"
#import "JHC2CUploadProductController.h"
#import "CommAlertView.h"

@interface JHC2CSelectClassViewController ()<UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, copy) NSArray <JHNewStoreTypeTableCellViewModel*>*dataArray;
@property (nonatomic, strong) JHNewStoreTypeTableCellViewModel *subStoreModel;
@property (nonatomic, strong) UITableView *leftTableView;
@property (nonatomic, strong) UICollectionView *rightCollectionView;
@property(nonatomic, assign) BOOL collectionScrolling;
@property (nonatomic, strong) CommAlertView *sendAlert;
@property (nonatomic, strong) CommAlertView *sendAlert2;

@property (nonatomic, strong) JHNewStoreTypeTableCellViewModel *indexOneModel;
@property (nonatomic, strong) JHNewStoreTypeTableCellViewModel *indexThreeChildrenModel;

@end

@implementation JHC2CSelectClassViewController
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //曝光埋点
    [JHAllStatistics jh_allStatisticsWithEventId:@"appPageView" params:@{
        @"page_name":@"集市上传选择分类页"
    } type:JHStatisticsTypeSensors];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择上传分类";
    
    [self setupUI];
    
    [self loadData];
}

#pragma mark - UI
- (void)setupUI{
    UIView *headerView = [UIView jh_viewWithColor:HEXCOLOR(0xFFFAF2) addToSuperview:self.view];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
        make.left.right.equalTo(self.view);
        make.height.mas_offset(44);
    }];
    UILabel *descriptionLabel = [UILabel jh_labelWithText:@"请确保商品合法性，违规商品禁止交易。" font:12 textColor:HEXCOLOR(0xFF6A00) textAlignment:NSTextAlignmentCenter addToSuperView:headerView];
    [descriptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(headerView);
    }];
    
    //左侧一级分类
    [self.view addSubview:self.leftTableView];
    [self.leftTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_bottom);
        make.left.bottom.equalTo(self.view);
        make.width.mas_offset(90);
    }];
    //右侧子分类
    [self.view addSubview:self.rightCollectionView];
    [self.rightCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.leftTableView);
        make.right.bottom.equalTo(self.view);
        make.left.equalTo(self.leftTableView.mas_right);
    }];
    
    
}

#pragma mark - LoadData
- (void)loadData {
    [JHC2CClassBusiness requestSelectClassListWithParams:@{@"businessLineType":@"C2C"} Completion:^(NSError * _Nullable error, NSArray<JHNewStoreTypeTableCellViewModel *> * _Nullable models) {
        if (!error) {
            self.dataArray = models;

            JHNewStoreTypeTableCellViewModel *model = self.dataArray.lastObject;
            CGFloat  addHeight = fabs(self.rightCollectionView.mj_h - 50 - ceil(model.children.count/3.0) * 100);
            self.rightCollectionView.contentInset = UIEdgeInsetsMake(0, 0, addHeight, 0);
            [self.leftTableView reloadData];
            [self.rightCollectionView reloadData];
            if (self.dataArray.count > 0) {
                [self.leftTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
            }
            
            //判断是否有草稿
            NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"sendData"];
            if (dic) {
                [self.sendAlert show];
            }
            
        }
    }];

}

///草稿提示框
- (CommAlertView *)sendAlert{
    if (!_sendAlert) {
        CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"提示" andDesc:@"发现您有一个未发布完成的宝贝，是否继续发布？" cancleBtnTitle:@"发布新宝贝" sureBtnTitle:@"继续发布"];
        @weakify(self);
        //发布新宝贝
        alert.cancleHandle = ^{
            @strongify(self);
            //删除草稿
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sendData"];
        };
        //继续发布
        alert.handle = ^{
            @strongify(self);
            //去草稿发布
            [self gotoSendPage];
        };
        _sendAlert = alert;
    }
    return _sendAlert;
}

///草稿提示框
- (CommAlertView *)sendAlert2{
    if (!_sendAlert2) {
        CommAlertView *alert = [[CommAlertView alloc]initWithTitle:@"提示" andDesc:@"发现您有一个未发布完成的宝贝，是否继续发布？" cancleBtnTitle:@"发布新宝贝" sureBtnTitle:@"继续发布"];
        @weakify(self);
        //发布新宝贝
        alert.cancleHandle = ^{
            @strongify(self);
            //删除草稿
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sendData"];
            
            //跳页
            JHC2CUploadProductController *uploadProductVC = [[JHC2CUploadProductController alloc] init];
            uploadProductVC.firstCategoryId = [NSString stringWithFormat:@"%ld",(long)_indexOneModel.ID];
            uploadProductVC.firstCategoryName = _indexOneModel.cateName;
            uploadProductVC.secondCategoryId = [NSString stringWithFormat:@"%ld",(long)_indexThreeChildrenModel.pid];
            uploadProductVC.secondCategoryName = _indexOneModel.cateName;
            uploadProductVC.thirdCategoryId = [NSString stringWithFormat:@"%ld",(long)_indexThreeChildrenModel.ID];
            uploadProductVC.thirdCategoryName = _indexThreeChildrenModel.cateName;
            [self.navigationController pushViewController:uploadProductVC animated:YES];
            
        };
        //继续发布
        alert.handle = ^{
            @strongify(self);
            //去草稿发布
            [self gotoSendPage];
        };
        _sendAlert2 = alert;
    }
    return _sendAlert2;
}


- (void)gotoSendPage{
    NSDictionary *localDic = [[NSUserDefaults standardUserDefaults] objectForKey:@"sendData"];
    JHC2CUploadProductController *uploadProductVC = [[JHC2CUploadProductController alloc] init];
    uploadProductVC.firstCategoryId = localDic[@"section0"][@"firstCategoryId"];
    uploadProductVC.firstCategoryName = localDic[@"section0"][@"firstCategoryName"];
    uploadProductVC.secondCategoryId = localDic[@"section0"][@"secondCategoryId"];
    uploadProductVC.secondCategoryName = localDic[@"section0"][@"secondCategoryName"];
    uploadProductVC.thirdCategoryId = localDic[@"section0"][@"thirdCategoryId"];
    uploadProductVC.thirdCategoryName = localDic[@"section0"][@"thirdCategoryName"];
    [self.navigationController pushViewController:uploadProductVC animated:YES];
}

#pragma mark - Action


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
        JHC2CSelectClassSubHeaderView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([JHC2CSelectClassSubHeaderView class]) forIndexPath:indexPath];
        JHNewStoreTypeTableCellViewModel *viewModel = self.dataArray[indexPath.section];
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
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    _indexOneModel = self.dataArray[indexPath.section];
    _indexThreeChildrenModel = _indexOneModel.children[indexPath.row];
    //判断是否有草稿
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:@"sendData"];
    if (dic) {
        [self.sendAlert2 show];
    }else{
        JHNewStoreTypeTableCellViewModel *oneModel = self.dataArray[indexPath.section];
        JHNewStoreTypeTableCellViewModel *threeChildrenModel = oneModel.children[indexPath.row];
    
        JHC2CUploadProductController *uploadProductVC = [[JHC2CUploadProductController alloc] init];
        uploadProductVC.firstCategoryId = [NSString stringWithFormat:@"%ld",(long)oneModel.ID];
        uploadProductVC.firstCategoryName = oneModel.cateName;
        uploadProductVC.secondCategoryId = [NSString stringWithFormat:@"%ld",(long)threeChildrenModel.pid];
        uploadProductVC.secondCategoryName = oneModel.cateName;
        uploadProductVC.thirdCategoryId = [NSString stringWithFormat:@"%ld",(long)threeChildrenModel.ID];
        uploadProductVC.thirdCategoryName = threeChildrenModel.cateName;
        [self.navigationController pushViewController:uploadProductVC animated:YES];
    }
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
        _leftTableView.contentInset = UIEdgeInsetsMake(0, 0, UI.bottomSafeAreaHeight, 0);
        _leftTableView.showsVerticalScrollIndicator = NO;
        _leftTableView.showsHorizontalScrollIndicator = NO;
        _leftTableView.separatorStyle = UITableViewCellSelectionStyleNone;
        [_leftTableView registerClass:[JHNewPublishChannelCell class] forCellReuseIdentifier:NSStringFromClass([JHNewPublishChannelCell class])];

    }
    return _leftTableView;
}

- (UICollectionView *)rightCollectionView{
    if (!_rightCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.headerReferenceSize = CGSizeMake(ScreenWidth-self.leftTableView.width, 50);        
        flowLayout.itemSize = CGSizeMake(87, 100);
        flowLayout.minimumLineSpacing = 1.0;
        flowLayout.minimumInteritemSpacing = 1.0;
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
        _rightCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _rightCollectionView.delegate = self;
        _rightCollectionView.dataSource = self;
        _rightCollectionView.showsVerticalScrollIndicator = NO;
        _rightCollectionView.showsHorizontalScrollIndicator = NO;
        _rightCollectionView.contentInset = UIEdgeInsetsMake(0, 0, UI.bottomSafeAreaHeight, 0);
        _rightCollectionView.backgroundColor = [UIColor whiteColor];

        [_rightCollectionView registerClass:[JHNewPublishSubCateCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([JHNewPublishSubCateCollectionCell class])];
        [_rightCollectionView registerClass:[JHC2CSelectClassSubHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([JHC2CSelectClassSubHeaderView class])];
        
    }
    return _rightCollectionView;
}

@end
