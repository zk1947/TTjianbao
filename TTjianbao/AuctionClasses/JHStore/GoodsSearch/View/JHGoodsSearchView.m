//
//  JHGoodsSearchView.m
//  TTjianbao
//
//  Created by LiHui on 2020/2/12.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHGoodsSearchView.h"
#import "SearchKeyListCCell.h"
#import "JHHotwordCCell.h"
#import "SearchKeyListHeader.h"
#import "SearchKeyListFooter.h"
#import "SearchKeyListFlowLayout.h"

#import "JHHotWordModel.h"
#import <NSString+YYAdd.h>

#import "JHGrowingIO.h"

@interface JHGoodsSearchView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

///历史记录
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation JHGoodsSearchView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXCOLOR(0xF7F7F7);
        [self initViews];
    }
    return self;
}

- (void)initViews {
    _collectionView = ({
        SearchKeyListFlowLayout *layout = [[SearchKeyListFlowLayout alloc] init];
        UICollectionView *historyCView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        historyCView.backgroundColor = [UIColor whiteColor];
        historyCView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        historyCView.delegate = self;
        historyCView.dataSource = self;
        ///历史记录
        [historyCView registerClass:[SearchKeyListCCell class] forCellWithReuseIdentifier:kCCellId_SearchHistoryListCCell];
        ///热搜
        [historyCView registerClass:[JHHotwordCCell class] forCellWithReuseIdentifier:kCCellId_SearchHotListCCell];

        [historyCView registerClass:[SearchKeyListHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderId_SearchKeyListHeader];
        [historyCView registerClass:[SearchKeyListFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterId_SearchKeyListFooter];
        historyCView;
    });
    [self addSubview:_collectionView];
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, UI.bottomSafeAreaHeight, 0));
    }];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return _curModel.historyList.count < 10 ? _curModel.historyList.count : 10;
    }
    return _curModel.hotList.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ///历史记录
    if (indexPath.section == 0) {
        SearchKeyListCCell* ccell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellId_SearchHistoryListCCell forIndexPath:indexPath];
        CSearchKeyData *data = _curModel.historyList[indexPath.item];
        [ccell setKeyData:data isHot:YES];
        return  ccell;
    }
    ///热搜
    if (indexPath.section == 1) {
        JHHotwordCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellId_SearchHotListCCell forIndexPath:indexPath];
        cell.indexPath = indexPath;
        cell.searchData = _curModel.hotList[indexPath.item];
        return cell;
    }
    
    return [UICollectionViewCell new];
}

//头视图高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        if (_curModel.historyList.count > 0) {
            return CGSizeMake(ScreenW, [SearchKeyListHeader headerHeight]);
        }
        return CGSizeZero;
    }
    if (_curModel.hotList.count > 0) {
        return CGSizeMake(ScreenW, [SearchKeyListHeader headerHeight]);
    }
    return CGSizeZero;
}

//尾视图高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0 && _curModel.historyList.count > 0) {
        return CGSizeMake(0, 5);
    }
    return CGSizeZero;
}

//头部视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SearchKeyListHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderId_SearchKeyListHeader forIndexPath:indexPath];
        header.keyType = (indexPath.section == 0) ?  YDSearchKeyTypeHistory : YDSearchKeyTypeHot;
        @weakify(self);
        header.deleteBtnClickBlock = ^{
            @strongify(self);
            [self deleteBtnClicked];
        };
        return header;
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        SearchKeyListFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterId_SearchKeyListFooter forIndexPath:indexPath];
        footer.backgroundColor = HEXCOLOR(0xF7F7F7);
        return footer;
    }
    return [UICollectionReusableView new];
}

//itemSize
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        CSearchKeyData *keyData = _curModel.historyList[indexPath.row];
        NSString * keyStr = keyData.keyword;
        CGSize size = [keyStr sizeForFont:[UIFont fontWithName:kFontNormal size:13.0] size:CGSizeMake(HUGE, 30) mode:NSLineBreakByWordWrapping];
        CGFloat cellWidth = (size.width+26) > (ScreenW-30) ? (ScreenW - 30) : (size.width+26);
        return CGSizeMake(cellWidth, 30.0f);
    }
    if (indexPath.section == 1) {
        return CGSizeMake((ScreenW - 60)/2, 18);
    }
    
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    CGFloat space = 15.f;
    return UIEdgeInsetsMake(5, space, 10, space);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return (section == 1) ? 20 : 10;
};

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout * _Nonnull)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}


#pragma mark - 跳转到搜索结果落地页
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *vcName;
    NSDictionary *params;
    NSString* searchFrom = nil;
    if (indexPath.section == 0) {
        ///历史l记录
        CSearchKeyData *keyData = _curModel.historyList[indexPath.item];
        [CSearchKeyModel saveHistoryData:keyData];
        
        vcName = @"JHGoodsSearchController";
        params = @{@"keyword":keyData.keyword};
        searchFrom = JHTrackMarketSaleSearchFromHistory;
    }
    else {
        JHHotWordModel *model = _curModel.hotList[indexPath.item];
        vcName = model.target.componentName;
        params = model.target.params;
        searchFrom = JHTrackMarketSaleSearchFromHotAdvert;
    }
    if (!vcName || !params) {
        return;
    }

    ///跳转
    if (self.didSelectKeywordBlock) {
        self.didSelectKeywordBlock(vcName, params, searchFrom);
    }
}

///删除历史记录
- (void)deleteBtnClicked {
    [self removeSearchHistory];
}

- (void)setCurModel:(CSearchKeyModel *)curModel {
    _curModel = curModel;
    [_collectionView reloadData];
}

#pragma mark - 存储相关
//保存搜索历史
- (void)saveSearchHistory:(CSearchKeyData *)data {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^() {
        [CSearchKeyModel saveHistoryData:data];
    });
}

///删除搜索历史
- (void)removeSearchHistory {
    [CSearchKeyModel removeAllHistory];
    _curModel.historyList = [NSMutableArray arrayWithArray:[CSearchKeyModel loadHistoryList]];
    [UIView performWithoutAnimation:^{
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
        [self.collectionView reloadSections:indexSet];
    }];
}

- (void)updateHistoryList {
    _curModel.historyList = [NSMutableArray arrayWithArray:[CSearchKeyModel loadHistoryList]];
    if (_curModel.historyList.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView performWithoutAnimation:^{
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
                [self.collectionView reloadSections:indexSet];
            }];
        });
    }
}

@end
