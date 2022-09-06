//
//  JHLivingCustomOrderCell.m
//  TTjianbao
//
//  Created by 王记伟 on 2020/11/25.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLivingCustomOrderCell.h"
#import "TTjianbao.h"
#import "UIImageView+WebCache.h"
#import "JHCustomizeOrderModel.h"
@interface JHLivingCustomOrderCell()
/** 图片*/
@property (nonatomic, strong) UIImageView *productImageView;
/** */
@property (nonatomic, strong) UIView *rightView;
/** 标题*/
@property (nonatomic, strong) UILabel *titleLabel;
/** 定制类别*/
//@property (nonatomic, strong) UILabel *typeLabel;
/** 状态*/
@property (nonatomic, strong) UILabel *statusLabel;
/** 分割线*/
@property (nonatomic, strong) UIView *lineView;
@end
@implementation JHLivingCustomOrderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configUI];
    }
    return self;
}

- (void)setModel:(JHCustomizeOrderModel *)model{
    _model = model;
    [self.productImageView sd_setImageWithURL:[NSURL URLWithString:model.goodsUrl] placeholderImage:kDefaultCoverImage];
    self.titleLabel.text = model.goodsTitle;
//    self.typeLabel.text = [NSString stringWithFormat:@"定制类别: %@", model.customizedFeeName];
    self.statusLabel.text = [NSString stringWithFormat:@"状态: %@", model.statusName];
}

- (void)configUI{
    [self.contentView addSubview:self.productImageView];
    [self.contentView addSubview:self.rightView];
    [self.rightView addSubview:self.titleLabel];
//    [self.contentView addSubview:self.typeLabel];
    [self.rightView addSubview:self.statusLabel];
    [self.contentView addSubview:self.lineView];
    
    [self.productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView.mas_top).offset(15);
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.width.height.mas_equalTo(65);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_left).offset(10);
        make.right.mas_equalTo(self.contentView.mas_right).offset(-10);
        make.top.mas_equalTo(self.productImageView.mas_bottom).offset(15);
        make.bottom.mas_equalTo(self.contentView.mas_bottom);
        make.height.mas_equalTo(1);
    }];
    
    [self.rightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.productImageView.mas_right).offset(10);
        make.centerY.mas_equalTo(self.productImageView.mas_centerY);
        make.right.mas_equalTo(self.mas_right).offset(-10);
    }];

    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rightView.mas_left);
        make.right.mas_equalTo(self.rightView.mas_right);
        make.top.mas_equalTo(self.rightView.mas_top);
    }];
////
//    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.productImageView.mas_right).offset(10);
//        make.right.mas_equalTo(self.mas_right).offset(-10);
//        make.centerY.mas_equalTo(self.productImageView.mas_centerY);
//    }];
//
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_left);
        make.right.mas_equalTo(self.titleLabel.mas_right);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(5);
        make.bottom.mas_equalTo(self.rightView.mas_bottom);
    }];
}

- (UIImageView *)productImageView{
    if (_productImageView == nil) {
        _productImageView = [[UIImageView alloc] init];
        _productImageView.image = kDefaultCoverImage;
        _productImageView.contentMode = UIViewContentModeScaleAspectFill;
        _productImageView.clipsToBounds = YES;
        _productImageView.layer.cornerRadius = 8;
    }
    return _productImageView;
}

- (UIView *)rightView{
    if (_rightView == nil) {
        _rightView = [[UIView alloc] init];
        _rightView.backgroundColor = [UIColor clearColor];
    }
    return _rightView;
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.font = [UIFont fontWithName:kFontNormal size:15];
        _titleLabel.text = @"";
        _titleLabel.numberOfLines = 2;
    }
    return _titleLabel;
}
//
//- (UILabel *)typeLabel{
//    if (_typeLabel == nil) {
//        _typeLabel = [[UILabel alloc] init];
//        _typeLabel.textColor = HEXCOLOR(0x999999);
//        _typeLabel.font = [UIFont fontWithName:kFontNormal size:12];
//        _typeLabel.text = @"定制类别:";
//    }
//    return _typeLabel;
//}

- (UILabel *)statusLabel{
    if (_statusLabel == nil) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor = HEXCOLOR(0x999999);
        _statusLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _statusLabel.text = @"状态:";
    }
    return _statusLabel;
}

- (UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = HEXCOLOR(0xf5f6fa);
    }
    return _lineView;
}


@end
