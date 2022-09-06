//
//  JHMarketPriceCell.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketPriceCell.h"
#import "JHMarketOrderModel.h"
@interface JHMarketPriceCell()
/** 背景色视图*/
@property (nonatomic, strong) UIView *backView;
/** 价格view*/
@property (nonatomic, strong) UIView *priceView;
/** 价格tag*/
@property (nonatomic, strong) UILabel *priceTagLabel;
/** 价格Value*/
@property (nonatomic, strong) UILabel *priceValueLabel;
/** 价格分割线*/
@property (nonatomic, strong) UIView *priceLineView;

/** 运费view*/
@property (nonatomic, strong) UIView *freightView;
/** 运费tag*/
@property (nonatomic, strong) UILabel *freightTagLabel;
/** 运费Value*/
@property (nonatomic, strong) UILabel *freightValueLabel;
/** 运费分割线*/
@property (nonatomic, strong) UIView *freightLineView;

/** 津贴view*/
@property (nonatomic, strong) UIView *allowanceView;
/** 津贴tag*/
@property (nonatomic, strong) UILabel *allowanceTagLabel;
/** 津贴Value*/
@property (nonatomic, strong) UILabel *allowanceValueLabel;
/** 津贴分割线*/
@property (nonatomic, strong) UIView *allowanceLineView;

/** 实付款view*/
@property (nonatomic, strong) UIView *realPriceView;
/** 实付款tag*/
@property (nonatomic, strong) UILabel *realPriceTagLabel;
/** 实付款Value*/
@property (nonatomic, strong) UILabel *realPriceValueLabel;

@end

@implementation JHMarketPriceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = HEXCOLOR(0xf5f6fa);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configUI];
    }
    return self;
}

- (void)setModel:(JHMarketOrderModel *)model {
    _model = model;
    if (!model) {
        return;
    }
    //运费高度
    CGFloat freightHeight = model.freight.doubleValue > 0 ? 39 : 0;
    //津贴高度
    CGFloat allowanceHeight = model.bountyAmount.doubleValue > 0 ? 39 : 0;
    [self.freightView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(freightHeight);
    }];
    [self.allowanceView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(allowanceHeight);
    }];
    
    self.priceValueLabel.text = [NSString stringWithFormat:@"+¥%@", model.originOrderPrice];
    self.freightValueLabel.text = [NSString stringWithFormat:@"+¥%@", model.freight];
    self.allowanceValueLabel.text = [NSString stringWithFormat:@"-¥%@", model.bountyAmount];
    self.realPriceValueLabel.text = [NSString stringWithFormat:@"¥%@", model.orderPrice];

}

- (void)configUI {
    [self.contentView addSubview:self.backView];
    
    [self.backView addSubview:self.priceView];
    [self.priceView addSubview:self.priceTagLabel];
    [self.priceView addSubview:self.priceValueLabel];
    [self.priceView addSubview:self.priceLineView];
    
    [self.backView addSubview:self.freightView];
    [self.freightView addSubview:self.freightTagLabel];
    [self.freightView addSubview:self.freightValueLabel];
    [self.freightView addSubview:self.freightLineView];
    
    [self.backView addSubview:self.allowanceView];
    [self.allowanceView addSubview:self.allowanceTagLabel];
    [self.allowanceView addSubview:self.allowanceValueLabel];
    [self.allowanceView addSubview:self.allowanceLineView];
    
    [self.backView addSubview:self.realPriceView];
    [self.realPriceView addSubview:self.realPriceTagLabel];
    [self.realPriceView addSubview:self.realPriceValueLabel];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-10);
    }];
    
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView);
        make.left.mas_equalTo(self.backView);
        make.right.mas_equalTo(self.backView);
        make.height.mas_equalTo(39);
    }];
    
    [self.priceTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.priceView);
        make.left.mas_equalTo(self.priceView).offset(10);
    }];
    
    [self.priceValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.priceView);
        make.right.mas_equalTo(self.priceView).offset(-10);
    }];
    
    [self.priceLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.priceView);
        make.left.mas_equalTo(self.priceView).offset(10);
        make.right.mas_equalTo(self.priceView).offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    [self.freightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.priceView.mas_bottom);
        make.left.mas_equalTo(self.backView);
        make.right.mas_equalTo(self.backView);
        make.height.mas_equalTo(39);
    }];
    
    [self.freightTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.freightView);
        make.left.mas_equalTo(self.freightView).offset(10);
    }];
    
    [self.freightValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.freightView);
        make.right.mas_equalTo(self.freightView).offset(-10);
    }];
    
    [self.freightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.freightView);
        make.left.mas_equalTo(self.freightView).offset(10);
        make.right.mas_equalTo(self.freightView).offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    [self.allowanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.freightView.mas_bottom);
        make.left.mas_equalTo(self.backView);
        make.right.mas_equalTo(self.backView);
        make.height.mas_equalTo(39);
    }];
    
    [self.allowanceTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.allowanceView);
        make.left.mas_equalTo(self.allowanceView).offset(10);
    }];
    
    [self.allowanceValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.allowanceView);
        make.right.mas_equalTo(self.allowanceView).offset(-10);
    }];
    
    [self.allowanceLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.allowanceView);
        make.left.mas_equalTo(self.allowanceView).offset(10);
        make.right.mas_equalTo(self.allowanceView).offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    [self.realPriceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.allowanceLineView.mas_bottom);
        make.left.mas_equalTo(self.backView);
        make.right.mas_equalTo(self.backView);
        make.height.mas_equalTo(39);
        make.bottom.mas_equalTo(self.backView);
    }];
    
    [self.realPriceTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.realPriceView);
        make.right.mas_equalTo(self.realPriceValueLabel.mas_left).offset(-10);
    }];
    
    [self.realPriceValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.realPriceView);
        make.right.mas_equalTo(self.realPriceView).offset(-5);
    }];
    
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = HEXCOLOR(0xffffff);
        _backView.layer.cornerRadius = 5;
        _backView.clipsToBounds = YES;
    }
    return _backView;
}

- (UIView *)priceView {
    if (_priceView == nil) {
        _priceView = [[UIView alloc] init];
    }
    return _priceView;
}

- (UILabel *)priceTagLabel {
    if (_priceTagLabel == nil) {
        _priceTagLabel = [[UILabel alloc] init];
        _priceTagLabel.textColor = HEXCOLOR(0x333333);
        _priceTagLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _priceTagLabel.text = @"宝贝价格";
    }
    return _priceTagLabel;
}

- (UILabel *)priceValueLabel {
    if (_priceValueLabel == nil) {
        _priceValueLabel = [[UILabel alloc] init];
        _priceValueLabel.textColor = HEXCOLOR(0x333333);
        _priceValueLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _priceValueLabel.text = @"";
    }
    return _priceValueLabel;
}

- (UIView *)priceLineView {
    if (_priceLineView == nil) {
        _priceLineView = [[UIView alloc] init];
        _priceLineView.backgroundColor = HEXCOLOR(0xf5f6fa);
    }
    return _priceLineView;
}

- (UIView *)freightView {
    if (_freightView == nil) {
        _freightView = [[UIView alloc] init];
        _freightView.clipsToBounds = YES;
    }
    return _freightView;
}

- (UILabel *)freightTagLabel {
    if (_freightTagLabel == nil) {
        _freightTagLabel = [[UILabel alloc] init];
        _freightTagLabel.textColor = HEXCOLOR(0x333333);
        _freightTagLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _freightTagLabel.text = @"运费";
    }
    return _freightTagLabel;
}

- (UILabel *)freightValueLabel {
    if (_freightValueLabel == nil) {
        _freightValueLabel = [[UILabel alloc] init];
        _freightValueLabel.textColor = HEXCOLOR(0x333333);
        _freightValueLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _freightValueLabel.text = @"";
    }
    return _freightValueLabel;
}

- (UIView *)freightLineView {
    if (_freightLineView == nil) {
        _freightLineView = [[UIView alloc] init];
        _freightLineView.backgroundColor = HEXCOLOR(0xf5f6fa);
    }
    return _freightLineView;
}

- (UIView *)allowanceView {
    if (_allowanceView == nil) {
        _allowanceView = [[UIView alloc] init];
        _allowanceView.clipsToBounds = YES;
    }
    return _allowanceView;
}

- (UILabel *)allowanceTagLabel {
    if (_allowanceTagLabel == nil) {
        _allowanceTagLabel = [[UILabel alloc] init];
        _allowanceTagLabel.textColor = HEXCOLOR(0x333333);
        _allowanceTagLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _allowanceTagLabel.text = @"津贴";
    }
    return _allowanceTagLabel;
}

- (UILabel *)allowanceValueLabel {
    if (_allowanceValueLabel == nil) {
        _allowanceValueLabel = [[UILabel alloc] init];
        _allowanceValueLabel.textColor = HEXCOLOR(0x333333);
        _allowanceValueLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _allowanceValueLabel.text = @"";
    }
    return _allowanceValueLabel;
}

- (UIView *)allowanceLineView {
    if (_allowanceLineView == nil) {
        _allowanceLineView = [[UIView alloc] init];
        _allowanceLineView.backgroundColor = HEXCOLOR(0xf5f6fa);
    }
    return _allowanceLineView;
}

- (UIView *)realPriceView {
    if (_realPriceView == nil) {
        _realPriceView = [[UIView alloc] init];
    }
    return _realPriceView;
}

- (UILabel *)realPriceTagLabel {
    if (_realPriceTagLabel == nil) {
        _realPriceTagLabel = [[UILabel alloc] init];
        _realPriceTagLabel.textColor = HEXCOLOR(0x333333);
        _realPriceTagLabel.font = [UIFont fontWithName:kFontMedium size:13];
        _realPriceTagLabel.text = @"实付款:";
    }
    return _realPriceTagLabel;
}

- (UILabel *)realPriceValueLabel {
    if (_realPriceValueLabel == nil) {
        _realPriceValueLabel = [[UILabel alloc] init];
        _realPriceValueLabel.textColor = HEXCOLOR(0xff4200);
        _realPriceValueLabel.font = [UIFont fontWithName:kFontBoldDIN size:16];
        _realPriceValueLabel.text = @"";
    }
    return _realPriceValueLabel;
}
@end
