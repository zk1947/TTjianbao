//
//  JHIdentyPhotoInfoCollectionViewCell.m
//  TTjianbao
//
//  Created by lihui on 2020/4/20.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHIdentyPhotoInfoCollectionViewCell.h"
#import "JHUnionPayModel.h"
#import "UIImageView+JHWebImage.h"

@interface JHIdentyPhotoInfoCollectionViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *selectImageView;

@end

@implementation JHIdentyPhotoInfoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = HEXCOLOR(0xF6F6F6);
        self.layer.cornerRadius = 4.f;
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        [self initViews];
    }
    return self;
}

- (void)setPhotoModel:(JHUnionPayUserPhotoModel *)photoModel {
    if (!photoModel) {
        return;
    }
    _photoModel = photoModel;
    
    if (_photoModel.selectPhoto == nil) {
        _iconImageView.hidden = NO;
        _titleLabel.hidden = NO;
        _iconImageView.image = [UIImage imageNamed:_photoModel.iconName];
        _titleLabel.text = _photoModel.title;
    }
    else {
        _titleLabel.hidden = YES;
        _iconImageView.hidden = YES;
        id imgSource = _photoModel.selectPhoto;
        if ([imgSource isKindOfClass:[NSString class]]) {
            [_selectImageView jhSetImageWithURL:[NSURL URLWithString:ALIYUNCS_FILE_BASE_STRING(imgSource)]];
        }else if ([imgSource isKindOfClass:[UIImage class]]) {
            _selectImageView.image = (UIImage *)imgSource;
        }
        _selectImageView.hidden = NO;
    }
}

- (void)initViews {
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _iconImageView.image = [UIImage imageNamed:@""];
    _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    _iconImageView.userInteractionEnabled = NO;
    [self.contentView addSubview:_iconImageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.text = @"";
    _titleLabel.font = [UIFont fontWithName:kFontNormal size:10];
    _titleLabel.textColor = HEXCOLOR(0x999999);
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLabel];
    
    _selectImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    _selectImageView.image = [UIImage imageNamed:@""];
    _selectImageView.contentMode = UIViewContentModeScaleAspectFit;
    _selectImageView.hidden = YES;
    _selectImageView.userInteractionEnabled = NO;
    [self.contentView addSubview:_selectImageView];
    
    [_selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(6);
    }];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(16);
        make.leading.trailing.equalTo(self.contentView);
        make.bottom.equalTo(self.titleLabel.mas_top).offset(8);
    }];
}

@end
