//
//  JHMallMoreCategoryTitleCell.m
//  TTjianbao
//
//  Created by lihui on 2020/10/23.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMallMoreCategoryTitleCell.h"
#import "TTjianbao.h"
#import "JHMallCateModel.h"
#import "UIButton+JHWebCache.h"
#import "UIButton+ImageTitleSpacing.h"

@interface JHMallMoreCategoryTitleCell ()

@property (nonatomic, strong) UIImageView *bgImageView;
//@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation JHMallMoreCategoryTitleCell

- (void)setCateModel:(JHMallCateModel *)cateModel {
    if (!cateModel) {
        return;
    }
    _cateModel = cateModel;
    
    NSString *imgUrl = cateModel.notSelectedIcon;
    NSString *fontName = kFontNormal;
    UIColor *color = kColor666;
    if (_cateModel.isDefault) {
        imgUrl = cateModel.selectedIcon;
        fontName = kFontMedium;
        color = kColor333;
    }
    
    _bgImageView.hidden = !_cateModel.isDefault;
//    [_iconImageView jhSetImageWithURL:[NSURL URLWithString:imgUrl] placeholder:kDefaultCoverImage];
    _titleLabel.text = [cateModel.name isNotBlank] ? cateModel.name : @"";
    _titleLabel.font = [UIFont fontWithName:fontName size:13.f];
    _titleLabel.textColor = color;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = HEXCOLOR(0xF5F5F5);
        self.contentView.layer.cornerRadius = self.contentView.height/2.f;
        self.contentView.layer.masksToBounds = YES;
//        self.contentView.layer.borderColor = kColorEEE.CGColor;
//        self.contentView.layer.borderWidth = 1.f;
        [self initViews];
    }
    return self;
}

- (void)initViews {
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.backgroundColor = HEXCOLOR(0xfcec9d);
    [self.contentView addSubview:bgView];
    bgView.clipsToBounds = YES;
    _bgImageView = bgView;
    bgView.hidden = YES;
    
//    UIImageView *icon = [[UIImageView alloc] initWithImage:kDefaultCoverImage];
//    icon.contentMode = UIViewContentModeScaleAspectFit;
//    [self.contentView addSubview:icon];
//    icon.clipsToBounds = YES;
//    _iconImageView = icon;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"";
    titleLabel.font = [UIFont fontWithName:kFontNormal size:13.f];
    titleLabel.textColor = kColor666;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    [self.contentView addSubview:titleLabel];
    _titleLabel = titleLabel;
    
    [_bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
//    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView).offset(5);
//        make.bottom.equalTo(self.contentView).offset(-5);
//        make.left.equalTo(self.contentView).offset(10);
//        make.width.mas_equalTo(20);
//    }];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-15);
        make.left.equalTo(self.contentView).offset(15);
    }];
}

@end
