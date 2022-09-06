//
//  JHGemmologistHistoryViewController.m
//  TTjianbao
//
//  Created by 王记伟 on 2020/11/10.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHGemmologistHistoryViewController.h"
#import "JHHomeCollectionViewCell.h"
#import "AppraisalVideoRecordMode.h"
#import "JHRefreshNormalFooter.h"
#import "JHAppraiseVideoViewController.h"
#import "NTESAudienceLiveViewController.h"
#import "JHDefaultCollectionViewCell.h"

#define cellRate (float)  1334./750.f //240/170

@interface JHGemmologistHistoryViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);
@property (nonatomic, strong) UICollectionView *collectionView;
/** 数据*/
@property (nonatomic, strong) NSMutableArray *historyDataList;


@property (nonatomic, assign) NSInteger pageNo;

@property (nonatomic, assign) NSInteger pageSize;

@end

@implementation JHGemmologistHistoryViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [JHGrowingIO trackEventId:JHTrackProfileAppraisalClick];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.pageNo = 0;
    self.pageSize = 20;
    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    [self loadData];
}

#pragma mark -加载数据
- (void)loadData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"pageNo"] = [NSString stringWithFormat:@"%ld", (long)self.pageNo];
    params[@"pageSize"] = [NSString stringWithFormat:@"%ld", (long)self.pageSize];
    params[@"anchorId"] = self.anchorId;
    [HttpRequestTool getWithURL:FILE_BASE_STRING(@"/appraiseRecord/anchor/video/authoptional") Parameters:params successBlock:^(RequestModel * _Nullable respondObject) {
        NSArray *array = [AppraisalVideoRecordMode mj_objectArrayWithKeyValuesArray:respondObject.data];
        if (array > 0) {
            self.pageNo += 1;
            [self.collectionView.mj_footer endRefreshing];
            [self.collectionView.mj_footer resetNoMoreData];
        }else{
            [self.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
        if (self.pageNo == 0) {
            self.historyDataList = [NSMutableArray arrayWithArray:array];
        }else{
            [self.historyDataList addObjectsFromArray:array];
        }
        [self.collectionView reloadData];
        } failureBlock:^(RequestModel * _Nullable respondObject) {
            [self.collectionView.mj_footer endRefreshing];
        }];
}
-(BOOL)isLgoin{
    
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:self complete:^(BOOL result) {
            if (result){
                
            }
        }];
        return  NO;
    }
    
    return  YES;
}
- (void)clickIndex:(NSInteger)index isLaud:(BOOL)laud{
    
    if ([self isLgoin]) {
    AppraisalVideoRecordMode * mode=[self.historyDataList objectAtIndex:index];
        NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/video/auth/viewerChangeStatusNew?channelRecordId=%@&status=%@"),mode.recordId,laud?@"0":@"1"];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"lauds"] = mode.lauds;
          [HttpRequestTool getWithURL:url Parameters:params successBlock:^(RequestModel *respondObject) {
              [SVProgressHUD dismiss];
              mode.isLaud=!laud;
              int count=[mode.lauds intValue];
              if (!laud) {
                   count=count+1;
                  mode.lauds=[NSString stringWithFormat:@"%d",count];
              }
              else{
                count=count-1;
                  mode.lauds=[NSString stringWithFormat:@"%d",count];
              }
          
    JHHomeCollectionViewCell *cell =(JHHomeCollectionViewCell*) [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
            
      [cell beginAnimation:mode];

        } failureBlock:^(RequestModel *respondObject) {
            [SVProgressHUD dismiss];
            [UITipView showTipStr:respondObject.message];
        }];
      //  [SVProgressHUD show];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.historyDataList.count == 0 ? 1 : self.historyDataList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.historyDataList.count == 0) {
        JHDefaultCollectionViewCell *defaultcell = [_collectionView dequeueReusableCellWithReuseIdentifier:@"JHDefaultCollectionViewCell" forIndexPath:indexPath];
        return defaultcell;
    }
    JHHomeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHHomeCollectionViewCell" forIndexPath:indexPath];
    [cell setCellIndex:indexPath.row];
     cell.recordMode = self.historyDataList[indexPath.row];
    JH_WEAK(self)
    cell.cellClick = ^(BOOL isLaud, NSInteger index) {
        JH_STRONG(self)
        [self clickIndex:index isLaud:isLaud];
    };
    return cell;
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.historyDataList.count == 0) {
        return;
    }
    JHAppraiseVideoViewController *vc = [[JHAppraiseVideoViewController alloc] init];
    vc.cateId = @"0";
    vc.anchorId = self.anchorId;
    AppraisalVideoRecordMode *model = self.historyDataList[indexPath.row];
    vc.appraiseId = model.appraiseId;
    if ( [self isKindOfClass: [NTESAudienceLiveViewController class]]) {
        NTESAudienceLiveViewController * vc=(NTESAudienceLiveViewController*)self;
        vc.needShutDown=YES;
    }
    vc.from = JHLiveFromanchorIntroduce;
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.historyDataList.count == 0) {
        return CGSizeMake(self.collectionView.width, self.collectionView.height);
    }
    CGFloat itemW = (ScreenW - 25) / 2 ;
    return CGSizeMake(itemW, itemW * cellRate + 60);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.scrollCallback(scrollView);
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

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 5;
        layout.minimumLineSpacing = 5;// 设置item的大小
//        CGFloat itemW = (ScreenW - 25) / 2 ;
//        layout.itemSize = CGSizeMake(itemW, itemW * cellRate + 80);
        layout.sectionInset =  UIEdgeInsetsMake(10,10,10, 10);
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = RGB(245, 246, 250);
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[JHHomeCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHHomeCollectionViewCell class])];
        [_collectionView registerClass:[JHDefaultCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHDefaultCollectionViewCell class])];
        MJWeakSelf;
        _collectionView.mj_footer = [JHRefreshNormalFooter footerWithRefreshingBlock:^{
            [weakSelf loadData];
        }];
    }
    return _collectionView;
}

- (NSMutableArray *)historyDataList {
    if (!_historyDataList) {
        _historyDataList = [NSMutableArray array];
    }
    return _historyDataList;
}



@end
