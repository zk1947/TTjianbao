//
//  JHSearchResultTopTextFieldView.m
//  TTjianbao
//
//  Created by hao on 2021/11/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHSearchResultTopTextFieldView.h"
#import "JHSearchTagsCollectionCell.h"
#import "JHNewSearchResultRecommendTagsModel.h"

@interface JHSearchResultTopTextFieldView ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation JHSearchResultTopTextFieldView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColor.whiteColor;
        [self initSubviews];
        [self addObserveValue];
    }
    return self;
}

#pragma mark - UI
- (void)initSubviews{
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


#pragma mark - LoadData
- (void)setTagsDataArray:(NSArray *)tagsDataArray{
    _tagsDataArray = tagsDataArray;
    [self.collectionView reloadData];
}

#pragma mark - Action
- (void)setSearchText:(NSString *)searchText{
    _searchText = searchText;
    //把默认搜索词包装成model列表
    JHNewSearchResultRecommendTagsListModel *model = [[JHNewSearchResultRecommendTagsListModel alloc] init];
    model.tagWord = searchText;
    model.cateId = @"-1";
    self.tagsDataArray = @[model];
}

- (void)setSearchTagsArray:(NSMutableArray *)searchTagsArray{
    _searchTagsArray = searchTagsArray;
    [_searchTagsArray insertObjects:self.tagsDataArray atIndex:0];

    self.tagsDataArray = _searchTagsArray;
}
- (void)addObserveValue{
    @weakify(self)
    [[RACObserve(self, tagsDataArray) skip:1] subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        NSArray *searchArray = x;
        NSMutableArray *recommendArray = [NSMutableArray array];
        self.searchWord = @"";
        for (JHNewSearchResultRecommendTagsListModel *tagModel in searchArray) {
            if ([tagModel.cateId integerValue] < 0) { //搜索词
                self.searchWord = tagModel.tagWord;
            } else { //推荐关键词
                [recommendArray addObject:tagModel.tagWord];
            }
        }
        if (self.searchWord.length <= 0) {
            self.searchWord = recommendArray[0];
        }
        if (recommendArray.count > 0) {
            self.isAddRecommendTags = YES;
        }
        self.recommendTagsArray = [NSMutableArray arrayWithArray:recommendArray];

    }];
}

- (CGSize)calculationTextWidthWithString:(NSString *)string font:(UIFont *)font {
    CGSize size = [string boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,NSFontAttributeName:font} context:nil].size;
    return size;
}


#pragma mark - Delegate
#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.tagsDataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHSearchTagsCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHSearchTagsCollectionCell class]) forIndexPath:indexPath];
    @weakify(self)
    cell.clickDeleteBtnBlock = ^{
        @strongify(self)
        NSMutableArray *tagsArray = self.searchTagsArray;
        [tagsArray removeObjectAtIndex:indexPath.row];
        self.tagsDataArray = tagsArray;
        if (self.searchTagsArray.count == 0) {
            if (self.deleteAllTagsBlock) {
                self.deleteAllTagsBlock();
            }
        }
            
    };
    
    [cell bindViewModel:self.tagsDataArray[indexPath.row] params:nil];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    JHNewSearchResultRecommendTagsListModel *model = self.tagsDataArray[indexPath.row];
    CGSize size = [self calculationTextWidthWithString:model.tagWord font:JHFont(13)];
    return CGSizeMake(size.width+31, 22);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
   
}
#pragma mark - Lazy
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout * flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 12;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.contentInset = UIEdgeInsetsMake(0, 6, 0, 6);

        [_collectionView registerClass:[JHSearchTagsCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([JHSearchTagsCollectionCell class])];

    }
    return _collectionView;
}


@end
