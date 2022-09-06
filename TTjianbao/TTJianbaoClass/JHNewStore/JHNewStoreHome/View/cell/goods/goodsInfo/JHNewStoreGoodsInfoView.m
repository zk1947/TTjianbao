//
//  JHNewStoreGoodsInfoView.m
//  TTjianbao
//
//  Created by user on 2021/2/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreGoodsInfoView.h"
#import "JHNewStoreHomeGoodsCollectionViewCell.h"
#import "JHNewStoreHomeViewModel.h"
#import "UIScrollView+JHEmpty.h"
#import "JHPlayerViewController.h"
#import "YDWaterFlowLayout.h"

@interface JHNewStoreGoodsInfoView ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UIScrollViewDelegate,
YDWaterFlowLayoutDelegate
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray   *dataSourceArray;
@property (nonatomic, assign) BOOL              canScroll;
@property (nonatomic, strong) JHPlayerViewController *playerController;
/** 当前播放视频的cell*/
@property (nonatomic, strong) JHNewStoreHomeGoodsCollectionViewCell *currentCell;
@property (nonatomic, strong) YDWaterFlowLayout *gridLayout;
@end

@implementation JHNewStoreGoodsInfoView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

- (void)setupViews {
    _gridLayout                                    = [[YDWaterFlowLayout alloc] init];
    _gridLayout.delegate = self;
    _collectionView                                = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:_gridLayout];
    _collectionView.backgroundColor                = HEXCOLOR(0xF5F5F8);
    _collectionView.delegate                       = self;
    _collectionView.dataSource                     = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator   = NO;
    _collectionView.contentInset                   = UIEdgeInsetsMake(0, 10.f, 0.f, 10.f);
    _collectionView.userInteractionEnabled         = YES;
    [self addSubview:_collectionView];
    
    [_collectionView registerClass:[JHNewStoreHomeGoodsCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHNewStoreHomeGoodsCollectionViewCell class])];
    
    [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
        make.height.mas_equalTo([self bottomCellHeight]);
    }];
}

#pragma mark - Delegate DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHNewStoreHomeGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHNewStoreHomeGoodsCollectionViewCell class]) forIndexPath:indexPath];
    cell.curData = self.dataSourceArray[indexPath.item];
    @weakify(self);
    cell.goToBoutiqueDetailClickBlock = ^(BOOL isH5, NSString * _Nonnull showId, NSString * _Nonnull boutiqueName) {
        @strongify(self);
        if (self.goToBoutiqueDetailClickBlock) {
            self.goToBoutiqueDetailClickBlock(isH5, showId, boutiqueName);
        }
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.goodsClickBlock) {
        self.goodsClickBlock(self.dataSourceArray[indexPath.item]);
    }
}

- (void)setViewModel:(id)viewModel {
//    [self.dataSourceArray removeAllObjects];
    NSArray<JHNewStoreHomeGoodsProductListModel *>*viewModels = viewModel;
    if (viewModels.count >0) {
        [self.dataSourceArray addObjectsFromArray:viewModels];
    }
    [self.collectionView reloadData];
}


- (CGFloat)bottomCellHeight {
    return ScreenH - UI.statusBarHeight - 110.f - 45.f - 49.f - 45.f;
}


#pragma mark - private
- (void)makeDeatilDescModuleScroll:(BOOL)canScroll {
    self.canScroll = canScroll;
    if (!canScroll) {
        self.collectionView.contentOffset = CGPointZero;
    }
}

- (void)makeDeatilDescModuleScrollToTop {
    [self.collectionView setContentOffset:CGPointZero];
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.canScroll) {
        CGFloat offsetY = scrollView.contentOffset.y;
        if (offsetY <= 0) {
            [self makeDeatilDescModuleScroll:NO];
            if (self.delegate && [self.delegate respondsToSelector:@selector(JHNewStoreGoodsInfoViewLeaveTopd)]) {
                [self.delegate JHNewStoreGoodsInfoViewLeaveTopd];
            }
        }
    } else {
        [self makeDeatilDescModuleScroll:NO];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self endScrollToPlayVideo];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self endScrollToPlayVideo];
}

// 触发自动播放事件
- (void)endScrollToPlayVideo {
    NSArray *visiableCells = [self.collectionView visibleCells];
    for(id obj in visiableCells) {
        if([obj isKindOfClass:[JHNewStoreHomeGoodsCollectionViewCell class]]) {
            JHNewStoreHomeGoodsCollectionViewCell *cell = (JHNewStoreHomeGoodsCollectionViewCell*)obj;
            CGRect rect = [cell convertRect:cell.bounds toView:[UIApplication sharedApplication].keyWindow];
            CGRect collectionRect = [self.collectionView convertRect:self.collectionView.bounds toView:[UIApplication sharedApplication].keyWindow];
            //只要cell在视图里面显示超过一半就给展示视频 && 视频类型 && 有视频链接
            if (rect.origin.y>=collectionRect.origin.y &&rect.origin.y+rect.size.height<=ScreenH-UI.bottomSafeAreaHeight-49 && cell.curData.videoUrl.length > 0) {
                /** 添加视频*/
                if (self.currentCell == cell) {
                    return;
                }
                self.currentCell = cell;
                self.playerController.view.frame = cell.imgView.bounds;
                [self.playerController setSubviewsFrame];
                [cell.imgView addSubview:self.playerController.view];
                self.playerController.urlString = cell.curData.videoUrl;
                return;
            }
        }
    }
    //没有满足条件的 释放视频
    [self.playerController stop];
    self.currentCell = nil;
    [self.playerController.view removeFromSuperview];
}

- (JHPlayerViewController *)playerController {
    if (_playerController == nil) {
        _playerController = [[JHPlayerViewController alloc] init];
        _playerController.muted = YES;
        _playerController.looping = YES;
        _playerController.hidePlayButton = YES;
        [self.viewController addChildViewController:_playerController];
    }
    return _playerController;
}


#pragma mark -
#pragma mark - YDWaterFlowLayoutDelegate
/** item Size */
- (CGSize)yd_flowLayout:(YDWaterFlowLayout *)flowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHNewStoreHomeGoodsProductListModel *data = self.dataSourceArray[indexPath.item];
    return CGSizeMake((ScreenW - 12.f*2 - 9.f)/2.f, 170);
}

///** header Size */
- (CGSize)yd_flowLayout:(YDWaterFlowLayout *)flowLayout sizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

/** footer Size */
- (CGSize)yd_flowLayout:(YDWaterFlowLayout *)flowLayout sizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}

/** 列数*/
- (NSInteger)yd_numberOfColumnsInFlowLayout:(YDWaterFlowLayout *)flowLayout {
    return 2;
}

/** 行间距*/
- (CGFloat)yd_spacingForRowInFlowLayout:(YDWaterFlowLayout *)flowLayout {
    return 9;
}
/** 列间距*/
- (CGFloat)yd_spacingForColumnInFlowLayout:(YDWaterFlowLayout *)flowLayout {
    return 9;
}

/** 边缘之间的间距*/
- (UIEdgeInsets)yd_edgeInsetInFlowLayout:(YDWaterFlowLayout *)flowLayout {
    return UIEdgeInsetsMake(0, 10, 10, 10);
}

@end
