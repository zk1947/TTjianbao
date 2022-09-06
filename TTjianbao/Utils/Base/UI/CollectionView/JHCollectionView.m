//
//  JHCollectionView.m
//  TTjianbao
//
//  Created by jesee on 15/6/2020.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCollectionView.h"
#import "JHCollectionItemModel.h"

#define kItemImageSize (CGSizeMake(111, 111))
#define kItemImgTxtSize (CGSizeMake(67, 24))

@interface JHCollectionView () <UICollectionViewDelegate, UICollectionViewDataSource>
{
    CGFloat itemHeight;
    CGFloat itemSpace;
    CGFloat itemLineSpace;
}

@property (nonatomic, assign) JHDetailCollectionCellType cellType;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *detailLayout;
@property (nonatomic, strong) NSMutableArray *dataArray;
@end

@implementation JHCollectionView

- (instancetype)initWithFrame:(CGRect)frame type:(JHDetailCollectionCellType)type
{
    if(self = [super initWithFrame:frame])
    {
        self.cellType = type;
        [self makeLayout];
    }
    return self;
}

- (void)makeLayout
{
    [self addSubview:self.collectionView];
    self.collectionView.collectionViewLayout = self.detailLayout;
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (UICollectionView *)collectionView
{
    if(!_collectionView)
    {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.detailLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = HEXCOLOR(0xFFFFFF);
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        if(self.cellType == JHDetailCollectionCellTypeImageTextScroll ||
           self.cellType == JHDetailCollectionCellTypeImageTextScrollCross)
        {
            _collectionView.scrollEnabled = YES;
        }
        else
        {
            _collectionView.scrollEnabled = NO;
        }
        [self registerCellClass];
    }
    return _collectionView;
}

- (void)registerCellClass
{
    [_collectionView registerClass:[JHCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([JHCollectionCell class])];
    [_collectionView registerClass:[JHCollectionTextUnderImageCell class] forCellWithReuseIdentifier:NSStringFromClass([JHCollectionTextUnderImageCell class])];
    [_collectionView registerClass:[JHCollectionImgTextCell class] forCellWithReuseIdentifier:NSStringFromClass([JHCollectionImgTextCell class])];
    [_collectionView registerClass:[JHCollectionImgTextCellExt class] forCellWithReuseIdentifier:NSStringFromClass([JHCollectionImgTextCellExt class])];
}

- (UICollectionViewFlowLayout *)detailLayout
{
    if(!_detailLayout)
    {
        _detailLayout = [UICollectionViewFlowLayout new];
        _detailLayout.estimatedItemSize = kItemImageSize;
        _detailLayout.minimumLineSpacing = 6.0; //行间距
        _detailLayout.minimumInteritemSpacing = 16.0; //行内item间距
        [self getItemSizeFromLayout];
    }
    return _detailLayout;
}

#pragma mark - methods
- (void)getItemSizeFromLayout
{
    itemHeight = _detailLayout.estimatedItemSize.height;
    itemSpace = _detailLayout.minimumInteritemSpacing;
    itemLineSpace = _detailLayout.minimumLineSpacing;
    if(self.cellType == JHDetailCollectionCellTypeImageTextScroll ||
       self.cellType == JHDetailCollectionCellTypeImageTextScrollCross)
    {
        _detailLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
}

- (void)resetCollection
{
    if(self.cellType == JHDetailCollectionCellTypeImageTextScroll ||
       self.cellType == JHDetailCollectionCellTypeImageTextScrollCross)
    {
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(itemHeight);
        }];
    }
    else
    {
        NSInteger count = self.dataArray.count / kMaxItemCountOfLine + ((self.dataArray.count % kMaxItemCountOfLine) ? 1 : 0);
        [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_offset(count * (itemHeight + itemLineSpace));
        }];
    }
}

- (JHCollectionItemModel*)itemModel:(NSIndexPath *)indexPath
{
    JHCollectionItemModel* item = nil;
    if(indexPath.row < self.dataArray.count)
    {
        item = self.dataArray[indexPath.row];
    }
    return item;
}

- (void)updateCell:(JHCollectionCell*)cell indexPath:(NSIndexPath *)indexPath
{
    [cell drawSubviews];
    JHCollectionItemModel* item = [self itemModel:indexPath];
    if(JHDetailCollectionCellTypeImageTextScrollCross == self.cellType)
    {
        item.style = JHCollectionItemStyleDelete;
    }
    [cell updateCellImage:item.image text:item.title];
}

#pragma mark - delegate
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JHCollectionCell* cell = nil;
    switch (self.cellType)
    {
        case JHDetailCollectionCellTypeOnlyImage:
        default:
        {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHCollectionCell class]) forIndexPath:indexPath];
            [cell drawSubviews];
            [cell updateCellImage:nil];
        }
            break;
            
        case JHDetailCollectionCellTypeTextUnderImage:
        {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHCollectionTextUnderImageCell class]) forIndexPath:indexPath];
            [self updateCell:cell indexPath:indexPath];
        }
            break;
            
        case JHDetailCollectionCellTypeImageText:
        case JHDetailCollectionCellTypeImageTextScroll:
        {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHCollectionImgTextCell class]) forIndexPath:indexPath];
            [self updateCell:cell indexPath:indexPath];
        }
            break;
            
        case JHDetailCollectionCellTypeImageTextScrollCross:
        {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHCollectionImgTextCellExt class]) forIndexPath:indexPath];
            [self updateCell:cell indexPath:indexPath];
        }
            break;
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.delegate respondsToSelector:@selector(clickCollectionItem:)])
    {
        JHCollectionItemModel* item = [self itemModel:indexPath];
        if(item.style == JHCollectionItemStyleDelete)
        {//主动删除一下,避免iOS10出现异常
            [self.dataArray removeObject:item];
            [collectionView deleteItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
        }
        [self.delegate clickCollectionItem:item];
    }
}

#pragma mark - data
- (void)makeLayout:(CGSize)size lineSpace:(CGFloat)lineSpace itemSpace:(CGFloat)itemSpace
{
    self.detailLayout.estimatedItemSize = size;
    self.detailLayout.minimumLineSpacing = lineSpace;
    self.detailLayout.minimumInteritemSpacing = itemSpace;
    self.collectionView.collectionViewLayout = self.detailLayout;
    [self getItemSizeFromLayout];
}

- (void)updateData:(NSArray*)array
{
    self.dataArray = [NSMutableArray arrayWithArray:array];
    [self resetCollection];
    [self.collectionView reloadData]; //解决iOS10刷新无效问题【执行效率考虑:布局无变化时,不刷新】
    [self.collectionView.collectionViewLayout invalidateLayout];
}
//刷新方式mark一下
- (void)reloadMethod
{
    //    [self.collectionView reloadItemsAtIndexPaths:[self.collectionView indexPathsForVisibleItems]];
    //    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
    //    [self.collectionView reloadSections:indexSet];
    //    [self.collectionView reloadData];
    //    NSMutableArray *indexPaths = [NSMutableArray array];
    //    for (int i = 0; i < array.count; i++)
    //    {
    //        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
    //        [indexPaths addObject:indexPath];
    //    }
    //    [self.collectionView performBatchUpdates:^{
    //        [self.collectionView reloadItemsAtIndexPaths:indexPaths];
    //    } completion:^(BOOL finished) {
    //
    //    }];
}

@end
