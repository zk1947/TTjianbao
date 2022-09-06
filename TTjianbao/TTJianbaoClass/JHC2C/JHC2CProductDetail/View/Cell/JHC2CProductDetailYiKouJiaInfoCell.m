//
//  JHC2CProductDetailYiKouJiaInfoCell.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CProductDetailYiKouJiaInfoCell.h"
#import <YYLabel.h>
#import "JHC2CProoductDetailModel.h"

@interface JHC2CProductDetailYiKouJiaInfoCell()

@property(nonatomic, strong) UIView * backView;


/// ￥符号
@property(nonatomic, strong) UILabel * moneyLbl;

@property(nonatomic, strong) UILabel * countLbl;

@property(nonatomic, strong) YYLabel * postLbl;

@property(nonatomic, strong) UILabel * originPriceLbl;

@end

@implementation JHC2CProductDetailYiKouJiaInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.contentView addSubview:self.backView];
    
    [self.backView addSubview:self.moneyLbl];
    [self.backView addSubview:self.countLbl];
    [self.backView addSubview:self.postLbl];
    [self.backView addSubview:self.originPriceLbl];

}

- (void)layoutItems{
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    [self.moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(30);
        make.left.equalTo(@0).offset(12);
    }];
    [self.countLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(19);
        make.left.equalTo(self.moneyLbl.mas_right).offset(1);
        make.bottom.equalTo(@0);
    }];
    [self.originPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.countLbl).offset(5);
        make.left.equalTo(self.countLbl.mas_right).offset(6);
    }];

    [self.postLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.countLbl).offset(2);;
        make.left.equalTo(self.originPriceLbl.mas_right).offset(10);
    }];
    
}
//鉴定结果类型 0 真 1 仿品 2 存疑 3 现代工艺品 999:异常     100021:鉴定中
- (void)setModel:(JHC2CProoductDetailModel *)model{
    _model = model;
    self.countLbl.text = model.price;
    NSString *postStr = @"包邮";
    if ([model.needFreight isEqualToString:@"1"]) {
        postStr = [NSString stringWithFormat:@"运费%@元", model.freight];
    }
    self.postLbl.text = postStr;
    if (model.originPrice && model.originPrice.integerValue != 0) {
        self.originPriceLbl.text = [NSString stringWithFormat:@"￥%@", model.originPrice];
    }
}

#pragma mark -- <set and get>

- (UIView *)backView{
    if (!_backView) {
        UIView *view = [UIView new];
        view.backgroundColor = UIColor.whiteColor;
        _backView = view;
    }
    return _backView;
}

- (UILabel *)moneyLbl{
    if (!_moneyLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(16);
        label.text = @"￥";
        label.textColor = HEXCOLOR(0xF23730);
        _moneyLbl = label;
    }
    return _moneyLbl;
}

- (UILabel *)countLbl{
    if (!_countLbl) {
        UILabel *label = [UILabel new];
        label.font = [UI getDINBoldFont:30];
        label.text = @"1999";
        label.textColor = HEXCOLOR(0xF23730);
        _countLbl = label;
    }
    return _countLbl;
}

- (YYLabel *)postLbl{
    if (!_postLbl) {
        YYLabel *label = [YYLabel new];
        label.font = JHFont(10);
        label.textContainerInset = UIEdgeInsetsMake(2, 6, 2, 6);
        label.backgroundColor = HEXCOLORA(0xF23730, 0.1);
        label.layer.cornerRadius = 2;
        label.text = @"包邮";
        label.textColor = HEXCOLOR(0xF23730);
        _postLbl = label;
    }
    return _postLbl;

}

- (UILabel *)originPriceLbl{
    if (!_originPriceLbl) {
        UILabel *label = [UILabel new];
        label.font = JHFont(13);
        label.text = @"";
        label.textColor = HEXCOLOR(0x999999);
        _originPriceLbl = label;
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor =  HEXCOLOR(0x999999);
        [label addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(1);
            make.left.right.centerY.equalTo(@0);
        }];
        
    }
    return _originPriceLbl;
}


@end

