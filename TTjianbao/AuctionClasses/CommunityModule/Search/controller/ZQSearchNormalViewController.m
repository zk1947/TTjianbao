//
//  ZQSearchNormalViewController.m
//  ZQSearchController
//
//  Created by zzq on 2018/9/25.
//  Copyright © 2018年 zzq. All rights reserved.
//

#import "ZQSearchNormalViewController.h"
#import "ZQSearchNormalLayout.h"
#import "ZQSearchNormalCell.h"
#import "ZQSearchCollectionReusableView.h"
#import "ZQSearchConst.h"
#import "JHTopicListCCell.h"
#import "JHTopicDetailController.h"

#import "JHBuryPointOperator.h"
///3.1.7新增  热搜词
#import "JHHotwordCCell.h"
#import "JHHotWordModel.h"
#import "SearchKeyListCCell.h"
#import "JHSQManager.h"

static NSString *normalHeaderIdentifier = @"headerIdentifier";
static NSString *normalFooterIdentifier = @"footerIdentifier";
static NSString *normalCellIdentifier = @"cellIdentifier";

@interface ZQSearchNormalViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) NSArray<JHHotWordModel *> *hotList;
@property (nonatomic, strong) NSArray<CTopicData *> *topicList;

/// 折叠的时候数据
//@property (nonatomic , strong) NSMutableArray * foldArray;
@property(nonatomic, assign) BOOL isShowAllSearch;


@end

@implementation ZQSearchNormalViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.foldArray = [NSMutableArray array];
    self.isShowAllSearch = YES;
    [self setupCollectionView];
    [self loadHistorySource];
}

- (void)viewWillLayoutSubviews {
    self.collectionView.frame = self.view.bounds;
}

#pragma mark - config ui
- (void)setupCollectionView {
    [self.view addSubview:self.collectionView];
    
    //    [self.collectionView registerClass:[ZQSearchNormalCell class] forCellWithReuseIdentifier:normalCellIdentifier];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ZQSearchNormalCell" bundle:nil] forCellWithReuseIdentifier:normalCellIdentifier];
    
    [self.collectionView registerClass:[JHHotwordCCell class] forCellWithReuseIdentifier:@"JHHotwordCCell"];
    
    [self.collectionView registerClass:[SearchKeyListCCell class] forCellWithReuseIdentifier:kCCellId_SearchHistoryListCCell];
    
    [self.collectionView registerClass:[JHTopicListCCell class] forCellWithReuseIdentifier:kCCellId_JHTopicListCCell];
    
    [self.collectionView registerClass:[ZQSearchCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:normalHeaderIdentifier];
    
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:normalFooterIdentifier];
}

#pragma mark - config data
- (void)setHotDataSource:(NSArray *)datas {
    if (datas) {
        self.hotList = datas.copy;
    } else {
        self.hotList = [NSArray new];
    }
    [self.collectionView reloadData];
}

///设置热搜词
- (void)setHotList:(NSArray<JHHotWordModel *> *)hotList {
    if (!hotList) {
        return;
    }
    _hotList = hotList.copy;
    [self.collectionView reloadData];
}

///设置话题
- (void)setTopicList:(NSArray<CTopicData *> *)topicList {
    if (!topicList) {
        return;
    }
    _topicList = topicList.copy;
    [self.collectionView reloadData];
}

- (void)loadHistorySource {
    [self.collectionView reloadData];
}

- (void)refreshHistoryView {
    [self.collectionView reloadData];
}

#pragma mark -
#pragma mark - UICollectionViewDelegateFlowLayout

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (section != 0) {
        return UIEdgeInsetsMake(9, 20, 0, 20);
        
    } else {
        return UIEdgeInsetsMake(0, 15, 0, 15);
    }
}

//self.sectionInset = UIEdgeInsetsMake(0, 15, 0, 15); //整体边距
//self.minimumLineSpacing = 10.0;
//self.minimumInteritemSpacing = 5.0;

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 2) {  ///行与行之间的间距
        return 20.0f;
    }
    return 10.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return 5.0f;
    }
    return 10.0f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0 && self.topicList.count == 0) {
        return CGSizeMake(ScreenWidth, 0.f);
    }
    if (section == 1 && self.historyList.count == 0) {
        return CGSizeMake(ScreenWidth, 0.f);
    }
    if (section == 2 && self.hotList.count == 0) {
        return CGSizeMake(ScreenWidth, 0.f);
    }
    return CGSizeMake(ScreenWidth, 40.0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 0 && self.topicList.count == 0) {
        return CGSizeMake(ScreenWidth, 0.f);
    }
    if (section == 1 && self.historyList.count == 0) {
        return CGSizeMake(ScreenWidth, 0.f);
    }
    if (section == 2 && self.hotList.count == 0) {
        return CGSizeMake(ScreenWidth, 0.f);
    }
    return CGSizeMake(ScreenWidth, 20);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) { ///话题
        return [JHTopicListCCell ccellSize];
    }
    if (indexPath.section == 1) { ///历史记录
        NSString *string = self.historyList[indexPath.item].keyword;
        CGSize size = [string sizeForFont:[UIFont fontWithName:kFontNormal size:12.0] size:CGSizeMake(HUGE, 30) mode:NSLineBreakByWordWrapping];
        CGFloat cellWidth = (size.width+26) > (ScreenW-30) ? (ScreenW - 30) : (size.width+26);
        return CGSizeMake(cellWidth, 30.0f);
    }
    if (indexPath.section == 2) { ///热门搜索
        return CGSizeMake((ScreenW - 60)/2, 18);
    }
    return CGSizeZero;
}

#pragma mark -
#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) { //热门话题
        return self.topicList.count;
    }
    else if (section == 1) { //历史记录
        if (_isShowAllSearch) {
            return self.historyList.count;
        } else {
            return 0;
        }
    }
    else { //热门搜索
        return self.hotList.count;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        BOOL showDeleteBtn = NO;
        BOOL showMoreImagv = NO;
        ZQSearchCollectionReusableView *header = (ZQSearchCollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:normalHeaderIdentifier forIndexPath:indexPath];
        if (indexPath.section == 0) {
            header.title = @"热门话题";
        } else if (indexPath.section == 1) {
            header.title = @"历史记录";
        } else {
            header.title = @"热门搜索";
        }
        showDeleteBtn = indexPath.section == 1;
        showMoreImagv = indexPath.section == 1;
        
        @weakify(self)
        header.foldBlock = ^(BOOL isAll) {
            @strongify(self);
            self.isShowAllSearch = isAll;
            [self.collectionView reloadData];
        };
        
        [header showDeleteHistoryBtn:showDeleteBtn showMoreBtn:showMoreImagv unfoldStatus:self.isShowAllSearch CallBack:^{
            @strongify(self)
            [self.historyList removeAllObjects];
            [self removeSearchHistory];
//            [NSKeyedArchiver archiveRootObject:self.historyList toFile:ZQ_SEARCH_HISTORY_CACHE_PATH];
            [self.collectionView reloadData];
        }];
        return header;
        
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:normalFooterIdentifier forIndexPath:indexPath];
        UIView *linV = [[UIView alloc] init];
        if (indexPath.section == 0) {
            ///热门话题
            linV.frame = CGRectMake(0, 15, ScreenWidth, 5);
            linV.backgroundColor = [UIColor colorWithHexString:@"F8F8F8"];
        }
        else if (indexPath.section == 1) {
            linV.frame = CGRectMake(0, 15, ScreenWidth, 5);
            NSString *color = self.hotList.count > 0 ? @"F8F8F8" : @"ffffff";
            linV.backgroundColor = [UIColor colorWithHexString:color];
        }
        else {
            linV.frame = CGRectMake(0, 0, ScreenWidth, 20);
            linV.backgroundColor = [UIColor whiteColor];
        }
        [footer addSubview:linV];
        return footer;
        
    }
    return nil;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ///热门话题
        JHTopicListCCell* ccell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellId_JHTopicListCCell forIndexPath:indexPath];
        ccell.curData = _topicList[indexPath.row];
        return  ccell;
    }
    
    if (indexPath.section == 1) {
        /// 历史记录
        SearchKeyListCCell* ccell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellId_SearchHistoryListCCell forIndexPath:indexPath];
        CSearchKeyData *data = self.historyList[indexPath.item];
        [ccell setKeyData:data isHot:YES];
        return  ccell;
    }
    
    ///热门搜索
    JHHotwordCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHHotwordCCell" forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.searchData = self.hotList[indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ///热门话题
        CTopicData *data = _topicList[indexPath.row];
        [JHRouterManager pushTopicDetailWithTopicId:data.item_id pageType:JHPageTypeSQHomePostSearch];
        //埋点 - 进入话题详情埋点
        [self buryPointWithTopicId:data.item_id];
        return;
    }
    ///热门搜索  & 历史记录
    id value;
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchChildViewDidSelectItem:)]) {
        if (indexPath.section == 1) { ///历史记录
            value = self.historyList[indexPath.item];
        }
        else {
            value = self.hotList[indexPath.item];
        }
        [self.delegate searchChildViewDidSelectItem:value];
    }
    if (indexPath.section == 1) {
//        [Growing track:@"searchhistory"];
        //搜索历史埋点
        if ([value isKindOfClass:[CSearchKeyData class]]) {
            CSearchKeyData *data = (CSearchKeyData *)value;
            [JHGrowingIO trackEventId:JHLive_search_in variables:@{@"dz_search":data.keyword,@"dz_search_type":@"historySearch"}];
        }
        
    }
    else if (indexPath.section == 2) {
//        [Growing track:@"hotsearch"];
        //关键词埋点
        if ([value isKindOfClass:[JHHotWordModel class]]) {
            JHHotWordModel *model = (JHHotWordModel *)value;
            [JHGrowingIO trackEventId:JHLive_search_in variables:@{@"dz_search":model.title,@"dz_search_type":@"hotSearch"}];
        }
    }
}

//新增进入话题页埋点
- (void)buryPointWithTopicId:(NSString *)topicId {
    JHBuryPointEnterTopicDetailModel *pointModel = [JHBuryPointEnterTopicDetailModel new];
    pointModel.entry_type = 8;
    pointModel.entry_id = @"0";
    pointModel.topic_id = topicId;
    long long timeSp = [[YDHelper get13TimeStamp] longLongValue];
    pointModel.time = timeSp;
    [[JHBuryPointOperator shareInstance] enterTopicDetailWithModel:pointModel];
}

#pragma mark -
#pragma mark - UICollectionViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchChildViewDidScroll)]) {
        [self.delegate searchChildViewDidScroll];
    }
}

#pragma mark - getter & setter

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        ZQSearchNormalLayout *layout = [[ZQSearchNormalLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.alwaysBounceVertical = YES;
    }
    return _collectionView;
}

- (NSMutableArray *)historyList {
    if (!_historyList) {
        _historyList = [NSMutableArray arrayWithArray:[CSearchKeyModel loadHistoryList]];
    }
    return _historyList;
}

#pragma mark - 存储相关
///删除搜索历史
- (void)removeSearchHistory {
    [CSearchKeyModel removeAllHistory];
    self.historyList = [NSMutableArray arrayWithArray:[CSearchKeyModel loadHistoryList]];
    [UIView performWithoutAnimation:^{
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
        [self.collectionView reloadSections:indexSet];
    }];
}

///更新搜索历史
- (void)updateHistoryList {
    self.historyList = [NSMutableArray arrayWithArray:[CSearchKeyModel loadHistoryList]];
    if (self.historyList.count > 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [UIView performWithoutAnimation:^{
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
                [self.collectionView reloadSections:indexSet];
            }];
        });
    }
}

- (void)dealloc {
    NSLog(@"ZQSearchNormalViewController dealloc");
}

@end
