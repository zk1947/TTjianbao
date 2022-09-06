//
//  NTESPresentShopView.m
//  TTjianbao
//
//  Created by chris on 16/3/29.
//  Copyright © 2016年 Netease. All rights reserved.
//

#import "NTESPresentShopView.h"
#import "UIView+NTES.h"
#import "NTESPresentShopCell.h"
#import "NTESPresent.h"
#import "NTESLiveManager.h"

@interface NTESPresentShopFlowLayout : UICollectionViewFlowLayout

@end

@protocol NTESPresentShopBarDelegate <NSObject>

- (void)didSelectPresent:(NTESPresent *)present;

- (void)didPressSendPresent;

@end

@interface NTESPresentShopBar : UIView<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;

@property (nonatomic,strong) UIButton *sendButton;

@property (nonatomic,weak) id<NTESPresentShopBarDelegate> delegate;

@end

@interface NTESPresentShopView()<NTESPresentShopBarDelegate>

@property (nonatomic,strong) NTESPresentShopBar *bar;

@property (nonatomic,strong) NTESPresent *present;

@end

@implementation NTESPresentShopView

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

- (void)didSelectPresent:(NTESPresent *)present
{
    self.present = present;
}

- (void)didPressSendPresent
{
    if ([self.delegate respondsToSelector:@selector(didSelectPresent:)]) {
        [self.delegate didSelectPresent:self.present];
    }
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


- (NTESPresentShopBar *)bar
{
    if (!_bar) {
        CGFloat height = self.width * 0.25;
        _bar = [[NTESPresentShopBar alloc] initWithFrame:CGRectMake(0, 0, self.width, height + 40)];
        _bar.delegate = self;
    }
    return _bar;
}

@end




@implementation NTESPresentShopBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = HEXCOLORA(0x0, .7f);
        [self addSubview:self.collectionView];
        [self addSubview:self.sendButton];
    }
    return self;
}

- (void)onSend:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(didPressSendPresent)]) {
        [self.delegate didPressSendPresent];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NTESPresentShopCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    NTESPresent *present = [NTESLiveManager sharedInstance].presents[@(indexPath.row).stringValue];
    [cell refreshPresent:present];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *separator = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Separator" forIndexPath:indexPath];
    separator.backgroundColor = HEXCOLORA(0xffffff, 0.3);
    return separator;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NTESPresent *present = [NTESLiveManager sharedInstance].presents[@(indexPath.row).stringValue];
    if ([self.delegate respondsToSelector:@selector(didSelectPresent:)]) {
        [self.delegate didSelectPresent:present];
    }
}

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[NTESPresentShopFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0.0f;
        CGFloat itemWidth = self.width * 0.25;
        layout.itemSize = CGSizeMake(itemWidth, itemWidth);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.width, itemWidth) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.dataSource = self;
        _collectionView.delegate   = self;
        [_collectionView registerClass:[NTESPresentShopCell class] forCellWithReuseIdentifier:@"cell"];
        [_collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:@"SeparatorViewKindBottom"
                   withReuseIdentifier:@"Separator"];
        [_collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:@"SeparatorViewKindRight"
                   withReuseIdentifier:@"Separator"];
        
    }
    return _collectionView;
}

- (UIButton *)sendButton
{
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setBackgroundColor:[UIColor whiteColor]];
        [_sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_sendButton setTitle:@"赠送" forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _sendButton.size = CGSizeMake(57.f, 26.f);
        _sendButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        _sendButton.right =  self.width  - 8.f;
        _sendButton.bottom = self.height - 5.f;
        _sendButton.layer.cornerRadius = 4.f;
        [_sendButton addTarget:self action:@selector(onSend:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}


@end


@implementation NTESPresentShopFlowLayout

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
