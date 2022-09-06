//
//  JHSQRcmdPlatePanel.m
//  TTjianbao
//
//  Created by wuyd on 2020/6/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHSQRcmdPlatePanel.h"
#import "JHSQRcmdPlatePanelCCell.h"
#import "JHPlateListModel.h"

@interface JHSQRcmdPlatePanel () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation JHSQRcmdPlatePanel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self configUI];
    }
    return self;
}

- (void)configUI {
    float merge = (kScreenWidth - 55*5 - 40)/6;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal; //横向布局
    layout.sectionInset = UIEdgeInsetsMake(0, merge, 0, merge);
    layout.minimumLineSpacing = merge;
    layout.minimumInteritemSpacing = 0;
    
    _collectionView = ({
        UICollectionView *ccView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        ccView.backgroundColor = [UIColor clearColor];
        ccView.delegate = self;
        ccView.dataSource = self;
        ccView.userInteractionEnabled = YES;
        ccView.scrollEnabled = NO;
        //ccView.alwaysBounceVertical = NO; //设置垂直方向的反弹无效
        //ccView.alwaysBounceHorizontal = YES; //设置水平方向的反弹有效
        ccView.showsHorizontalScrollIndicator = NO;
        [ccView registerClass:[JHSQRcmdPlatePanelCCell class] forCellWithReuseIdentifier:kCCellId_JHSQRcmdPlatePanelCCell];
        [self addSubview:ccView];
        ccView.sd_layout.spaceToSuperView(UIEdgeInsetsZero);
        ccView;
    });
}

#pragma mark -
#pragma mark CollectionDelegate、CollectionDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _plateList.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(55, 87.f);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JHSQRcmdPlatePanelCCell* ccell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellId_JHSQRcmdPlatePanelCCell forIndexPath:indexPath];
    ccell.pageType = self.pageType;
    ccell.curData = _plateList[indexPath.item];
    return  ccell;
}

- (void)setPlateList:(NSMutableArray<JHPlateListData *> *)plateList {
    if (!plateList) return;
    if (plateList.count > 5) {
        _plateList = [plateList subarrayWithRange:NSMakeRange(0, 5)].mutableCopy;
    } else {
        _plateList = plateList.mutableCopy;
    }
    [_collectionView reloadData];
}

@end
