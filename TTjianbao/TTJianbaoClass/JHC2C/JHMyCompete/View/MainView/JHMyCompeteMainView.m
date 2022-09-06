//
//  JHMyCompeteMainView.m
//  TTjianbao
//
//  Created by miao on 2021/6/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMyCompeteMainView.h"
#import "YDRefreshFooter.h"
#import "MBProgressHUD.h"
#import "JHShopHotSellConllectionViewLayout.h"
#import "JHMyAuctionListCollectionCell.h"
#import "JHMyCompeteViewModel.h"
#import "JHMyAuctionListItemModel.h"
#import "JHMyCompeteDelegate.h"
#import "JHPlayerViewController.h"

//#import "JHMyCompeteCollectionViewCell.h"
//#import "JHMyCompeteFlowLayout.h"
//#import "JHMyCompeteFlowLayoutDelegate.h"

@interface JHMyCompeteMainView ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
JHShopHotSellConllectionViewLayoutDelegate>
//JHMyCompeteFlowLayoutDelegate
/// 视图
@property (nonatomic, strong) UICollectionView *collectionView;
// 数据源
@property (nonatomic, strong) JHMyCompeteViewModel *myCompeteViewModel;

/// 我的参拍当前播放的视频
@property (nonatomic, strong, nullable) JHMyAuctionListCollectionCell *currentCell;

@property (nonatomic, strong) JHShopHotSellConllectionViewLayout *hotSellLayout;

@property (nonatomic, strong) JHPlayerViewController *playerController;

@end

@implementation JHMyCompeteMainView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = HEXCOLOR(0xF8F8F8);
        [self p_drawSubViews];
        [self p_makeLayout];
        [MBProgressHUD showHUDAddedTo:self animated:YES];
        [self p_loadCompeteData];
        [self p_competeCollectionViewRefresh];
        
    }
    return self;
}

#pragma mark - Private Methods
- (void)p_drawSubViews {
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.hotSellLayout];
    _collectionView.showsVerticalScrollIndicator = YES;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = HEXCOLOR(0xF8F8F8);
    [self addSubview:_collectionView];
    [_collectionView registerClass:[JHMyAuctionListCollectionCell class]
        forCellWithReuseIdentifier:NSStringFromClass([JHMyAuctionListCollectionCell class])];
    @weakify(self)
    _collectionView.mj_header = [JHRefreshGifHeader headerWithRefreshingBlock:^{
        @strongify(self)
        [self p_loadCompeteData];
    }];
}

- (JHShopHotSellConllectionViewLayout *)hotSellLayout{
    if (!_hotSellLayout) {
        _hotSellLayout = [[JHShopHotSellConllectionViewLayout alloc]init];
        _hotSellLayout.shopLayoutDelegate = self;
    }
    return _hotSellLayout;
}

- (void)p_makeLayout {
    @weakify(self);
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(0, 0, 0, 0));
            
    }];
}

- (void)p_loadCompeteData {
    [self stopVideoPlay];
    [self.myCompeteViewModel.myCompeteCommand execute:nil];
}

- (void)p_competeCollectionViewRefresh {
    @weakify(self)
    [self.myCompeteViewModel.myCompeteSubject subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self)
        [MBProgressHUD hideHUDForView:self animated:YES];
        [self.collectionView jh_endRefreshing];
        if (x == nil) return;
        JHMyCompeteSubjectState subjectState = [x intValue];
        switch (subjectState) {
            case JHMyCompeteSubject_Update:
            {
                if (self.myCompeteViewModel.myCompeteDataArray.count == 0) {
                    
                    [self.collectionView jh_reloadDataWithEmputyView];
                    
                } else {
                    [self.collectionView reloadData];
                  
                }
               
            }
                break;
            case JHMyCompeteSubject_ErrorRefresh:
            {
                //刷新数据，判断空页面
                [self.collectionView jh_reloadDataWithEmputyView];
            }
                break;
                
            default:
                break;
        }
        
       }];
}


//#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.myCompeteViewModel.myCompeteDataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    JHMyAuctionListCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHMyAuctionListCollectionCell class]) forIndexPath:indexPath];
    if (self.myCompeteViewModel.myCompeteDataArray) {
        cell.curData = self.myCompeteViewModel.myCompeteDataArray[indexPath.row];
    }
    @weakify(self);
    cell.buttonActionBlock = ^(JHMyAuctionListItemModel * _Nonnull model, BOOL isPay) {
        @strongify(self);
        if (self.buttonActionBlock) {
            self.buttonActionBlock(model,isPay);
        }
    };
    cell.deleteOutCellBlock = ^(BOOL isDelete) {
        @strongify(self);
        [self.myCompeteViewModel.myCompeteDataArray removeObjectAtIndex:indexPath.row];
        [self.collectionView reloadData];
    };
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:false];
    JHMyAuctionListItemModel *dataModel = [self.myCompeteViewModel.myCompeteDataArray objectAtIndex:indexPath.row];
//    NSString *productId = [NSString stringWithFormat:@"%ld",dataModel.productId];
    if (self.delegate && [self.delegate respondsToSelector:@selector(jumpGoodsDetailsWith:)]) {
        [self.delegate jumpGoodsDetailsWith:dataModel];
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHMyAuctionListItemModel *dataModel = self.myCompeteViewModel.myCompeteDataArray[indexPath.row];
    return CGSizeMake((ScreenW-24-9)/2, dataModel.itemHeight);
}

#pragma flowLayoutDelegate
- (CGFloat)shopCVLayout:(JHShopHotSellConllectionViewLayout *)shopCVLayout heighForItemAtIndexPath:(NSIndexPath *)indexPath itemWidth:(CGFloat)itemWidth{
    JHMyAuctionListItemModel *dataModel = self.myCompeteViewModel.myCompeteDataArray[indexPath.row];
    return dataModel.itemHeight;
}
- (NSInteger)numberOfColumnInShopCVFlowLayout:(JHShopHotSellConllectionViewLayout *)shopCVLayout{
    return 2;
}
- (CGFloat)columnSpaceInShopCVFlowLayout:(JHShopHotSellConllectionViewLayout *)shopCVLayout{
    return 9;
}
- (CGFloat)rowSpaceInShopCVFlowLayout:(JHShopHotSellConllectionViewLayout *)shopCVLayout{
    return 9;
}
- (UIEdgeInsets)itemEdgeInsetInShopCVFlowLayout:(JHShopHotSellConllectionViewLayout *)shopCVFlowLayout{
    return  UIEdgeInsetsMake(12, 12, 12, 12);
}

#pragma mark - WIFI下视频自动播放
///视频自动播放
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView.contentOffset.y>=0) {
        [self endScrollToPlayVideo];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y>=0) {
        [self endScrollToPlayVideo];
    }
}
// 触发自动播放事件
- (void)endScrollToPlayVideo {
    NSArray *visiableCells = [self.collectionView visibleCells];
    for(id obj in visiableCells) {
        if([obj isKindOfClass:[JHMyAuctionListCollectionCell class]]) {
            JHMyAuctionListCollectionCell *cell = (JHMyAuctionListCollectionCell*)obj;
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
//        [self addChildViewController:_playerController.view];
        [self.myVc addChildViewController:_playerController];
    }
    return _playerController;
}

#pragma mark - set/get
-(JHMyCompeteViewModel *)myCompeteViewModel
{
    if (!_myCompeteViewModel) {
        _myCompeteViewModel = [[JHMyCompeteViewModel alloc]init];
    }
    return _myCompeteViewModel;
}

- (void)stopVideoPlay{
    [self.playerController stop];
    self.currentCell = nil;
    [self.playerController.view removeFromSuperview];
}

@end
