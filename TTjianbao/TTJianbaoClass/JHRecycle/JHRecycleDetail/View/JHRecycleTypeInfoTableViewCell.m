//
//  JHRecycleTypeInfoTableViewCell.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/3/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecycleTypeInfoTableViewCell.h"
#import "JHRecycleDetailModel.h"

@interface JHRecycleTypeInfoTableViewCell ()
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *typeLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation JHRecycleTypeInfoTableViewCell

- (void)setupViews{
    /// 价格
    [self.backView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(15);
        make.left.equalTo(self.backView).offset(12);
        make.right.equalTo(self.backView).offset(-12);
    }];
    /// 分类
    [self.backView addSubview:self.typeLabel];
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLabel.mas_bottom).offset(6.f);
        make.left.equalTo(self.backView).offset(12);
        make.right.equalTo(self.backView).offset(-12);
    }];
    /// 时间
    [self.backView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeLabel.mas_bottom).offset(6);
        make.left.equalTo(self.backView).offset(12);
        make.right.equalTo(self.backView).offset(-12);
        make.bottom.equalTo(self.backView).offset(-15);
    }];
    
}

- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = HEXCOLOR(0x666666);
        _priceLabel.font = [UIFont fontWithName:kFontNormal size:12];
    }
    return _priceLabel;
}

- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor = HEXCOLOR(0x666666);
        _typeLabel.font = [UIFont fontWithName:kFontNormal size:12];
    }
    return _typeLabel;
}

- (UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = HEXCOLOR(0x666666);
        _timeLabel.font = [UIFont fontWithName:kFontNormal size:12];
    }
    return _timeLabel;
}

- (void)bindViewModel:(id)dataModel{
    JHRecycleDetailModel *detailModel = dataModel;
    if (!isEmpty(detailModel.expectPrice)) {
        NSString *priceStr = [NSString stringWithFormat:@"￥%@",detailModel.expectPrice];
        NSString *str = [NSString stringWithFormat:@"期望价格：%@",priceStr];
        NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:str];
        [attr addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0x666666) range:[str rangeOfString:@"期望价格："]];
        [attr addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFontNormal size:12] range:[str rangeOfString:@"期望价格："]];
        [attr addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0xFF4200) range:[str rangeOfString:priceStr]];
        [attr addAttribute:NSFontAttributeName value:[UIFont fontWithName:kFontBoldPingFang size:14] range:[str rangeOfString:priceStr]];
        self.priceLabel.attributedText = attr;
        [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backView).offset(15);
            make.left.equalTo(self.backView).offset(12);
            make.right.equalTo(self.backView).offset(-12);
        }];
        [self.typeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.priceLabel.mas_bottom).offset(6.f);
        }];
    } else {
        self.priceLabel.text = @"";
        [self.priceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backView).offset(15);
            make.left.equalTo(self.backView).offset(12);
            make.right.equalTo(self.backView).offset(-12);
            make.height.mas_equalTo(0.f);
        }];
        [self.typeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.priceLabel.mas_bottom).offset(0.f);
        }];
    }
    
    self.typeLabel.text = [NSString stringWithFormat:@"回收分类：%@",detailModel.categoryName];
    self.timeLabel.text = [NSString stringWithFormat:@"上架时间：%@",detailModel.launchTime];
}


@end
