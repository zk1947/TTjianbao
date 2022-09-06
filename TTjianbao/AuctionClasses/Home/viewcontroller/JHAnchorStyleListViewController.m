//
//  JHAnchorStyleListViewController.m
//  TTjianbao
//
//  Created by Donto on 2020/7/6.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHAnchorStyleListViewController.h"
#import "JHGrowingIO.h"

@interface JHAnchorStyleListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic ,strong) UICollectionView *collectionView;

@end

@implementation JHAnchorStyleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self removeNavView]; //无基类navbar
    [self.view addSubview:self.collectionView];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self growingSetParamDict:@{@"page_name":JHIdentifyActivityChooseStayTime}];
    [super viewDidDisappear:animated];
}
-(void)reloadData{
    
    [_collectionView reloadData];
}
#pragma mark - UICollectionViewDataSource

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ///369神策埋点:鉴定直播入口
    [JHTracking trackEvent:@"identifyLiveEntranceClick" property:@{@"entrance_type":@"鉴定师列表", @"position_sort":@(indexPath.item).stringValue}];
    
    if (self.selectCellBlock) {
        self.selectCellBlock(self.dataSource[indexPath.row].channelId);
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHAnchorStyleListViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHAnchorStyleListViewCell" forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (UIView *)listView {
    return self.view;
}

- (void)setDataSource:(NSArray<JHRecommendAppraiserListItem *> *)dataSource {
    _dataSource = dataSource;
    [_collectionView reloadData];
}

- (void)followAnchor:(JHRecommendAppraiserListItem *)model {
    
}

- (void)applyAnchor:(JHRecommendAppraiserListItem *)model {
    if (self.applyAuthenticateBlock) {
        self.applyAuthenticateBlock(model.channelId);
    }
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.sectionHeadersPinToVisibleBounds = YES;

        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(5, 10, 0, 10);
        layout.minimumInteritemSpacing = 5.0f;
        layout.minimumLineSpacing = 0.0f;
        CGFloat itemWidth = (self.view.frame.size.width - 25)/2.;
        layout.itemSize = CGSizeMake(itemWidth, 131*itemWidth/175+97);
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.height) collectionViewLayout:layout];
        collectionView.showsVerticalScrollIndicator = NO;
        collectionView.backgroundColor = [UIColor whiteColor];
        collectionView.dataSource = self;
        collectionView.delegate   = self;
        [collectionView registerClass:[JHAnchorStyleListViewCell class] forCellWithReuseIdentifier:@"JHAnchorStyleListViewCell"];
        collectionView.backgroundColor = [UIColor colorWithRGB:0XF5F6FA];
        @weakify(self);
        collectionView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
           @strongify(self);
            if (self.refreshBlock) {
                self.refreshBlock(nil);
            }
        }];
        
        _collectionView = collectionView;

    }
    return _collectionView;
}
- (void)dealloc {
    NSLog(@"%@*************被释放",[self class])
}
@end
