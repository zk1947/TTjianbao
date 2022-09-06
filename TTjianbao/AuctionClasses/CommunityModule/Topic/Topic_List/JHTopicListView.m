//
//  JHTopicListView.m
//  TTjianbao
//
//  Created by wuyd on 2019/12/10.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHTopicListView.h"
#import "CTopicModel.h"
#import "TopicApiManager.h"
#import "JHTopicSelectListFlowLayout.h"
#import "JHTopicListCCell.h"
#import "JHTopicSelectListFooter.h"
#import "TTjianbaoHeader.h"
#import "UIView+Blank.h"
#import "JHRefreshGifHeader.h"
#import "YDRefreshFooter.h"

@interface JHTopicListView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) CTopicModel *curModel;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) JHRefreshGifHeader *refreshHeader;
@property (nonatomic, strong) YDRefreshFooter *refreshFooter;

@end

@implementation JHTopicListView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _curModel = [[CTopicModel alloc] init];
        
        [self configCollectionView];
        
        [self sendRequest];
    }
    return self;
}


#pragma mark -
#pragma mark - CollectionView Methods

- (void)configCollectionView {
    JHTopicSelectListFlowLayout *layout = [[JHTopicSelectListFlowLayout alloc] init];
    _collectionView = ({
        UICollectionView *ccView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, self.height) collectionViewLayout:layout];
        ccView.backgroundColor = [UIColor whiteColor];
        ccView.delegate = self;
        ccView.dataSource = self;
        ccView.alwaysBounceVertical = YES;
        ccView.showsHorizontalScrollIndicator = NO;
        ccView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        
        [ccView registerClass:[JHTopicSelectListFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterId_JHTopicSelectListFooter];
        
        [ccView registerClass:[JHTopicListCCell class] forCellWithReuseIdentifier:kCCellId_JHTopicListCCell];
        
        [self addSubview:ccView];
        
        ccView.mj_header = self.refreshHeader;
        ccView.mj_footer = self.refreshFooter;
        
        [ccView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        ccView;
    });
}

- (JHRefreshGifHeader *)refreshHeader {
    if (!_refreshHeader) {
        _refreshHeader = [JHRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refresh)];
        _refreshHeader.automaticallyChangeAlpha = NO;
    }
    return _refreshHeader;
}

- (YDRefreshFooter *)refreshFooter {
    if (!_refreshFooter) {
        _refreshFooter = [YDRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshMore)];
        _refreshFooter.autoTriggerTimes = YES; //每次拖拽只发送一次请求
    }
    return _refreshFooter;
}

- (void)endRefresh {
    [_collectionView.mj_header endRefreshing];
    [_collectionView.mj_footer endRefreshing];
}


#pragma mark -
#pragma mark - 网络请求

- (void)refresh {
    if (_curModel.isLoading) {
        return;
    }
    _curModel.willLoadMore = NO;
    [self sendRequest];
}

- (void)refreshMore {
    if (_curModel.isLoading) {
        return;
    }
    _curModel.willLoadMore = YES;
    [self sendRequest];
}

- (void)sendRequest {
    if (_curModel.isFirstReq && _curModel.list.count == 0) {
        [self beginLoading];
    }
    @weakify(self);
    [TopicApiManager request_topicList:_curModel completeBlock:^(CTopicModel * _Nullable respObj, BOOL hasError) {
        @strongify(self);
        [self endLoading];
        [self endRefresh];
        
        if (respObj) {
            [self.curModel configModel:respObj];
            
            [self.collectionView reloadData];
            
            if (self.curModel.canLoadMore) {
                [self.refreshFooter endRefreshing];
            } else {
                [self.refreshFooter endRefreshingWithNoMoreData];
            }
        } else {
            [self.refreshFooter endRefreshingWithNoMoreData];
        }
        
        [self configBlankType:YDBlankTypeNoAllTopicList hasData:_curModel.list.count > 0 hasError:hasError offsetY:0 reloadBlock:^(id sender) {
            NSLog(@"点击刷新按钮");
            //[self refresh];
        }];
    }];
}


#pragma mark -
#pragma mark - CollectionViewDelegate / DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _curModel.list.count;
}

//头视图高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

//尾视图高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeMake(ScreenWidth, [JHTopicSelectListFooter footerHeight]);
}

//头部视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        JHTopicSelectListFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterId_JHTopicSelectListFooter forIndexPath:indexPath];
        return footer;
    }
    return nil;
}

//itemSize
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return [JHTopicListCCell ccellSize];
}

//绘制cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHTopicListCCell* ccell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellId_JHTopicListCCell forIndexPath:indexPath];
    ccell.curData = _curModel.list[indexPath.row];
    return  ccell;
}

//点击cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CTopicData *data = _curModel.list[indexPath.row];
    if (self.didSelectedBlock) {
        self.didSelectedBlock(data);
    }
}

@end
