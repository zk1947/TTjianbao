//
//  JHStoreHomeRcmdPanel.m
//  TTjianbao
//
//  Created by wuyd on 2019/11/21.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStoreHomeRcmdPanel.h"
#import "CStoreHomeListModel.h"
#import "JHStoreHomeRcmdPanelCCell.h"
#import "JHGoodsDetailViewController.h"
#import "GrowingManager.h"
#import "YDCountDownManager.h"


#import "JHBuryPointOperator.h"
#import "JHGoodsBrowseManager.h"

@interface JHStoreHomeRcmdPanel () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray<CStoreHomeGoodsData *> *dataList;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) JHGoodsBrowseManager *browseManager;

@end

@implementation JHStoreHomeRcmdPanel

- (JHGoodsBrowseManager *)browseManager {
    if (!_browseManager) {
        _browseManager = [[JHGoodsBrowseManager alloc] init];
        _browseManager.entryType = JHFromStoreHomePage;
    }
    return _browseManager;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _dataList = [NSMutableArray new];
        
        [self configUI];
    }
    return self;
}

- (void)configUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal; //横向布局
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 10, 10);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 0;
    
    _collectionView = ({
        UICollectionView *ccView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        ccView.backgroundColor = [UIColor clearColor];
        ccView.delegate = self;
        ccView.dataSource = self;
        //ccView.userInteractionEnabled = YES;
        ccView.scrollsToTop = NO; //关闭collectionView滚动到顶部
        ccView.alwaysBounceVertical = NO; //设置垂直方向的反弹无效
        ccView.alwaysBounceHorizontal = YES; //设置水平方向的反弹有效
        ccView.showsHorizontalScrollIndicator = NO;
        ccView.exclusiveTouch = YES;
        [ccView registerClass:[JHStoreHomeRcmdPanelCCell class] forCellWithReuseIdentifier:kCCellId_JHStoreHomeRcmdPanelCCell];
        [self addSubview:ccView];
        [ccView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        ccView;
    });
}

- (void)setCurData:(CStoreHomeListData *)curData {
    _curData = curData;
    _dataList = [curData.goodsList mutableCopy];
    [_collectionView reloadData];
}

//Fix：横向滑动ccView联动问题
- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;
    [_collectionView setContentOffset:_collectionView.contentOffset animated:NO];
}

//进入商品详情
- (void)__enterGoodsDetailVC:(CStoreHomeGoodsData *)data {
    JHGoodsDetailViewController *vc = [JHGoodsDetailViewController new];
    vc.goods_id = data.goods_id;
    vc.entry_type = JHFromStoreHomeShopWindowList; ///商城首页橱窗
    vc.entry_id = @(_curData.sc_id).stringValue; //入口id传橱窗id
    [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
}

//Fix：横向滑动ccView联动问题
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (![scrollView isKindOfClass:[UICollectionView class]]) return;
    
    CGFloat offsetX = scrollView.contentOffset.x;
    if (self.collectionOffsetXChangedBlock) {
        self.collectionOffsetXChangedBlock(_collectionView, _indexPath, offsetX);
    }
}

#pragma mark -
#pragma mark CollectionDelegate、CollectionDataSource

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(0, 15, 0, 15);
//}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(JHScaleToiPhone6(130), self.height-10);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHStoreHomeRcmdPanelCCell* ccell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellId_JHStoreHomeRcmdPanelCCell forIndexPath:indexPath];
    
    ccell.goodsData = _dataList[indexPath.item];
    
    @weakify(self);
    ccell.didSelectedItemBlock = ^(CStoreHomeGoodsData * _Nonnull selectedData) {
        @strongify(self);
        [self __enterGoodsDetailVC:selectedData];
        //埋点 - 点击橱窗列表商品
        [GrowingManager clickStoreHomeShopWindowGoods:[self growingParamsWithData:selectedData]];
    };
    
    //倒计时结束回调
    ccell.countDownEndBlock = ^(CStoreHomeGoodsData * _Nonnull data) {
        @strongify(self);
        [self __handleCountDownEndEvent:data];
    };
    
    return  ccell;
}

#pragma mark -
#pragma mark - YDCountDownManager Methods

- (void)__handleCountDownEndEvent:(CStoreHomeGoodsData *)data {
    
    if (_dataList.count > 0 && [_dataList containsObject:data]) {
        NSLog(@"删除前listCount = %ld", (long)_dataList.count);
        [_dataList removeObject:data];
        NSLog(@"删除后listCount = %ld", (long)_dataList.count);
        
        [self.collectionView reloadData];
        
        //所有数据倒计时结束
        if (_dataList.count == 0) {
            //删除当前橱窗的倒计时
            [kCountDownManager removeTimerSourceWithId:_curData.timerSourceIdentifier];
            [JHNotificationCenter postNotificationName:JHStoreHomeRcmdListAllCountDownEndNotification object:nil];
        }
    }
}


#pragma mark -
#pragma mark - 埋点统计参数
//点击橱窗列表项
- (NSDictionary *)growingParamsWithData:(CStoreHomeGoodsData *)data {
    NSDictionary *params = @{@"sc_id" : @(_curData.sc_id),
                             @"name" : _curData.name,
                             @"layout" : @(_curData.layout),
                             @"goods_id" : data.goods_id
    };
    return params;
}

#pragma mark -
#pragma mark - 埋点相关
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_dataList.count == 0) {
        return;
    }
    
    CStoreHomeGoodsData *data = _dataList[indexPath.item];
    if (data.goods_id == 0) {
        return;
    }
    //[self.browseManager addGoodsItem:data.goods_id];
    [self.browseManager addGoodsItem:data.original_goods_id];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath {
    if (_dataList.count == 0) {
        return;
    }
    
    if (indexPath.item < _dataList.count) {
        CStoreHomeGoodsData *data = _dataList[indexPath.item];
        //[self.browseManager removeGoodsItem:data.goods_id];
        [self.browseManager removeGoodsItem:data.original_goods_id];
    }
}

@end
