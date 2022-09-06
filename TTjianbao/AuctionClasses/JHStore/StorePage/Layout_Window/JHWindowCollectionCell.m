//
//  JHWindowCollectionCell.m
//  TTjianbao
//
//  Created by lihui on 2020/3/10.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHWindowCollectionCell.h"
#import "CStoreHomeListModel.h"
#import "UIImageView+JHWebImage.h"
#import "JHStoreHomeCardModel.h"

@interface JHWindowCollectionCell()

@property (nonatomic, strong) UILabel *titleLabel;          ///标题
@property (nonatomic, strong) UILabel *descLabel;           ///描述
@property (nonatomic, strong) UIImageView *coverImageView;  ///封面

@end

@implementation JHWindowCollectionCell


+ (CGFloat)cellHeight {
    return 129;
}

- (void)setShowcaseModel:(JHStoreHomeShowcaseModel *)showcaseModel {
    if (!showcaseModel) {
        return;
    }
    _showcaseModel = showcaseModel;
    _titleLabel.text = _showcaseModel.name;
    _descLabel.text = _showcaseModel.desc;
    [_coverImageView jhSetImageWithURL:[NSURL URLWithString:_showcaseModel.bg_img] placeholder:[UIImage imageNamed:@""]];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = HEXCOLOR(0xffffff);
        self.clipsToBounds = YES;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = @"--";
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:16];
        _titleLabel.textColor = HEXCOLOR(0x333333);
        [self.contentView addSubview:_titleLabel];
    }
    
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.text = @"--";
        _descLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _descLabel.textColor = HEXCOLOR(0x666666);
        [self.contentView addSubview:_descLabel];
    }
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.image = [UIImage imageNamed:@""];
        _coverImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_coverImageView];
    }
    
    [self makeLayouts];
}

#pragma mark -
- (void)makeLayouts {
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.contentView).offset(10);
        make.right.equalTo(self.contentView).offset(-10);
    }];
    
    [_descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel);
        make.right.equalTo(self.contentView).offset(-5);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
    }];
    
    [_coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.descLabel.mas_bottom).offset(5);
        make.centerX.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(98, 60));
    }];
}

@end
