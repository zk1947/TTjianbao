//
//  JHChatMediaView.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/13.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatMediaView.h"
#import "JHChatMediaCell.h"


@interface JHChatMediaView()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionView *collectionView;

@end
@implementation JHChatMediaView

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
    NSLog(@"回收订单详情-%@ 释放", [self class]);
    [NSNotificationCenter.defaultCenter removeObserver:self];
}
#pragma mark - Public
- (void)setupMedias : (NSArray<JHChatMediaModel *> *)mediaList {
    self.mediaList = [NSMutableArray arrayWithArray: mediaList];
    [self.collectionView reloadData];
}
#pragma mark - Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    JHChatMediaModel *model = self.mediaList[indexPath.item];
    [self.selectedSubject sendNext:model];
}
#pragma mark - UI
- (void)setupUI {
    [self addSubview:self.collectionView];
}
- (void)layoutViews {
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}
- (void)registerCells {
    [self.collectionView registerClass:[JHChatMediaCell class] forCellWithReuseIdentifier:@"JHChatMediaCell"];
}

#pragma mark - Collectionview
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.mediaList.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHChatMediaModel *model = self.mediaList[indexPath.item];
    JHChatMediaCell *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHChatMediaCell" forIndexPath:indexPath];
    [item configWithModel:model];
    return item;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(60, 90);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    CGFloat space = floor((ScreenW - 20 * 2 - 60 * 4) / 4);
    return  space;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20.f;
}

#pragma mark - LAZY
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = HEXCOLOR(0xf8f8f8);
        _collectionView.showsVerticalScrollIndicator = false;
        _collectionView.scrollEnabled = false;
    }
    return _collectionView;
}
- (RACSubject<JHChatMediaModel *> *)selectedSubject {
    if (!_selectedSubject) {
        _selectedSubject = [RACSubject subject];
    }
    return _selectedSubject;
}
@end
