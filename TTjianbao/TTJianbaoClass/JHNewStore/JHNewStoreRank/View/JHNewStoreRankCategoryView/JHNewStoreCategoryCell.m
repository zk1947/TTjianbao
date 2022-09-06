//
//  JHNewStoreCategoryCell.m
//  TTjianbao
//
//  Created by lihui on 2021/2/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHNewStoreCategoryCell.h"
#import "YYAnimatedImageView.h"
#import "JHNewStoreCategoryCellModel.h"
#import <UIImageView+WebCache.h>

@interface JHNewStoreCategoryCell ()

@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UILabel *categoryTitleLabel;

@end

@implementation JHNewStoreCategoryCell

+ (CGSize)cellSize {
    return CGSizeMake(126, 60);
}

- (void)reloadData:(JXCategoryBaseCellModel *)cellModel {
    [super reloadData:cellModel];

    JHNewStoreCategoryCellModel *model = (JHNewStoreCategoryCellModel *)cellModel;
    self.categoryTitleLabel.text = [model.titleString isNotBlank] ? model.titleString : @"";

    if (model.isSelected) {
        ///选中状态
        self.categoryTitleLabel.font = [UIFont fontWithName:kFontBoldPingFang size:14.];
        self.categoryTitleLabel.textColor = model.selectTitleColor;
        if ([model.leftIndicatorImage isNotBlank]) {
            if ([model.leftIndicatorImage hasPrefix:@"http"]) {
                [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:model.leftIndicatorImage]];
            }
            else {
                self.leftImageView.image = [UIImage imageNamed:model.leftIndicatorImage];
            }
        }
        if ([model.rightIndicatorImage isNotBlank]) {
            if ([model.rightIndicatorImage hasPrefix:@"http"]) {
                [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:model.leftIndicatorImage]];
            }
            else {
                self.rightImageView.image = [UIImage imageNamed:model.rightIndicatorImage];
            }
        }
    } else {
        ///非选中状态
        self.categoryTitleLabel.font = [UIFont fontWithName:kFontNormal size:14.];
        self.categoryTitleLabel.textColor = model.normalTitleColor;
    }
    
    self.leftImageView.hidden = !model.isSelected;
    self.rightImageView.hidden = self.leftImageView.hidden;
}

- (void)initializeViews {
    [super initializeViews];
    [self initViews];
}

- (void)initViews {
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
//    self.backgroundColor = [UIColor yellowColor];
    [self.contentView addSubview:self.leftImageView];
    [self.contentView addSubview:self.categoryTitleLabel];
    [self.contentView addSubview:self.rightImageView];
    
    [self.leftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.contentView);
        make.width.equalTo(@10);
    }];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.top.bottom.equalTo(self.contentView);
        make.width.equalTo(@10);
    }];
    
    [self.categoryTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(self.contentView);
        make.left.equalTo(self.leftImageView.mas_right).offset(2);
        make.right.equalTo(self.rightImageView.mas_left).offset(-2);
    }];
}

- (UILabel *)categoryTitleLabel {
    
    if (!_categoryTitleLabel) {
        _categoryTitleLabel = [[UILabel alloc] init];
        _categoryTitleLabel.font = [UIFont fontWithName:kFontNormal size:14.];
        _categoryTitleLabel.textAlignment = NSTextAlignmentCenter;
        _categoryTitleLabel.textColor = HEXCOLOR(0xffffff);
    }
    return _categoryTitleLabel;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] init];
        _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _leftImageView;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _rightImageView;
}

@end
