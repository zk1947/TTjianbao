//
//  JHStoreHomeSellerPanel.m
//  TTjianbao
//
//  Created by wuyd on 2019/12/17.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStoreHomeSellerPanel.h"

#import "YYControl.h"
#import "CStoreHomeListModel.h"
#import "JHStoreHomeSellerPanelCCell.h"
#import "GrowingManager.h"
#import "JHSellerInfo.h"

@interface JHStoreHomeSellerPanel () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSMutableArray<CStoreHomeSellerData *> *dataList;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation JHStoreHomeSellerPanel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //self.backgroundColor = [UIColor clearColor];
        _dataList = [NSMutableArray new];
        
        [self configUI];

        @weakify(self);
        [[[JHNotificationCenter rac_addObserverForName:ShopRefreshDataNotication object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(NSNotification *notification) {
            @strongify(self);
            [self handleShopRefreshNotification:notification];
        }];
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
        ccView.userInteractionEnabled = YES;
        //ccView.alwaysBounceVertical = NO; //设置垂直方向的反弹无效
        ccView.alwaysBounceHorizontal = YES; //设置水平方向的反弹有效
        ccView.showsHorizontalScrollIndicator = NO;
        [ccView registerClass:[JHStoreHomeSellerPanelCCell class] forCellWithReuseIdentifier:kCCellId_JHStoreHomeSellerPanelCCell];
        [self addSubview:ccView];
        [ccView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        ccView;
    });
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
    return CGSizeMake((ScreenWidth-30)/3, 150);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHStoreHomeSellerPanelCCell* ccell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellId_JHStoreHomeSellerPanelCCell forIndexPath:indexPath];
    
    ccell.sellerData = _dataList[indexPath.item];
    ccell.isLastItem = (indexPath.item == _dataList.count-1);
    
    return  ccell;
}

- (void)setCurData:(CStoreHomeListData *)curData {
    if (!curData) return;
    _curData = curData;
    
    _dataList = [curData.sellerList mutableCopy];
    
    //增加一个加载更多item
    [_dataList addObject:[CStoreHomeSellerData new]];
    
    [_collectionView reloadData];
    
    //滚动到起始位置
    if (_dataList.count > 0) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
        [_collectionView scrollToItemAtIndexPath:indexPath
                                atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    }
}

- (void)handleShopRefreshNotification:(NSNotification *)notification {
    JHSellerInfo *info = (JHSellerInfo *)notification.object;
    if (!info) {
        return;
    }
    @weakify(self);
    [_dataList enumerateObjectsUsingBlock:^(CStoreHomeSellerData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        @strongify(self);
        if (obj.seller_id == info.seller_id.integerValue) {
            obj.fans_num = info.fans_num;
            obj.fans_num_int = info.fans_num_int;
            obj.follow_status = info.follow_status.integerValue;
            [self.collectionView reloadData];
        }
    }];
}


@end
