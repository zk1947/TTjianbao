//
//  JHNewStoreHomeCategoryMallCollectionViewCell.m
//  TTjianbao
//
//  Created by user on 2021/3/30.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreHomeCategoryMallCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "JHMallModel.h"
#import "JHAnimatedImageView.h"

@interface JHNewStoreHomeCategoryMallCollectionViewCell ()
/** 角标图片*/
@property (nonatomic, strong) JHAnimatedImageView *badgeImageView;
@property (nonatomic, strong) JHAnimatedImageView *cateImageView;
@property (nonatomic, strong) UILabel             *cateTitleLabel;

@end

@implementation JHNewStoreHomeCategoryMallCollectionViewCell

+ (CGSize)viewSize {
    CGFloat w = (ScreenW - 10.f) / 5;
    return CGSizeMake(w, 76.5f);
}

- (void)setCateModel:(JHMallCategoryModel *)cateModel {
    if (!cateModel) {
        return;
    }
    _cateModel = cateModel;
    [_cateImageView jh_setImageWithUrl:_cateModel.icon];
    [_badgeImageView jh_setImageWithUrl:_cateModel.corner placeholder:nil];
    _cateTitleLabel.text = [_cateModel.name isNotBlank] ? _cateModel.name : @"--";
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initViews];
    }
    return self;
}

- (void)initViews {
    JHAnimatedImageView *imgView = [[JHAnimatedImageView alloc] initWithImage:kDefaultCoverImage];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    //imgView.layer.cornerRadius = 22.f;
    imgView.layer.masksToBounds = YES;
    [self.contentView addSubview:imgView];
    _cateImageView = imgView;
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"和田玉";
    label.font = [UIFont fontWithName:kFontNormal size:12.f];
    label.textColor = kColor222;
    label.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:label];
    _cateTitleLabel = label;
    
    JHAnimatedImageView *badgeImageView = [[JHAnimatedImageView alloc] init];
    badgeImageView.backgroundColor = UIColor.clearColor;
    badgeImageView.contentMode = UIViewContentModeScaleAspectFit;
    badgeImageView.clipsToBounds = YES;
    badgeImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:badgeImageView];
    _badgeImageView = badgeImageView;
    
    [_cateTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-1);
    }];

    [_cateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.cateTitleLabel.mas_top).offset(-4);
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(44.f, 44.f));
    }];
    
    [_badgeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.cateImageView.mas_right).offset(16);
        make.top.mas_equalTo(self.cateImageView.mas_top).offset(-10);
        make.width.mas_equalTo(32);
        make.height.mas_equalTo(20);
    }];
}

@end
