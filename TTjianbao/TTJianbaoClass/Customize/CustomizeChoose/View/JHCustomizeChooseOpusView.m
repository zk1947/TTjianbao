//
//  JHCustomizeChooseOpusView.m
//  TTjianbao
//
//  Created by user on 2020/11/21.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeChooseOpusView.h"
#import "JHCustomizeChooseModel.h"
#import "UIImageView+JHWebImage.h"
#import "TTjianbaoMarcoUI.h"
#import "TTjianbaoUtil.h"

@interface JHCustomizeChooseOpusCollectionCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel     *nameLabel;
@property (nonatomic, strong) UIImageView *scoreBackView;

- (void)setViewModel:(id)viewModel;
@end

@implementation JHCustomizeChooseOpusCollectionCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    self.contentView.layer.cornerRadius  = 8.f;
    self.contentView.layer.masksToBounds = YES;
    self.layer.cornerRadius              = 8.f;
    self.layer.masksToBounds             = YES;
    
    _imageView = [[UIImageView alloc] init];
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
//    UIView *backView = [[UIView alloc] init];
//    backView.backgroundColor = HEXCOLORA(0x000000, 0.4f);
//    [self.contentView addSubview:backView];
//    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.contentView.mas_bottom);
//        make.height.mas_equalTo(24.f);
//        make.left.equalTo(self.contentView.mas_left);
//        make.right.equalTo(self.contentView.mas_right);
//    }];
    _scoreBackView = [[UIImageView alloc] init];
    [self.contentView addSubview:_scoreBackView];
    [_scoreBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(24.f);
    }];
    
    _nameLabel               = [[UILabel alloc] init];
    _nameLabel.textColor     = HEXCOLOR(0xFFFFFF);
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.font          = [UIFont fontWithName:kFontNormal size:12.f];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-4.f);
        make.height.mas_equalTo(17.f);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
    }];
}

- (void)setViewModel:(id)viewModel {
    JHCustomizeChooseOpusListModel *model = [JHCustomizeChooseOpusListModel cast:viewModel];
    if (!model) {
        self.scoreBackView.image = nil;
    } else {
        self.scoreBackView.image = [UIImage imageNamed:@"customize_choose_back"];
    }
    [self.imageView jhSetImageWithURL:[NSURL URLWithString:model.coverUrl] placeholder:kDefaultCoverImage completed:^(UIImage * _Nullable image, NSError * _Nullable error) {
        if (image) {
            self.scoreBackView.image = [UIImage imageNamed:@"customize_choose_back"];
        } else {
            self.scoreBackView.image = nil;
        }
    }];
    self.nameLabel.text = NONNULL_STR(model.title);
}

@end


@interface JHCustomizeChooseOpusView () <
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *mpCollectionView;
@property (nonatomic, strong) NSMutableArray   *dataSourceArray;
@end

@implementation JHCustomizeChooseOpusView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    [self addSubview:self.mpCollectionView];
    [self.mpCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (UICollectionView *)mpCollectionView {
    if (!_mpCollectionView) {
        UICollectionViewFlowLayout *layout               = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing                   = 10.f;
        layout.minimumLineSpacing                        = 10.f;
        layout.scrollDirection                           = UICollectionViewScrollDirectionHorizontal;
        _mpCollectionView                                = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _mpCollectionView.backgroundColor                = HEXCOLOR(0xffffff);
        _mpCollectionView.delegate                       = self;
        _mpCollectionView.dataSource                     = self;
        _mpCollectionView.showsHorizontalScrollIndicator = NO;
        _mpCollectionView.contentInset                   = UIEdgeInsetsMake(0, 10.f, 0.f, 0.f);
        [_mpCollectionView registerClass:[JHCustomizeChooseOpusCollectionCell class] forCellWithReuseIdentifier:NSStringFromClass([JHCustomizeChooseOpusCollectionCell class])];
    }
    return _mpCollectionView;
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

#pragma mark - Delegate DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHCustomizeChooseOpusCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHCustomizeChooseOpusCollectionCell class]) forIndexPath:indexPath];
    [cell setViewModel:self.dataSourceArray[indexPath.row]];
    return cell;
}

#pragma mark - FlowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80.f, 80.f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5.f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.opusClickAcion) {
        self.opusClickAcion();
    }
}

- (void)setViewModel:(id)viewModel {
    NSArray *arr = [NSArray cast:viewModel];
    [self.dataSourceArray removeAllObjects];
    if (arr && arr.count >0) {
        [self.dataSourceArray addObjectsFromArray:arr];
    }
    [self.mpCollectionView reloadData];
}


@end
