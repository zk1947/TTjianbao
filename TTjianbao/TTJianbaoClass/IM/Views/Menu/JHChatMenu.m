//
//  JHChatMenu.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatMenu.h"
#import "JHChatMenuItem.h"

@interface JHChatMenu()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIImageView *triangleView;
@property (nonatomic, strong) NSArray<JHChatMenuItemModel *> *dataSource;
@end

@implementation JHChatMenu
+ (instancetype)shared {
    static JHChatMenu *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JHChatMenu alloc] initWithFrame:CGRectZero];
    });
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self registerCells];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutViews];
}
+ (void)showMenuInView : (UIView *)view items : (NSArray<JHChatMenuItemModel *> *)items handler : (SelectedHandler)handler {
    JHChatMenu *menu = [JHChatMenu shared];
    menu.handler = handler;
    menu.dataSource = items;
    [menu showWithView:view];
}
- (void)reloadData {
    if (self.dataSource == nil) return;
    [self.collectionView reloadData];
}
- (void)showWithView : (UIView *)view {
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    CGFloat width = self.dataSource.count * 40 + 18;
    CGRect rect = [view convertRect:view.bounds toView:self];
    
    if (rect.origin.y < 200 ) {
        [self transformTriangleViewRotation:M_PI];
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(view.mas_bottom).offset(10);
            make.size.mas_equalTo(CGSizeMake(width, 44));
            make.centerX.mas_equalTo(view.mas_centerX);
        }];
        [self.triangleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.contentView.mas_top).offset(0);
            make.size.mas_equalTo(CGSizeMake(11, 5.7));
            make.centerX.mas_equalTo(view.mas_centerX);
        }];
        
    }else {
        [self transformTriangleViewRotation:0];
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(view.mas_top).offset(-10);
            make.size.mas_equalTo(CGSizeMake(width, 44));
            make.centerX.mas_equalTo(view.mas_centerX);
        }];
        [self.triangleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_bottom).offset(0);
            make.size.mas_equalTo(CGSizeMake(11, 5.7));
            make.centerX.mas_equalTo(view.mas_centerX);
        }];
    }
    
}
- (void)hide {
    [self removeFromSuperview];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self removeFromSuperview];
}
- (void)transformTriangleViewRotation : (CGFloat)rotation {
    CGAffineTransform transform= CGAffineTransformMakeRotation(rotation);
    self.triangleView.transform = transform;
}
#pragma mark -UI
- (void)setupUI {
    self.frame = CGRectMake(0, 0, ScreenW, ScreenH);
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.collectionView];
    [self addSubview:self.triangleView];
}
- (void)layoutViews {
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(8, 8, 8, 8));
    }];
}
- (void)registerCells {
    [self.collectionView registerClass:[JHChatMenuItem class] forCellWithReuseIdentifier:@"JHChatMenuItem"];
}

#pragma mark - Collectionview
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self hide];
    JHChatMenuItemModel *model = self.dataSource[indexPath.item];
    if (self.handler) {
        self.handler(model);
    }
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHChatMenuItemModel *model = self.dataSource[indexPath.item];
    JHChatMenuItem *item = [collectionView dequeueReusableCellWithReuseIdentifier:@"JHChatMenuItem" forIndexPath:indexPath];
    item.model = model;
    return item;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(40, 28);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.f;
}
#pragma mark -Lazy
- (void)setDataSource:(NSArray<JHChatMenuItemModel *> *)dataSource {
    _dataSource = dataSource;
    [self reloadData];
}
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentView.backgroundColor = HEXCOLOR(0x333333);
        [_contentView jh_cornerRadius:8];
    }
    return _contentView;
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = HEXCOLOR(0x333333);
        _collectionView.showsVerticalScrollIndicator = false;
        _collectionView.scrollEnabled = false;
    }
    return _collectionView;
}
- (UIImageView *)triangleView {
    if (!_triangleView) {
        _triangleView = [[UIImageView alloc] initWithFrame: CGRectZero];
        _triangleView.image = [UIImage imageNamed:@"IM_triangle_icon"];
    }
    return _triangleView;
}
@end
