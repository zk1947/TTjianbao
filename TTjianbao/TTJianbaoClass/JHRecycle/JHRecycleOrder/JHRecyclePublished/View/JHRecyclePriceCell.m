//
//  JHRecyclePriceCell.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/17.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecyclePriceCell.h"
#import "JHRecyclePriceModel.h"
#import "NSString+AttributedString.h"
@interface JHRecyclePriceCell()
/** 名称*/
@property (nonatomic, strong) UILabel *titleLabel;
/** 成交率*/
@property (nonatomic, strong) UILabel *dealLabel;
/** 报价*/
@property (nonatomic, strong) UILabel *priceLabel;
/** 选择框*/
@property (nonatomic, strong) UIImageView *selectImageView;
/** 分割线*/
@property (nonatomic, strong) UIView *lineView;
@end
@implementation JHRecyclePriceCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configUI];
    }
    return self;
}

- (void)setPriceModel:(JHRecyclePriceModel *)priceModel {
    _priceModel = priceModel;
    self.titleLabel.text = priceModel.shopName;

    NSMutableArray *itemsArray1 = [NSMutableArray array];
    itemsArray1[0] = @{@"string":@"成交率: ", @"color":HEXCOLOR(0x666666), @"font":[UIFont fontWithName:kFontNormal size:11]};
    itemsArray1[1] = @{@"string":[NSString stringWithFormat:@"%@%%", priceModel.turnoverRate], @"color":HEXCOLOR(0xff4200), @"font":[UIFont fontWithName:kFontNormal size:11]};
    self.dealLabel.attributedText = [NSString mergeStrings:itemsArray1];

    NSMutableArray *itemsArray2 = [NSMutableArray array];
    itemsArray2[0] = @{@"string":@"报价: ", @"color":HEXCOLOR(0x666666), @"font":[UIFont fontWithName:kFontNormal size:11]};
    itemsArray2[1] = @{@"string":[NSString stringWithFormat:@"¥%@", priceModel.bidPriceYuan], @"color":HEXCOLOR(0xff4200), @"font":[UIFont fontWithName:kFontBoldDIN size:16]};
    self.priceLabel.attributedText = [NSString mergeStrings:itemsArray2];
    
    self.selectImageView.image = priceModel.isSelect ? [UIImage imageNamed:@"recycle_piublish_price_selected"] : [UIImage imageNamed:@"recycle_piublish_price_normal"];
}

- (void)configUI {
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.dealLabel];
    [self.contentView addSubview:self.selectImageView];
    [self.contentView addSubview:self.lineView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(8);
        make.left.mas_equalTo(self.contentView).offset(12);
        make.height.mas_equalTo(18);
    }];
    
    [self.dealLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(4);
        make.left.mas_equalTo(self.contentView).offset(12);
        make.height.mas_equalTo(16);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dealLabel.mas_bottom).offset(8);
        make.left.mas_equalTo(self.contentView).offset(12);
        make.right.mas_equalTo(self.contentView).offset(-12);
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self.contentView);
    }];
    
    [self.selectImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.right.mas_equalTo(self.contentView).offset(-12);
        make.width.height.mas_equalTo(18);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.selectImageView.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.contentView);
    }];
}

- (UILabel *)titleLabel {
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:13];
        _titleLabel.text = @"";
    }
    return _titleLabel;
}

- (UILabel *)priceLabel {
    if (_priceLabel == nil) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = HEXCOLOR(0x666666);
        _priceLabel.font = [UIFont fontWithName:kFontNormal size:11];
        _priceLabel.text = @"报价:";
    }
    return _priceLabel;
}

- (UILabel *)dealLabel {
    if (_dealLabel == nil) {
        _dealLabel = [[UILabel alloc] init];
        _dealLabel.textColor = HEXCOLOR(0x666666);
        _dealLabel.font = [UIFont fontWithName:kFontNormal size:11];
        _dealLabel.text = @"成交率:";
    }
    return _dealLabel;
}

- (UIImageView *)selectImageView {
    if (_selectImageView == nil) {
        _selectImageView = [[UIImageView alloc] init];
        _selectImageView.image = [UIImage imageNamed:@"recycle_piublish_price_normal"];
    }
    return _selectImageView;
}

- (UIView *)lineView {
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HEXCOLOR(0xe6e6e6);
    }
    return _lineView;
}

@end
