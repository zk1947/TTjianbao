//
//  JHStoreHomeListView.m
//  TTjianbao
//
//  Created by wuyd on 2020/2/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHStoreHomeListView.h"
#import "TTjianbao.h"
#import "CStoreChannelGoodsListModel.h"
#import "YDBaseCollectionView.h"
#import "YDWaterFlowLayout.h"
#import "JHStoreHomeListCCell.h"
#import "JHStoreApiManager.h"
#import "JHGoodsDetailViewController.h"
#import "GrowingManager.h"
#import "JHBuryPointOperator.h"
#import "JHGoodsBrowseManager.h"
#import "TTjianbaoBussiness.h"

@interface JHStoreHomeListView () <UICollectionViewDelegate, UICollectionViewDataSource, YDWaterFlowLayoutDelegate>

@property (nonatomic, copy) void(^scrollCallback)(UIScrollView *scrollView);

@property (nonatomic, strong) CStoreChannelGoodsListModel *curModel;
@property (nonatomic, strong) YDWaterFlowLayout *gridLayout;
@property (nonatomic, strong) YDBaseCollectionView *collectionView;
@property (nonatomic, strong) YDRefreshFooter *refreshFooter;

/// 列表某一次展示ID集合
@property (nonatomic, strong) NSMutableDictionary *idsDic;

@end


@implementation JHStoreHomeListView

#pragma mark - Life Cycle

- (void)dealloc {
    NSLog(@"JHStoreHomeListView::dealloc");
    [JHNotificationCenter removeObserver:self];
    self.scrollCallback = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"F5F6FA"];
        _curModel = [[CStoreChannelGoodsListModel alloc] init];

        [self addCollectionView];
        
        [JHNotificationCenter addObserver:self selector:@selector(uploadDataBeforePageLeave) name:kInvalidateTimerNotifaication object:nil];
    }
    return self;
}

- (void)addCollectionView {
    _gridLayout = [[YDWaterFlowLayout alloc] init];
    _gridLayout.delegate = self;
    
    _collectionView = ({
        YDBaseCollectionView *ccView = [[YDBaseCollectionView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.height) collectionViewLayout:self.gridLayout];
        ccView.backgroundColor = [UIColor clearColor];
        ccView.delegate = self;
        ccView.dataSource = self;
        ccView.alwaysBounceVertical = YES;
        ccView.showsVerticalScrollIndicator = YES;
        //ccView.alwaysBounceHorizontal = YES;
        //ccView.showsHorizontalScrollIndicator = NO;
        ccView.userInteractionEnabled = YES;
        [ccView registerClass:[JHStoreHomeListCCell class] forCellWithReuseIdentifier:kCCellId_JHStoreHomeListCCell];
        [self addSubview:ccView];
        ccView.mj_footer = self.refreshFooter;
        ccView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        ccView;
    });
}

- (YDRefreshFooter *)refreshFooter {
    if (!_refreshFooter) {
        _refreshFooter = [YDRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshMore)];
        _refreshFooter.autoTriggerTimes = YES; //每次拖拽只发送一次请求
    }
    return _refreshFooter;
}

#pragma mark -
#pragma mark - 网络请求

//- (void)refresh {
//    if (_curModel.isLoading) {
//        return;
//    }
//    _curModel.willLoadMore = NO;
//    
//    [self getGoodsList];
//}

- (void)refreshMore {
    if (_curModel.isLoading) {
        return;
    }
    _curModel.willLoadMore = YES;
    [self getGoodsList];
}

- (void)endRefresh {
    [self.refreshFooter endRefreshing];
}

- (void)getGoodsList {
    if (_curModel.isLoading) return;
    
    @weakify(self);
    [JHStoreApiManager getGoodsListForChannel:_curModel channelId:_curChannelData.channel_id cateType:_curChannelData.channel_type block:^(CStoreChannelGoodsListModel * _Nullable respObj, BOOL hasError) {
        @strongify(self);
        [self endRefresh];
        [self.refreshFooter endRefreshing];
        if (respObj) {
            [self.curModel configModel:respObj];
            [self.collectionView reloadData];
            
            for (CStoreHomeGoodsData *data in self.curModel.list) {
                NSLog(@"上报CStoreHomeGoodsData:%@", data.goods_id);
            }
        }
        [self configBlankType:YDBlankTypeNoGoodsList hasData:_curModel.list.count > 0 hasError:hasError offsetY:-20 reloadBlock:^(id sender) {}];
    }];
}


#pragma mark -
#pragma mark - 页面跳转
//进入商品详情
- (void)enterGoodsDetailWithGoodsData:(CStoreHomeGoodsData *)data {
    //item_type=6 && layout=4表示广告
    if (data.item_type == 6 && data.layout == 4) {
        [JHRootController toNativeVC:data.target.componentName withParam:data.target.params from:JHLiveFromHomeStoreBanner];
    } else {
        JHGoodsDetailViewController *vc = [JHGoodsDetailViewController new];
        vc.goods_id = data.goods_id;
        vc.entry_type = JHFromStoreHomePage;  ///商城首页列表
        vc.entry_id = @(_curChannelData.channel_id).stringValue; //入口id传分类id
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
        
        //3.1.0-埋点：商城首页下面分类tab下面商品点击事件
        [self GIOGoodsClicked:data];
        
        NSMutableDictionary *params = [NSMutableDictionary new];
        [params setValue:data.goods_id forKey:@"item_id"];
        
        [JHBuryPointOperator buryWithEventId:@"shop_channel_goods_enter" param:params];
    }
}

//3.1.0-埋点：点击首页分类导航标签下商品
- (void)GIOGoodsClicked:(CStoreHomeGoodsData *)data {
    [GrowingManager clickedStoreHomeListCategoryGoods:@{@"cate":_curChannelData.channel_name,
                                                        @"goodsId":data.original_goods_id}];
}

#pragma mark -
#pragma mark - UICollectionViewDelegate、UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _curModel.list.count;
}

//采用瀑布流代理返回
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
//    return CGSizeMake(kScreenWidth, [JHStoreCollectionGridCCell cellHeight]);
//}

// 返回每个cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JHStoreHomeListCCell *ccell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellId_JHStoreHomeListCCell forIndexPath:indexPath];
    
    ccell.curData = _curModel.list[indexPath.item];
    @weakify(self);
    ccell.didSelectedBlock = ^(CStoreHomeGoodsData * _Nonnull data) {
        @strongify(self);
        [self enterGoodsDetailWithGoodsData:data];
    };
    return ccell;
}

/**
 //如果需要头脚视图，可实现此方法
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"selected section：%ld，item：%ld", indexPath.section, indexPath.item);
}
*/

#pragma mark -
#pragma mark - YDWaterFlowLayoutDelegate

/** item Size */
- (CGSize)yd_flowLayout:(YDWaterFlowLayout *)flowLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CStoreHomeGoodsData *data = _curModel.list[indexPath.item];
    //item_type=6 && layout=4表示广告
    CGFloat itemHeight = ((data.item_type==6 && data.layout==4) ? data.imgHeight : data.imgHeight+85);
    
    return CGSizeMake((kScreenWidth-25)/2, itemHeight);
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
    return 5;
}
/** 列间距*/
- (CGFloat)yd_spacingForColumnInFlowLayout:(YDWaterFlowLayout *)flowLayout {
    return 5;
}

/** 边缘之间的间距*/
- (UIEdgeInsets)yd_edgeInsetInFlowLayout:(YDWaterFlowLayout *)flowLayout {
    return UIEdgeInsetsMake(0, 10, 10, 10);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    !self.scrollCallback?:self.scrollCallback(scrollView);

    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@NO];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (!scrollView.decelerating) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {

    if (!decelerate) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
    }
    
}

- (void)scrollViewDidEndScroll {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_HOME_SCROLLVIEW_STOP_STATUS object:@YES];
}

#pragma mark -
#pragma mark - JXPagingViewListViewDelegate
- (UIScrollView *)listScrollView {
    return _collectionView;
}

- (void)listViewDidScrollCallback:(void (^)(UIScrollView *))callback {
    self.scrollCallback = callback;
}

- (void)listViewLoadDataIfNeeded {
    //NSLog(@"curChannelId = %ld", (long)_curChannelData.channel_id);
    if (_curModel.isFirstReq || _curModel.list.count == 0) {
        [self getGoodsList];
    }
}


#pragma mark -
#pragma mark - 浏览商品埋点相关

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CStoreHomeGoodsData *data = _curModel.list[indexPath.item];
    if(data.goods_id)
    {
        [self.idsDic setValue:data.goods_id forKey:data.goods_id];
    }
}

/// 曝光帖子ID集合
- (NSMutableDictionary *)idsDic {
    if(!_idsDic)
    {
        _idsDic = [NSMutableDictionary new];
    }
    return _idsDic;
}

///离开页面时需要上报数据
- (void) uploadDataBeforePageLeave {
    
    NSString *IDS = @"";
    for (NSString *ids in self.idsDic.allKeys) {
        if(IDS.length > 0)
        {
            IDS = [NSString stringWithFormat:@"%@,%@",IDS,ids];
        }
        else
        {
            IDS = ids;
        }
    }
    if(IDS.length > 0)
    {
        NSMutableDictionary *param = [NSMutableDictionary new];
        [param setValue:IDS forKey:@"browse_id"];
        [param setValue:[NSString stringWithFormat:@"%zd",self.curChannelData.channel_id] forKey:@"channel_id"];
        [JHBuryPointOperator buryWithEventId:@"shop_channel_goods_exposure" param:param];
    }
    
    [self.idsDic removeAllObjects];
}

/// 返回顶部子 scrollView
- (void)setSubScrollView {
    [JHHomeTabController setSubScrollView:self.collectionView];
}
@end
