//
//  JHReportViewController.m
//  TTjianbao
//
//  Created by yaoyao on 2019/2/22.
//  Copyright © 2019年 Netease. All rights reserved.
//

#import "JHReportViewController.h"
#import "JHReportRelatedHeaderView.h"
#import "AppraisalVideoRecordMode.h"
#import "JHHomeCollectionViewCell.h"
#import "JHAppraisalDetailViewController.h"


@interface JHReportViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout> {
    CGFloat cellRate;
    CGFloat contentViewHeight;

}
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger pageNo;
@property (nonatomic, assign) NSInteger pageSize;
//@property (weak, nonatomic) JHReportRelatedHeaderView *headerView;
@property (strong, nonatomic)JHReporterDetailModel *model;

@end

@implementation JHReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    cellRate = 160/160.;
    contentViewHeight = 160 + 266/345.*ScreenW + 200/345.*ScreenW;
    self.view.backgroundColor = HEXCOLOR(0xeeeeee);
//    [self  initToolsBar];
//    [self.navbar setTitle:@"评估报告"];
//    self.navbar.titleLbl.textColor = HEXCOLOR(0x222222);
//    self.navbar.ImageView.hidden = YES;
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    self.navbar.backgroundColor = [UIColor clearColor];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    self.title = @"评估报告";
    self.jhTitleLabel.textColor = HEXCOLOR(0x222222);
    self.jhNavView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.collectionView];
    [self requestData];
    
}

- (void)backActionButton:(UIButton *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)requestData {
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/report/authoptional/reportDetail/video") Parameters:@{@"appraiseRecordId":self.appraiseRecordId} successBlock:^(RequestModel *respondObject) {
        self.model = [JHReporterDetailModel mj_objectWithKeyValues:respondObject.data];
        [self.collectionView reloadData];
        [self loadOneData];
        
    } failureBlock:^(RequestModel *respondObject) {
        
    }];
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight, ScreenW, ScreenH-UI.statusAndNavBarHeight) collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.delegate   = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [_collectionView registerClass:[JHHomeCollectionViewCell class] forCellWithReuseIdentifier:@"JHHomeCollectionViewCell"];
        [_collectionView registerNib:[UINib nibWithNibName:@"JHReportRelatedHeaderView" bundle:nil]             forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"JHReportRelatedHeaderView"];
    
        JHRefreshNormalFooter *footer = [JHRefreshNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        _collectionView.mj_footer = footer;
        
        
    }
    return _collectionView;
}

#pragma mark -
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHHomeCollectionViewCell" forIndexPath:indexPath];
    cell.reporterDetailModel = self.dataArray[indexPath.row];
    [cell setCellIndex:indexPath.row];
    
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        JHReportRelatedHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"JHReportRelatedHeaderView" forIndexPath:indexPath];
        headerView.model = self.model;

        
        return headerView;
        
    }
    return nil;
    
}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    
    view.layer.zPosition = 0.0;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    
    return CGSizeMake(ScreenW, contentViewHeight);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JHReporterDetailModel *model = self.dataArray[indexPath.row];
    JHReportViewController *vc = [[JHReportViewController alloc] init];
    vc.appraiseRecordId = model.appraiseId;
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark ---- UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return (CGSize){(self.view.width)/2,(self.view.width)/2*cellRate+65};
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0,0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}


- (void)loadOneData {
    _pageNo = 0;
    _pageSize = 10;
    
    [self requestListData];
}


- (void)loadMoreData {
    _pageNo ++;
    [self requestListData];
}
- (void)requestListData {
    if (!_model) {
        return;
    }
    NSDictionary *parameters = @{@"pageNo":@(_pageNo),@"pageSize":@(_pageSize),@"appraiseId":_model.appraiseId};
    NSString *url = FILE_BASE_STRING(@"/appraiseRecord/video/similar");
    
    [HttpRequestTool getWithURL:url Parameters:parameters successBlock:^(RequestModel *respondObject) {
        [self.collectionView.mj_footer endRefreshing];
        [self reloadData:respondObject.data];
        
    } failureBlock:^(RequestModel *respondObject) {
        [self.collectionView.mj_footer endRefreshing];
        
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        
    }];
    
    
}

- (void)reloadData:(NSMutableArray *)array {
    if (!array ||array.count == 0) {
        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        return;
    }
    NSArray *arr = [JHReporterDetailModel mj_objectArrayWithKeyValuesArray:array];
    if (_pageNo == 0) {
        self.dataArray = [NSMutableArray arrayWithArray:arr];
    }
    else
        [self.dataArray addObjectsFromArray:arr];
    
    [self.collectionView reloadData];
}


@end
