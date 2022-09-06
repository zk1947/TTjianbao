//
//  JHTopicDetailController.m
//  TTjianbao
//
//  Created by wuyd on 2019/7/29.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHTopicDetailController.h"
#import "YDRefreshFooter.h"
#import "UIScrollView+APParallaxHeader.h"
#import "YDBaseNavigationBar.h"
#import "JHTopicDetailHeader.h" //顶部滑动缩放header
#import "JHTopicDetailSaleView.h"
#import "BaseNavViewController.h"
#import "JHTopicSaleListController.h"
#import "JHSQManager.h"

#import "CTopicDetailModel.h"
#import "TopicApiManager.h"

#import "JHAnchorHomepageTopView.h"
#import "HJCollectionViewWaterfallLayout.h"
#import "JHDiscoverHomeFlowCollectionCell.h"

#import "JHDiscoverDetailsVC.h"
#import "JHAppraiseVideoViewController.h"
#import "JHDiscoverVideoDetailViewController.h"
#import "JHGrowingIO.h"
#import "JHBuryPointOperator.h"
#import "ZQSearchConst.h"
#import "NSString+LNExtension.h"

#import "JHDiscoverChannelCateModel.h"
#import "JHDiscoverChannelViewModel.h"
#import "JHDiscoverStatisticsModel.h"
#import "JHPublishAreaViewController.h"

#import "JHTaskHUD.h"
#import "YDActionSheet.h"
#import "JHWebViewController.h"
//#import "UIView+CornerRadius.h"

#define kStatiscGapTime 1000
#define kHeaderDefaultH ([JHTopicDetailHeader headerDefaultHeight])
#define kIgnoreOffsetY  (JHNaviBarHeight) //上推时忽略的偏移量，超过这个值才开始设置透明度


static NSString *const kDefaultCCellID = @"DefaultCCellId"; //空页面
static NSString *const kFlowCCellID = @"FlowCCellId"; //瀑布流

@interface JHTopicDetailController ()
<UICollectionViewDelegate, UICollectionViewDataSource, HJCollectionViewWaterfallLayoutDelegate>
{
    BOOL    _naviBarHidden;
    CGFloat _alphaValue; //导航栏透明度动态值
    CGFloat _startOffsetY; //开始设置透明度时的偏移量
    CGFloat _headerH; //header高度
}

@property (nonatomic,   copy) NSString *titleStr;

@property (nonatomic, strong) CTopicDetailModel *curModel;

@property (nonatomic, strong) YDBaseNavigationBar *naviBar;
@property (nonatomic, strong) UIButton *publishBtn;

@property (nonatomic, assign) BOOL hasHotData; //是否存在热门数据
@property (nonatomic, assign) NSInteger curIndex; //当前选项卡
@property (nonatomic, strong) NSMutableArray<JHDiscoverChannelCateModel *> *topicList;
@property (nonatomic, strong) JHTopicDetailHeader *headerView;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) JHRefreshGifHeader *refreshHeader;
@property (nonatomic, strong) YDRefreshFooter *refreshFooter;

@property (nonatomic, assign) BOOL showDefaultImage;

@property (nonatomic, strong) NSMutableArray *pubuZaningArr;

@property (nonatomic, strong) NSMutableArray<JHDiscoverStatisticsModel *> *originArr;//原始数组，随时插入
@property (nonatomic, strong) NSMutableArray<JHDiscoverStatisticsModel *> *waitUploadArr;//等待上传的数据
@property (nonatomic, strong) NSMutableArray<JHDiscoverStatisticsModel *> *canUploadArr;//所有满足条件的数据

@property (nonatomic, strong) NSTimer *timer;

@end


@implementation JHTopicDetailController

#pragma mark - 设置状态栏
- (UIStatusBarStyle)preferredStatusBarStyle {
    return (_naviBarHidden ? UIStatusBarStyleLightContent : UIStatusBarStyleDefault);
}

- (void)leftBtnClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)rightBtnClicked {
    NSLog(@"分享");
    
    NSString *titleStr = _curModel.topicInfo.shareInfo.title;
    NSString *descStr = _curModel.topicInfo.shareInfo.desc;
    NSString *imgStr = _curModel.topicInfo.shareInfo.img;
    NSString *urlStr = _curModel.topicInfo.shareInfo.url;
    
    [[UMengManager shareInstance] showShareWithTarget:nil
                                                title:titleStr
                                                 text:descStr
                                             thumbUrl:imgStr
                                               webURL:urlStr
                                                 type:ShareObjectTypeSocialArticial
                                               object:nil];
}

- (void)dealloc {
    NSLog(@" JHTopicDetailController::dealloc");
}

- (void)setTitle:(nullable NSString *)title itemId:(NSString *)itemId {
    _titleStr = title;
    _item_id = itemId;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _topicList = [NSMutableArray new];
    _curModel = [[CTopicDetailModel alloc] init];
    _curModel.item_id = _item_id;
    
    _headerH = kHeaderDefaultH;
    _startOffsetY = -(_headerH - kIgnoreOffsetY);
    
    [self configNaviBar];
    [self configUI];
    
    [self addPublishBtn];
    
    [self firstRequest];
    
    //埋点
    [Growing track:@"topic"];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self refreshStatics:YES];
}

#pragma mark -
#pragma mark - Config UI

- (void)configNaviBar {
    _naviBar = [[YDBaseNavigationBar alloc] init];
    _naviBar.title = [_titleStr isNotBlank] ? _titleStr : @"";
    _naviBar.titleLabel.alpha = 0;
    _naviBar.leftImage = kNavBackWhiteImg;
    _naviBar.rightImage = kNavShareWhiteImg;
    [_naviBar.leftBtn addTarget:self action:@selector(leftBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_naviBar.rightBtn addTarget:self action:@selector(rightBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_naviBar];
    [self.view bringSubviewToFront:_naviBar];
}

- (void)updateNaviBar {
    _naviBarHidden = _alphaValue <= 0;
    [UIView animateWithDuration:0.25 animations:^{
        _naviBar.backgroundView.backgroundColor = [UIColor colorWithWhite:1 alpha:_alphaValue];
        _naviBar.titleLabel.alpha = _alphaValue;
        _naviBar.leftImage = _naviBarHidden ? kNavBackWhiteImg : kNavBackBlackImg;
        _naviBar.rightImage = _naviBarHidden ? kNavShareWhiteImg : kNavShareBlackImg;
        [self setNeedsStatusBarAppearanceUpdate];
    }];
}

//立即参与按钮
- (void)addPublishBtn {
    _publishBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _publishBtn.exclusiveTouch = YES;
    [_publishBtn setImage:[UIImage imageNamed:@"topic_icon_partin"] forState:UIControlStateNormal];
    [_publishBtn setImage:[UIImage imageNamed:@"topic_icon_partin"] forState:UIControlStateHighlighted];
    [_publishBtn addTarget:self action:@selector(publishBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_publishBtn];
    [_publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-(JHSafeAreaBottomHeight + 36.0));
        make.centerX.equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(144, 54));
    }];
    _publishBtn.hidden = YES;
}

- (void)publishBtnClicked {
    if ([self isLogin]) {
        if ([JHSQManager needAutoEnterMerchantVC] ) {
            [JHSQManager enterMerchantVC];
            return;
        }
        
        JHPublishAreaViewController * publish = [[JHPublishAreaViewController alloc]init];
        BaseNavViewController *publishNav = [[BaseNavViewController alloc]initWithRootViewController:publish];
        publish.isOpenAppraise = NO;
        publish.from = JHFromSQTopicDetail;
        publish.topicTitle = _titleStr;
        [self presentViewController:publishNav animated:YES completion:nil];
    }
}

- (void)configUI {
    if (!_collectionView) {
        HJCollectionViewWaterfallLayout *layout = [[HJCollectionViewWaterfallLayout alloc] init];
        layout.delegate = self;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor colorWithHexStr:@"F8F8F8"];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES; //数据少也可以滚动
        _collectionView.showsVerticalScrollIndicator = YES;
        
        [_collectionView registerClass:[JHDiscoverHomeFlowCollectionCell class] forCellWithReuseIdentifier:kFlowCCellID];
        [_collectionView registerClass:[JHDefaultCollectionViewCell class] forCellWithReuseIdentifier:kDefaultCCellID];
        
        [self.view insertSubview:_collectionView aboveSubview:_naviBar];
        [self.view sendSubviewToBack:_collectionView];
        //_collectionView.mj_header = self.refreshHeader;
        _collectionView.mj_footer = self.refreshFooter;
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

- (void)showHeaderView {
    BOOL hasSaleData = _curModel.saleInfo.contentList.count > 0  && [_curModel.saleInfo.item_id isNotBlank];
    BOOL hasHotList = _curModel.hotContentList.count > 0;
    
    if (_curModel.topicInfo.bg_wh_scale > 0) {
        CGFloat scaleH = ScreenWidth/_curModel.topicInfo.bg_wh_scale;
        if (scaleH > _headerH) {
            _headerH = scaleH;
        }
    }
    
    if (hasSaleData) {
        _headerH += [JHTopicDetailSaleView viewHeight];
    }
    if (hasHotList) {
        _headerH += [JHTopicDetailHeader segmentHeight];
    }
    _startOffsetY = -(_headerH - kIgnoreOffsetY);
    
    [_collectionView addParallaxWithView:self.headerView andHeight:_headerH andShadow:NO];
    //_collectionView.parallaxView.delegate = self;
    [self.headerView setTopicData:self.curModel.topicInfo saleData:hasSaleData ? _curModel.saleInfo : nil hasHotData:self.curModel.hotContentList.count > 0];
}

//特卖栏倒计时结束回调
- (void)handleCountDownEndEvent {
    _headerH = kHeaderDefaultH;
    
    if (_curModel.topicInfo.bg_wh_scale > 0) {
        CGFloat scaleH = ScreenWidth/_curModel.topicInfo.bg_wh_scale;
        if (scaleH > _headerH) {
            _headerH = scaleH;
        }
    }
    
    BOOL hasHotList = _curModel.hotContentList.count > 0;
    if (hasHotList) {
        _headerH += [JHTopicDetailHeader segmentHeight];
    }
    
    _startOffsetY = -(_headerH - kIgnoreOffsetY);
    
    [_collectionView hideParallaxView];
    [self.headerView removeFromSuperview];
    self.headerView = nil;
    
    [_collectionView addParallaxWithView:self.headerView andHeight:_headerH andShadow:NO];
    [self.headerView setTopicData:self.curModel.topicInfo saleData:nil hasHotData:self.curModel.hotContentList.count > 0];
}


#pragma mark -
#pragma mark - Lazy Methods

- (JHTopicDetailHeader *)headerView {
    if (!_headerView) {
        _headerView = [[JHTopicDetailHeader alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, _headerH)];
        
        @weakify(self);
        _headerView.saleItemClickBlock = ^(JHDiscoverChannelCateModel * _Nonnull data) {
            @strongify(self);
            [self enterDetailVCWithData:data];
        };
        
        _headerView.segmentSelectedBlock = ^(NSInteger selectedIndex) {
            @strongify(self);
            if (self.curIndex != selectedIndex) {
                self.curIndex = selectedIndex;
                self.curModel.willLoadMore = NO;
                [self sendRefreshRequest];
            }
        };
        
        _headerView.enterMoreBlock = ^{
            @strongify(self);
            [self enterSaleVC];
        };
        
        //特卖栏倒计时结束
        _headerView.countDownEndBlock = ^{
            @strongify(self);
            [self handleCountDownEndEvent];
        };
    }
    return _headerView;
}

- (YDRefreshFooter *)refreshFooter {
    if (!_refreshFooter) {
        _refreshFooter = [YDRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshMore)];
        _refreshFooter.autoTriggerTimes = YES;
    }
    return _refreshFooter;
}

- (void)endRefresh {
    [self.collectionView.mj_header endRefreshing];
    [self.collectionView.mj_footer endRefreshing];
}


#pragma mark -
#pragma mark - 网络请求
- (void)firstRequest {
    [SVProgressHUD show];
    [self refreshStatics:NO];
    [self sendRequest];
}

- (void)refresh {
    [self refreshStatics:NO];
    if (_curModel.isLoading) return;
    _curModel.willLoadMore = NO;
    [self sendRefreshRequest];
}

- (void)refreshMore {
    if (_curModel.isLoading) {
        return;
    }
    _curModel.willLoadMore = YES;
    [self sendRefreshRequest];
}

//首次请求获取
- (void)sendRequest {
    @weakify(self);
    [TopicApiManager request_topicDetail:_curModel completeBlock:^(CTopicDetailModel * _Nullable respObj, BOOL hasError) {
        @strongify(self);
        [SVProgressHUD dismiss];
        [self endRefresh];
        
        if (respObj) {
            [self.curModel configModel:respObj];
            //首次请求时列表显示热门数据
            if (self.curModel.hotContentList.count > 0) {
                self.hasHotData = YES;
                self.topicList = [NSMutableArray arrayWithArray:self.curModel.hotContentList];
                
            } else {
                self.hasHotData = NO;
                self.topicList = [NSMutableArray arrayWithArray:self.curModel.contentList];
                
                if (self.curModel.contentList.count == 0) {
                    self.showDefaultImage = YES;
                } else {
                    self.showDefaultImage = NO;
                }
            }
        }
        
        self.titleStr = self.curModel.topicInfo.title;
        self.naviBar.title = self.titleStr;
        
        self.publishBtn.hidden = !self.curModel.topicInfo.is_show_join;
        
        //顶部header，显示话题信息 + 特卖信息
        [self showHeaderView];
        [self.collectionView reloadData];
    }];
}

//刷新或加载更多请求
- (void)sendRefreshRequest {
    if (_hasHotData) {
        _curModel.pageIndex = _curIndex == 0 ? 2 : 1;
    } else {
        _curModel.pageIndex = 1;
    }
    _curModel.last_uniq_id = _curModel.willLoadMore ? _topicList.lastObject.uniq_id : @"0";
    
    @weakify(self);
    [TopicApiManager request_topicDetailRefresh:_curModel completeBlock:^(NSArray *  _Nullable respObj, BOOL hasError) {
        @strongify(self);
        [SVProgressHUD dismiss];
        [self endRefresh];
        
        if (respObj) {
            
            if (self.curModel.willLoadMore) {
                self.topicList = [self.topicList arrayByAddingObjectsFromArray:respObj].mutableCopy;
            } else {
                self.topicList = [NSMutableArray arrayWithArray:respObj];
            }
        }
        
        if (respObj.count <= 0) {
            self.collectionView.mj_footer.hidden = YES;
        } else {
            self.collectionView.mj_footer.hidden = NO;
        }
        [self.collectionView reloadData];
    }];
}


#pragma mark -
#pragma mark - 页面跳转
- (void)enterSaleVC {
    DDLogDebug(@"进入特卖商品列表页");
    JHTopicSaleListController *saleVC = [JHTopicSaleListController new];
    saleVC.item_id = _curModel.saleInfo.item_id;
    [self.navigationController pushViewController:saleVC animated:YES];
}

- (void)enterDetailVCWithData:(JHDiscoverChannelCateModel *)data {
    DDLogDebug(@"从特卖列表进入商品详情页");
    
    if (data.layout == JHSQLayoutTypeImageText) {//图片
        NSLog(@"跳转图文详情。。。。");
        JHDiscoverDetailsVC *vc = [JHDiscoverDetailsVC new];
        vc.cateModel = data;
        vc.item_type = [NSString stringWithFormat:@"%ld", (long)data.item_type];
        vc.item_id = data.item_id;
        vc.entry_type = JHEntryType_Topic_Home_Sale_List;
        vc.entry_id = @"0";
        vc.zanBlock = ^(JHDiscoverChannelCateModel * _Nonnull cateModel) {
            //更新当前collectionviewCell
        };
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (data.layout == JHSQLayoutTypeVideo) {//视频
        NSLog(@"跳转视频详情。。。。");
        JHDiscoverVideoDetailViewController *vc = [JHDiscoverVideoDetailViewController new];
        vc.cateModel = data;
        vc.item_type = [NSString stringWithFormat:@"%ld", (long)data.item_type];
        vc.item_id = data.item_id;
        vc.entry_type = JHEntryType_Topic_Home_Sale_List;
        vc.entry_id = @"0";
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (data.layout == JHSQLayoutTypeAppraisalVideo) {//鉴定剪辑
        JHAppraiseVideoViewController *vc = [[JHAppraiseVideoViewController alloc] init];
        vc.cateId = data.cate_id;
        vc.appraiseId = data.item_id;
        vc.likeChangedBlock = ^(NSString * _Nonnull likeNum) {
            
        };
        vc.from = JHFromSQTopicDetail;

        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (data.layout == JHSQLayoutTypeTopic) { //话题详情
        JHTopicDetailController *vc = [JHTopicDetailController new];
        [vc setTitle:data.title itemId:data.item_id];
        [self.navigationController pushViewController:vc animated:YES];
        
        //埋点 - 进入话题详情埋点
        [JHRootController buryPointWithTopicId:data.item_id];
    }
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetY = scrollView.contentOffset.y; //默认为header高度(-190) + tab选项卡高度（负数）
    CGFloat diffH = offsetY - _startOffsetY; //偏移差值（默认0，上推时递增）
    _alphaValue = diffH / (kHeaderDefaultH - kIgnoreOffsetY*2);
//    NSLog(@"headerH = %f", _headerH);
//    NSLog(@"startY= %.2f, OF= %.2f, DF= %.2f, alpha= %.3f", _startOffsetY, offsetY, diffH, _alphaValue);
    
    if (_alphaValue >= 1) {
        _alphaValue = 0.999;
    }
    [self updateNaviBar];
}


#pragma mark -
#pragma mark - CollectionViewDelegate / DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.showDefaultImage) {
        return  1;
    }
    return _topicList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHDiscoverHomeFlowCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFlowCCellID forIndexPath:indexPath];
    if (self.showDefaultImage) {
        JHDefaultCollectionViewCell *defaultcell = [collectionView dequeueReusableCellWithReuseIdentifier:kDefaultCCellID forIndexPath:indexPath];
        return defaultcell;
    }
    cell.recordMode = _topicList[indexPath.item];
    cell.cellIndex = indexPath.row;
    WEAKSELF
    cell.cellClick = ^(BOOL isLaud, NSInteger index) {
        [weakSelf clickIndex:index isLaud:isLaud];
    };
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.showDefaultImage) {
        return;
    }
    
    JHDiscoverChannelCateModel *model = _topicList[indexPath.item];
    if (model.layout == 1) {//图片
        NSLog(@"从话题详情推荐列表（热门、最新）跳转图文详情。。。。");
        JHDiscoverDetailsVC *vc = [JHDiscoverDetailsVC new];
        vc.cateModel = model;
        vc.item_type = [NSString stringWithFormat:@"%ld", (long)model.item_type];
        vc.item_id = model.item_id;
        vc.entry_type = JHEntryType_Topic_Detail_List;
        vc.entry_id = @"0";
        vc.zanBlock = ^(JHDiscoverChannelCateModel * _Nonnull cateModel) {
            //更新当前collectionviewCell
            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        };
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    }else if (model.layout == 2) {//视频
        NSLog(@"跳转视频详情。。。。");
        JHDiscoverVideoDetailViewController *vc = [JHDiscoverVideoDetailViewController new];
        vc.cateModel = model;
        vc.item_type = [NSString stringWithFormat:@"%ld", (long)model.item_type];
        vc.item_id = model.item_id;
        vc.entry_type = JHEntryType_Topic_Detail_List;
        vc.entry_id = @"0";
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
    }else if (model.layout == 3 ) {//鉴定剪辑
        JHAppraiseVideoViewController *vc = [[JHAppraiseVideoViewController alloc] init];
        vc.cateId = model.cate_id;
        vc.appraiseId = model.item_id;
        vc.likeChangedBlock = ^(NSString * _Nonnull likeNum) {
            model.like_num_int = [likeNum integerValue];
            [collectionView reloadItemsAtIndexPaths:@[indexPath]];
        };
        vc.from = JHFromSQTopicDetail;

        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
        
    } else if (model.layout == JHSQLayoutTypeTopic) {
        //话题详情
        JHTopicDetailController *vc = [JHTopicDetailController new];
        [vc setTitle:model.title itemId:model.item_id];
        [[JHRootController currentViewController].navigationController pushViewController:vc animated:YES];
        //埋点 - 进入话题详情埋点
        [JHRootController buryPointWithTopicId:model.item_id];
    }
}

#pragma mark - CHTCollectionViewDelegateWaterfallLayout
/**
 item size
 */
- (CGSize)hj_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.showDefaultImage) {
        return CGSizeMake(ScreenW, ScreenH - StatusBarAddNavigationBarH - 44);
    }
    JHDiscoverChannelCateModel *model = _topicList[indexPath.item];
    return CGSizeMake((ScreenW-25)/2, model.height);
}

//每组单行的排布个数
- (NSInteger)hj_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout columCountAtSection:(NSInteger)section {
    if (self.showDefaultImage) {
        return 1;
    }
    return 2;
}

//每组头部视图的高度
- (CGFloat)hj_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForHeaderAtSection:(NSInteger)section {
    return 0;
}

//每组尾部视图的高度
- (CGFloat)hj_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout heightForFooterAtSection:(NSInteger)section {
    return 0;
}

//每组的UIEdgeInsets
- (UIEdgeInsets)hj_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSection:(NSInteger)section{
    return UIEdgeInsetsMake(5, 10, 5, 10);
}

//每组的minimumLineSpacing 行与行之间的距离
- (CGFloat)hj_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSection:(NSInteger)section{
    return 5;
}

//每组的minimumInteritemSpacing 同一行item之间的距离
- (CGFloat)hj_collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSection:(NSInteger)section {
    return 5;
}

- (void)clickIndex:(NSInteger)index isLaud:(BOOL)laud {
    
    if ([self isLogin]) {
        JHDiscoverChannelCateModel * model = [_topicList objectAtIndex:index];
        if ([self.pubuZaningArr containsObject:model.item_id]) {
            return;
        }
        [self.pubuZaningArr addObject:model.item_id];
        if (laud) {
            //瀑布流点赞
            [JHDiscoverChannelViewModel cancleLikeItemWithItemid:model.item_id item_type:model.item_type itemLikeCount:model.like_num_int success:^(RequestModel * _Nonnull request) {
                [self.pubuZaningArr removeObject:model.item_id];
                model.like_num = [NSString stringWithFormat:@"%@", request.data[@"like_num"]];
                model.like_num_int = [request.data[@"like_num_int"] integerValue];
                model.is_like = 0;
                
                JHDiscoverHomeFlowCollectionCell *cell =(JHDiscoverHomeFlowCollectionCell*) [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                [cell beginAnimation:model];
                
            } failure:^(RequestModel * _Nonnull request) {
                [self.pubuZaningArr removeObject:model.item_id];
                [UITipView showTipStr:request.message];
            }];
        } else {
            //瀑布流点赞
            [JHDiscoverChannelViewModel likeItemWithItemid:model.item_id item_type:model.item_type itemLikeCount:model.like_num_int success:^(RequestModel * _Nonnull request) {
                [self.pubuZaningArr removeObject:model.item_id];
                model.like_num = [NSString stringWithFormat:@"%@", request.data[@"like_num"]];
                model.like_num_int = [request.data[@"like_num_int"] integerValue];
                model.is_like = 1;
                
                JHDiscoverHomeFlowCollectionCell *cell =(JHDiscoverHomeFlowCollectionCell*) [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]];
                [cell beginAnimation:model];
                
            } failure:^(RequestModel * _Nonnull request) {
                [self.pubuZaningArr removeObject:model.item_id];
                [UITipView showTipStr:request.message];
            }];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.showDefaultImage) {
        return;
    }
    
    JHDiscoverChannelCateModel *cateModel = _topicList[indexPath.item];
    //NSTimeInterval timeSp = (long)[[NSDate date] timeIntervalSince1970]*1000;
    long long timeSp = [[YDHelper get13TimeStamp] longLongValue];
    //NSLog(@"startTimeSp = %f", timeSp);
    //判断originArr或者canUploadArr是否存在,存在则不进行任何操作
    for (JHDiscoverStatisticsModel *model in self.canUploadArr) {
        if ([model.item_uniq_id isEqualToString:cateModel.item_uniq_id]) {
            return;
        }
    }
    
    for (JHDiscoverStatisticsModel *model in self.originArr) {
        if ([model.item_uniq_id isEqualToString:cateModel.item_uniq_id]) {
            return;
        }
    }
    
    JHDiscoverStatisticsModel *model = [JHDiscoverStatisticsModel new];
    model.item_uniq_id = cateModel.item_uniq_id;
    model.startTime = timeSp;
    [self.originArr addObject:model];
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.showDefaultImage) {
        return;
    }
    //比较该cell是否出现超过限制
    //NSTimeInterval timeSp = (long)[[NSDate date] timeIntervalSince1970]*1000;
    long long timeSp = [[YDHelper get13TimeStamp] longLongValue];
    NSMutableArray *removeOrignalArr = [NSMutableArray array];
    
    if (indexPath.item < _topicList.count) {
        JHDiscoverChannelCateModel *cateModel = _topicList[indexPath.item];
        
        for (JHDiscoverStatisticsModel *staticModel in self.originArr) {
            if ([staticModel.item_uniq_id isEqualToString:cateModel.item_uniq_id]) {
                //找到相应的item,加入waitUploadArr,canUploadArr,并且从originArr移除
                if (timeSp - staticModel.startTime >= kStatiscGapTime) {
                    [self.waitUploadArr addObject:staticModel];
                    [self.canUploadArr addObject:staticModel];
                }
                [removeOrignalArr addObject:staticModel];
                // NSLog(@"didEndDisplayingCell row = %ld, str = %@", indexPath.item, staticModel.item_id);
            }
        }
    }
    [self.originArr removeObjectsInArray:removeOrignalArr];
    // NSLog(@"didEndDisplayingCell row = %ld, cout = %ld", indexPath.item, self.originArr.count);
}

- (BOOL)isLogin {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVCWithTarget:self complete:^(BOOL result) {
            if (result){
                
            }
        }];
        return  NO;
    }
    return  YES;
}

- (NSMutableArray *)pubuZaningArr {
    if (!_pubuZaningArr) {
        _pubuZaningArr = [NSMutableArray array];
    }
    return _pubuZaningArr;
}

- (void)addTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(uploadStatics) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)destoryTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

//下拉刷新
- (void)refreshStatics:(BOOL)isDisAppear {
    //比较该cell是否出现超过限制
    //NSTimeInterval timeSp = (long)[[NSDate date] timeIntervalSince1970]*1000;
    long long timeSp = [[YDHelper get13TimeStamp] longLongValue];
    //NSLog(@"endTimeSp = %f", timeSp);
    for (JHDiscoverStatisticsModel *staticModel in self.originArr) {
        //找到相应的item,加入waitUploadArr,canUploadArr,并且从originArr移除
        if (timeSp - staticModel.startTime >= kStatiscGapTime) {
            [self.waitUploadArr addObject:staticModel];
            [self.canUploadArr addObject:staticModel];
        }
    }
    if (!isDisAppear) {
        [self.originArr removeAllObjects];
    }
    
    JHBuryPointCommunityArticleModel *pointModel = [JHBuryPointCommunityArticleModel new];
    pointModel.entry_type = 3;
    pointModel.entry_id = @"0";
    pointModel.time = [NSString stringWithFormat:@"%lld", timeSp];
    
    NSString *appStr = @"";
    for (int i = 0; i < self.waitUploadArr.count; i++) {
        JHDiscoverStatisticsModel *staticModel = self.waitUploadArr[i];
        if (i == 0) {
            appStr = staticModel.item_uniq_id;
        }else {
            [appStr stringByAppendingString:[NSString stringWithFormat:@",%@", staticModel.item_uniq_id]];
        }
    }
    NSLog(@"row =下拉刷新上报埋点搜索页appstr = %@", appStr);
    pointModel.item_ids = appStr;
    
    if (![NSString empty:appStr]) {
        [[JHBuryPointOperator shareInstance] scanCommunityArticleWithModel:pointModel];
        [self.waitUploadArr removeAllObjects];
    }
    //还要取消定时器，开启新定时器
    if (!isDisAppear) {
        [self addTimer];
    }else {
        [self destoryTimer];
    }
}

- (void)uploadStatics {
    // NSLog(@"定时器响应");
    
    //比较该cell是否出现超过限制
    //NSTimeInterval timeSp = (long)[[NSDate date] timeIntervalSince1970]*1000;
    long long timeSp = [[YDHelper get13TimeStamp] longLongValue];
    //NSLog(@"endTimeSp = %f", timeSp);
    NSMutableArray *removeOrignalArr = [NSMutableArray array];
    for (JHDiscoverStatisticsModel *staticModel in self.originArr) {
        //找到相应的item,加入waitUploadArr,canUploadArr,并且从originArr移除
        if (timeSp - staticModel.startTime >= kStatiscGapTime) {
            [self.waitUploadArr addObject:staticModel];
            [self.canUploadArr addObject:staticModel];
            [removeOrignalArr addObject:staticModel];
        }
    }
    [self.originArr removeObjectsInArray:removeOrignalArr];
    
    JHBuryPointCommunityArticleModel *pointModel = [JHBuryPointCommunityArticleModel new];
    pointModel.entry_type = 3;
    pointModel.entry_id = @"0";
    pointModel.time = [NSString stringWithFormat:@"%lld", timeSp];
    
    NSString *appStr = @"";
    // NSLog(@"row = waitUploadArrCount = %ld", self.waitUploadArr.count);
    for (int i = 0; i < self.waitUploadArr.count; i++) {
        JHDiscoverStatisticsModel *staticModel = self.waitUploadArr[i];
        if (i == 0) {
            appStr = staticModel.item_uniq_id;
        }else {
            appStr = [appStr stringByAppendingString:[NSString stringWithFormat:@",%@", staticModel.item_uniq_id]];
        }
    }
    // NSLog(@"appstr = %@", appStr);
    pointModel.item_ids = appStr;
    
    if (![NSString empty:appStr]) {
        NSLog(@"row =定时器上报埋点appstr = %@", appStr);
        [[JHBuryPointOperator shareInstance] scanCommunityArticleWithModel:pointModel];
        [self.waitUploadArr removeAllObjects];
    }
}

- (NSMutableArray *)originArr {
    if (!_originArr) {
        _originArr = [NSMutableArray array];
    }
    return _originArr;
}

- (NSMutableArray *)waitUploadArr {
    if (!_waitUploadArr) {
        _waitUploadArr = [NSMutableArray array];
    }
    return _waitUploadArr;
}

- (NSMutableArray *)canUploadArr {
    if (!_canUploadArr) {
        _canUploadArr = [NSMutableArray array];
    }
    return _canUploadArr;
}


@end
