//
//  NTESPresentBoxView.m
//  TTjianbao
//
//  Created by chris on 16/3/30.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESPresentBoxView.h"
#import "UIView+NTES.h"
#import "NTESPresentBoxCell.h"
#import "NTESPresent.h"
#import "NTESLiveManager.h"
#import "NTESPresentItem.h"

@interface NTESPresentBoxFlowLayout : UICollectionViewFlowLayout

@end


@interface NTESPresentBoxBar : UIView<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UIView *emptyTip;

@property (nonatomic,copy)   NSArray<NTESPresentItem *> *data;

@end

@interface NTESPresentBoxView()

@property (nonatomic,strong) NTESPresentBoxBar *bar;

@end

@implementation NTESPresentBoxView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(onTapBackground:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.bar];
        
    }
    return self;
}

- (void)onTapBackground:(id)sender
{
    [self dismiss];
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    self.bar.top = self.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.bar.bottom = self.height;
    }];
}

- (void)dismiss
{
    [UIView animateWithDuration:0.25 animations:^{
        self.bar.top = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (NTESPresentBoxBar *)bar
{
    if (!_bar) {
        _bar = [[NTESPresentBoxBar alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
    }
    return _bar;
}

@end



@implementation NTESPresentBoxBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXCOLORA(0x0, .7f);
        self.data = [NTESLiveManager sharedInstance].myPresentBox;
        if (self.data.count)
        {
            CGFloat height = self.width * 0.25;
            self.height = height;
            [self addSubview:self.collectionView];
        }
        else
        {
            self.height = 175.f;
            [self addSubview:self.emptyTip];
        }
        
    }
    return self;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.data.count > indexPath.row) {
        NTESPresentBoxCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"present" forIndexPath:indexPath];
        NTESPresentItem *item = self.data[indexPath.row];
        NSInteger type  = item.type;
        NSInteger count = item.count;
        NTESPresent *present = [NTESLiveManager sharedInstance].presents[@(type).stringValue];
        [cell refreshPresent:present count:count];
        return cell;
    }else{
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"common" forIndexPath:indexPath];
        return cell;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *separator = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Separator" forIndexPath:indexPath];
    separator.backgroundColor = HEXCOLORA(0xffffff, 0.3);
    return separator;
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[NTESPresentBoxFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0.0f;
        CGFloat itemWidth = self.width * 0.25;
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, itemWidth) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate   = self;
        [_collectionView registerClass:[NTESPresentBoxCell class]   forCellWithReuseIdentifier:@"present"];
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"common"];
        [_collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:@"SeparatorViewKindBottom"
                   withReuseIdentifier:@"Separator"];
        [_collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:@"SeparatorViewKindRight"
                   withReuseIdentifier:@"Separator"];
        
    }
    return _collectionView;
}

- (UIView *)emptyTip
{
    if (!_emptyTip) {
        _emptyTip = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 96, 74)];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_empty_box"]];
        imageView.centerX = _emptyTip.width * .5f;
        [_emptyTip addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont systemFontOfSize:13.f];
        label.textColor = HEXCOLOR(0xffffff);
        label.text = @"当前还没收到礼物";
        [label sizeToFit];
        label.centerX = _emptyTip.width * .5f;
        label.bottom = _emptyTip.height;
        [_emptyTip addSubview:label];
    }
    return _emptyTip;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _emptyTip.centerX = self.width  * .5f;
    _emptyTip.centerY = self.height * .5f;
}

@end


@implementation NTESPresentBoxFlowLayout

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *attributes = [NSMutableArray arrayWithArray:[super layoutAttributesForElementsInRect:rect]];
    [attributes addObjectsFromArray:[self bottomSepAttrInRect:rect]];
    [attributes addObjectsFromArray:[self rightSepAttrInRect:rect]];
    return attributes;
}

- (NSArray *)bottomSepAttrInRect:(CGRect)rect
{
    NSMutableArray *attributes = [NSMutableArray arrayWithArray:[super layoutAttributesForElementsInRect:rect]];
    NSMutableArray *attrs = [[NSMutableArray alloc] init];
    for (UICollectionViewLayoutAttributes *attr in attributes) {
        UICollectionViewLayoutAttributes *separatorAttributesBottom = [self layoutAttributesForSupplementaryViewOfKind:@"SeparatorViewKindBottom" atIndexPath:attr.indexPath];
        CGRect separatorFrame = attr.frame;
        separatorFrame.origin.y    = separatorFrame.size.height - 0.5;
        separatorFrame.size.height = 0.5;
        separatorAttributesBottom.frame = separatorFrame;
        [attrs addObject:separatorAttributesBottom];
    }
    return attrs;
}

- (NSArray *)rightSepAttrInRect:(CGRect)rect
{
    NSMutableArray *attributes = [NSMutableArray arrayWithArray:[super layoutAttributesForElementsInRect:rect]];
    NSMutableArray *attrs = [[NSMutableArray alloc] init];
    for (UICollectionViewLayoutAttributes *attr in attributes) {
        UICollectionViewLayoutAttributes *separatorAttributesRight = [self layoutAttributesForSupplementaryViewOfKind:@"SeparatorViewKindRight" atIndexPath:attr.indexPath];
        CGRect separatorFrame = attr.frame;
        separatorFrame.origin.x    = separatorFrame.origin.x + separatorFrame.size.width;
        separatorFrame.size.width  = 0.5;
        separatorAttributesRight.frame = separatorFrame;
        [attrs addObject:separatorAttributesRight];
    }
    return attrs;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    return attr;
}

@end
