//
//  JHCustomizeCheckProgramCompletePictsTableViewCell.m
//  TTjianbao
//
//  Created by user on 2020/12/11.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeCheckProgramCompletePictsTableViewCell.h"

#import "UIView+JHGradient.h"
#import "JHBaseListView.h"
#import "JHCustomizeCheckCompleteModel.h"
#import "UIImageView+JHWebImage.h"
#import "TTjianbaoMarcoUI.h"
#import "TTjianbaoUtil.h"

@interface JHCustomizeCheckCompletePicsCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIView      *videoCoverView;
@property (nonatomic,   weak) UIImageView *videoIconImageView;
@property (nonatomic, strong) JHCustomizeCheckCompletePictsModel *model;
- (void)setViewModel:(id)viewModel;
@end

@implementation JHCustomizeCheckCompletePicsCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _iconImageView = [[UIImageView alloc] init];
    [_iconImageView jh_cornerRadius:8.f];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    _videoCoverView = [[UIView alloc] init];
    [_videoCoverView jh_cornerRadius:8.f];
    [self.contentView addSubview:_videoCoverView];
    [_videoCoverView jh_setGradientBackgroundWithColors:@[HEXCOLORA(0x000000,0.f), HEXCOLORA(0x000000,0.4f)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
    _videoCoverView.hidden = YES;
    [_videoCoverView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    _videoIconImageView = [UIImageView jh_imageViewAddToSuperview:self.contentView];
    [_videoIconImageView jh_cornerRadius:8];
    _videoIconImageView.image = JHImageNamed(@"icon_video_play");
    _videoIconImageView.userInteractionEnabled = YES;
    [_videoIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.width.height.mas_equalTo(24.f);
    }];
    _videoIconImageView.hidden = YES;
}

- (void)setViewModel:(id)viewModel {
    JHCustomizeCheckCompletePictsModel *model = [JHCustomizeCheckCompletePictsModel cast:viewModel];
    self.model = model;
    if (model.type == 0) { /// 图片
        self.videoIconImageView.hidden = YES;
        self.videoCoverView.hidden = YES;
        [self.iconImageView jhSetImageWithURL:[NSURL URLWithString:model.url] placeholder:kDefaultCoverImage];
    } else {
        self.videoIconImageView.hidden = NO;
        self.videoCoverView.hidden = NO;
        [self.iconImageView jhSetImageWithURL:[NSURL URLWithString:model.coverUrl] placeholder:kDefaultCoverImage];
    }
}

@end


@interface JHCustomizeCheckProgramCompletePictsTableViewCell ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UILabel          *nameLabel;
@property (nonatomic, strong) NSMutableArray   *dataSourceArray;
@property (nonatomic, strong) UICollectionView *mpCollectionView;
@property (nonatomic, strong) NSMutableArray   *imgDataArray; /// UIImage 数组
@end

@implementation JHCustomizeCheckProgramCompletePictsTableViewCell

- (NSMutableArray *)imgDataArray {
    if (!_imgDataArray) {
        _imgDataArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _imgDataArray;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setupViews];
    }
    return self;
}

- (NSMutableArray *)dataSourceArray {
    if (!_dataSourceArray) {
        _dataSourceArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArray;
}

- (CGFloat)itemWidth {
    return (ScreenW - 10.f*5 - 10.f*2)/4.f;
}

- (void)setupViews {
    self.backgroundColor = HEXCOLOR(0xffffff);
    self.contentView.backgroundColor = HEXCOLOR(0xffffff);
    
    self.contentView.layer.cornerRadius = 8.f;
    self.contentView.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8.f;
    self.layer.masksToBounds = YES;

    _nameLabel               = [[UILabel alloc] init];
    _nameLabel.textColor     = HEXCOLOR(0x333333);
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    _nameLabel.text          = @"设计稿";
    _nameLabel.font          = [UIFont fontWithName:kFontMedium size:15.f];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10.f);
        make.top.equalTo(self.contentView.mas_top).offset(15.f);
        make.width.mas_equalTo(60.f);
        make.height.mas_equalTo(21.f);
    }];
    
    UICollectionViewFlowLayout *layout              = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing                  = 10.f;
    layout.minimumLineSpacing                       = 10.f;
    layout.scrollDirection                          = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *mpCollectionView              = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    mpCollectionView.backgroundColor                = HEXCOLOR(0xffffff);
    mpCollectionView.delegate                       = self;
    mpCollectionView.dataSource                     = self;
    mpCollectionView.showsHorizontalScrollIndicator = NO;
    mpCollectionView.contentInset                   = UIEdgeInsetsMake(0, 0.f, 0.f, 0.f);
    [self.contentView addSubview:mpCollectionView];
    self.mpCollectionView                           = mpCollectionView;
    [mpCollectionView registerClass:[JHCustomizeCheckCompletePicsCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass([JHCustomizeCheckCompletePicsCollectionViewCell class])];
    [mpCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10.f);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(15.f);
        make.height.mas_equalTo(75.f);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-15.f);
    }];
}

#pragma mark - Delegate DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSourceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JHCustomizeCheckCompletePicsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([JHCustomizeCheckCompletePicsCollectionViewCell class]) forIndexPath:indexPath];
    [cell setViewModel:self.dataSourceArray[indexPath.row]];
    return cell;
}

#pragma mark - FlowLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
   return CGSizeMake(75.f, 75.f);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.imgDataArray removeAllObjects];
    for (JHCustomizeCheckCompletePictsModel *model in self.dataSourceArray) {
        [self.imgDataArray addObject:model];
    }
    if (self.pictActionBlock) {
        self.pictActionBlock(indexPath.row, self.imgDataArray);
    }
}

- (void)setViewModel:(id)viewModel {
    NSArray *array = [NSArray cast:viewModel];
    [self.dataSourceArray removeAllObjects];
    [self.imgDataArray removeAllObjects];
    if(array && array.count >0) {
        [self.dataSourceArray addObjectsFromArray:array];
    }
    [self.mpCollectionView reloadData];
}


@end
