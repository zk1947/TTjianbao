//
//  JHTopicSelectListView.m
//  TTjianbao
//
//  Created by wuyd on 2019/7/30.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHTopicSelectListView.h"
#import "CTopicModel.h"
#import "TopicApiManager.h"
#import "JHTopicSelectListHeader.h"
#import "JHTopicSelectListFooter.h"
#import "JHTopicSelectListFlowLayout.h"
#import "JHTopicListCCell.h"
#import "JHTopicListUnSelectCCell.h"
#import "TTjianbaoHeader.h"


@interface JHTopicSelectListView () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) CTopicModel *curModel;
@property (nonatomic, strong) UICollectionView *collectionView;

@end


@implementation JHTopicSelectListView

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
        
        [ccView registerClass:[JHTopicSelectListHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderId_JHTopicSelectListHeader];
        
        [ccView registerClass:[JHTopicSelectListFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterId_JHTopicSelectListFooter];
        
        [ccView registerClass:[JHTopicListCCell class] forCellWithReuseIdentifier:kCCellId_JHTopicListCCell];
        [ccView registerClass:[JHTopicListUnSelectCCell class] forCellWithReuseIdentifier:kCCellId_JHTopicListUnSelectCCell];
        
        [self addSubview:ccView];
        
        [ccView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
        
        ccView;
    });
}


#pragma mark -
#pragma mark - 网络请求
- (void)sendRequest {
    @weakify(self);
    [TopicApiManager request_topicListWithKeyword:@"" completeBlock:^(CTopicModel * _Nullable respObj, BOOL hasError) {
        @strongify(self);
        if (respObj) {
            self.curModel = respObj;
            [UIView transitionWithView:self.collectionView duration:0.25 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                [self.collectionView reloadData];
            } completion:^(BOOL finished) {}];
        }
    }];
}


#pragma mark -
#pragma mark - CollectionViewDelegate / DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (section == 0 ? 1 : _curModel.list.count);
}

//头视图高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return (section == 0 ? CGSizeZero : CGSizeMake(ScreenWidth, [JHTopicSelectListHeader headerHeight]));
}

//尾视图高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return (section == 0 ? CGSizeZero : CGSizeMake(ScreenWidth, [JHTopicSelectListFooter footerHeight]));
}

//头部视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1) {
        if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
            JHTopicSelectListHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderId_JHTopicSelectListHeader forIndexPath:indexPath];
            return header;
            
        } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
            JHTopicSelectListFooter *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFooterId_JHTopicSelectListFooter forIndexPath:indexPath];
            return footer;
        }
    }
    return nil;
}

//itemSize
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [JHTopicListUnSelectCCell ccellSize];
    }
    return [JHTopicListCCell ccellSize];
}

//绘制cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        JHTopicListUnSelectCCell* ccell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellId_JHTopicListUnSelectCCell forIndexPath:indexPath];
        return  ccell;

    } else {
        JHTopicListCCell* ccell = [collectionView dequeueReusableCellWithReuseIdentifier:kCCellId_JHTopicListCCell forIndexPath:indexPath];
        ccell.curData = _curModel.list[indexPath.row];
        return  ccell;
    }
}

//点击cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.didSelectedBlock) {
            self.didSelectedBlock(nil);
        }
        
    } else {
        CTopicData *data = _curModel.list[indexPath.row];
        if (self.didSelectedBlock) {
            self.didSelectedBlock(data);
        }
    }
}

@end
