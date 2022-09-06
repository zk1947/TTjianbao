//
//  JHStoreDetailCycleView.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailCycleView.h"
#import "JHStoreDetailCycleItem.h"
#import "JHStoreDetailBaseFlowLayout.h"
#import "JHPhotoBrowserManager.h"
#import "UIColor+ColorChange.h"

@interface JHStoreDetailCycleView()<UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    BOOL hasVideo;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) UILabel *pageLabel;
@end

@implementation JHStoreDetailCycleView

#pragma mark - Life Cycle Functions
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self registerCells];
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [self layoutViews];
}
- (void)dealloc {
    NSLog(@"商品详情-%@ 释放", [self class]);
}
#pragma mark - Action functions
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    if (hasVideo && indexPath.row == 0) {  return; }
    
    [JHPhotoBrowserManager showPhotoBrowserThumbImages:self.viewModel.thumbsUrls
                                            origImages:self.viewModel.largeUrls
                                               sources:@[[UIImageView new]]
                                          currentIndex:self.currentIndex - 1
                                   canPreviewOrigImage:true
                                             showStyle:GKPhotoBrowserShowStyleNone
                                         hideDownload : true];
    
    
}
#pragma mark - Private Functions
#pragma mark - Bind
- (void)bindData {
    [self.viewModel.refreshView subscribeNext:^(id  _Nullable x) {
        [self setupData];
    }];
}
- (void)setupData {
    for (JHStoreDetailCycleItemViewModel *model in self.viewModel.itemList) {
        if (model.type == Video) {
            hasVideo = true;
            break;
        }
    }
    if (hasVideo == false) {
        self.currentIndex = 1;
    }
    [self setPageHidenWithIndex:0];
    [self.collectionView reloadData];
}
- (void)setPageHidenWithIndex : (NSInteger)index {
    if (hasVideo && index == 0) {
        [self.pageLabel setHidden:true];
    }else{
        [self.pageLabel setHidden:false];
    }
    [self setCurrentIndexWithIndex:index];
}
- (void)setCurrentIndexWithIndex : (NSInteger) index {
    if (hasVideo) {
        self.currentIndex = index;
    }else {
        self.currentIndex = index + 1;
    }
}
#pragma mark - setupUI
- (void)setupUI {
    self.backgroundColor = UIColor.blueColor;
    [self addSubview:self.collectionView];
    [self addSubview:self.pageLabel];
}
- (void)layoutViews {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    [self.pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-12);
        make.right.equalTo(self).offset(-12);
        make.size.mas_equalTo(CGSizeMake(50, 24));
    }];
}
- (void) registerCells {
    [self.collectionView registerClass:[JHStoreDetailCycleItem class] forCellWithReuseIdentifier:@"JHStoreDetailCycleItem" ];
    [self.collectionView registerClass:[JHStoreDetailCycleVideoItem class] forCellWithReuseIdentifier:@"JHStoreDetailCycleVideoItem" ];
}
#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 停止类型1、停止类型2
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self setPageHidenWithIndex:index];
    self.displayIndex = index;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    JHStoreDetailCycleItemViewModel *model = self.viewModel.itemList[indexPath.item];
    if (model.type == Video && self.videoView == nil ) {
        self.videoView = (JHStoreDetailCycleVideoItem*) cell;
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.viewModel.itemList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHStoreDetailCycleItemViewModel *model = self.viewModel.itemList[indexPath.item];
    
    if (model.type == Video) {
        JHStoreDetailCycleVideoItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHStoreDetailCycleVideoItem" forIndexPath:indexPath];

        [item setupViewModel:model];
        return item;
    }
    JHStoreDetailCycleItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHStoreDetailCycleItem" forIndexPath:indexPath];
    [item setupViewModel:model];
    return item;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHStoreDetailCycleItemViewModel *model = self.viewModel.itemList[indexPath.item];
    return CGSizeMake(model.width, model.height);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.01f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.01f;
}
#pragma mark - Lazy
- (void)setViewModel:(JHStoreDetailCycleViewModel *)viewModel {
    _viewModel = viewModel;
    [self bindData];
}
- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    NSInteger count = self.viewModel.itemList.count;
    if (hasVideo) {
        count = count -1;
    }
    self.pageLabel.text = [NSString stringWithFormat: @"%ld/%lu", (long)currentIndex, (long)count];
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        JHStoreDetailBaseFlowLayout *layout = [[JHStoreDetailBaseFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.showsHorizontalScrollIndicator = false;
        [_collectionView setPagingEnabled:true];

    }
    return _collectionView;
}
- (UILabel *)pageLabel {
    if (!_pageLabel) {
        _pageLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _pageLabel.font = [UIFont boldSystemFontOfSize:13];
        _pageLabel.textColor = UIColor.whiteColor;
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        _pageLabel.backgroundColor = [UIColor colorWithHexString:@"000000" alpha:0.6];
        _pageLabel.layer.cornerRadius = 12;
        _pageLabel.layer.masksToBounds = true;
    }
    return _pageLabel;
}
@end
