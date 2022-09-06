//
//  JHChatGoodsCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/12.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatGoodsCell.h"
@interface JHChatGoodsCell()
/// 商品图
@property (nonatomic, strong) UIImageView *icon;
/// 商品标题
@property (nonatomic, strong) UILabel *titleLabel;
/// 商品金额
@property (nonatomic, strong) UILabel *priceLabel;
/// ¥
@property (nonatomic, strong) UILabel *priceTLabel;

@end

@implementation JHChatGoodsCell

#pragma mark - Life Cycle Functions
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    [self layoutViews];
}
- (void)dealloc {
    NSLog(@"IM释放-%@ 释放", [self class]);
}

- (void)setupGoodsInfo {
    self.messageContent.backgroundColor = HEXCOLOR(0xffffff);
    JHChatGoodsInfoModel *model = self.message.goodsInfo;
    self.priceLabel.text = model.price;
    self.titleLabel.text = model.title;
    [self.icon jh_setImageWithUrl:model.iconUrl placeHolder:@""];
    [self.messageContent mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(contentMaxWidth);
    }];
}
- (void)setupData {
    @weakify(self)
    [[RACObserve(self.message, goodsInfo)
      takeUntil:self.rac_prepareForReuseSignal]
     subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x == nil) return;
        [self setupGoodsInfo];
    }];
}
#pragma mark - UI
- (void)setupUI {
    [self.messageContent addSubview:self.icon];
    [self.messageContent addSubview:self.titleLabel];
    [self.messageContent addSubview:self.priceLabel];
    [self.messageContent addSubview:self.priceTLabel];
}
- (void)layoutViews {
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(8);
        make.left.mas_equalTo(8);
        make.bottom.mas_equalTo(-8);
        make.width.mas_equalTo(self.icon.mas_height);
    }];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(self.icon.mas_right).offset(8);
        make.right.mas_equalTo(-8);
    }];
    [self.priceTLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel);
        make.bottom.mas_equalTo(-8);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.priceTLabel.mas_right).offset(1);
        make.bottom.mas_equalTo(-8);
    }];
}
#pragma mark - LAZY
- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _icon.image = [UIImage imageNamed:@"jh_newStore_type_defaulticon"];
        _icon.contentMode = UIViewContentModeScaleAspectFill;
        [_icon jh_cornerRadius:5];
    }
    return _icon;
}
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.numberOfLines = 2;
        _titleLabel.textColor = HEXCOLOR(0x333333);
        _titleLabel.font = [UIFont fontWithName:kFontMedium size:15];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _titleLabel;
}
- (UILabel *)priceTLabel {
    if (!_priceTLabel) {
        _priceTLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceTLabel.text = @"¥";
        _priceTLabel.textColor = HEXCOLOR(0xf23730);
        _priceTLabel.font = [UIFont fontWithName:kFontNormal size:9];
        _priceTLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _priceTLabel;
}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.textColor = HEXCOLOR(0xf23730);
        _priceLabel.font = [UIFont fontWithName:kFontMedium size:15];
        _priceLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _priceLabel;
}

@end
