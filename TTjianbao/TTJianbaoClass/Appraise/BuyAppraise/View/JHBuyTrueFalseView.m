//
//  JHBuyTrueFalseView.m
//  TTjianbao
//
//  Created by 王记伟 on 2020/12/16.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHBuyTrueFalseView.h"
#import "JHBuyAppraiseModel.h"

@interface JHBuyTrueFalseView(){
    CGFloat trueItemWidth;
}
/** 真视图*/
@property (nonatomic, strong) UIView *trueView;
/** 种类Tag*/
@property (nonatomic, strong) UILabel *typeTagLabel;
/** 种类Value*/
@property (nonatomic, strong) UILabel *typeValueLabel;
/** 日期Tag*/
@property (nonatomic, strong) UILabel *dateTagLabel;
/** 日期Value*/
@property (nonatomic, strong) UILabel *dateValueLabel;
/** 商家Tag*/
@property (nonatomic, strong) UILabel *storeTagLabel;
/** 商家Value*/
@property (nonatomic, strong) UILabel *storeValueLabel;

/** 假视图*/
@property (nonatomic, strong) UIView *falseView;
/** 性价比Tag*/
@property (nonatomic, strong) UILabel *priceTagLabel;
/** 性价比Value*/
@property (nonatomic, strong) UILabel *priceValueLabel;
/** 保值空间Tag*/
@property (nonatomic, strong) UILabel *preserveTagLabel;
/** 保值空间Value*/
@property (nonatomic, strong) UILabel *preserveValueLabel;
/** 稀有度Tag*/
@property (nonatomic, strong) UILabel *rareTagLabel;
/** 稀有度Value*/
@property (nonatomic, strong) UILabel *rareValueLabel;
/** 工艺Tag*/
@property (nonatomic, strong) UILabel *artTagLabel;
/** 工艺Value*/
@property (nonatomic, strong) UILabel *artValueLabel;

@end
@implementation JHBuyTrueFalseView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = HEXCOLOR(0xf7f7f7);
        trueItemWidth = (kScreenWidth - 24 - 9 - 50) / 4.f;
        [self configUI];
    }
    return self;
}

- (void)setIsWorksTrue:(BOOL)isWorksTrue{
    _isWorksTrue = isWorksTrue;
    if (isWorksTrue) {
        [self.trueView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(45);
        }];
        [self.falseView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
    }else{
        [self.trueView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(0);
        }];
        [self.falseView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(60);
        }];
    }
}

- (void)setModel:(JHBuyAppraiseModel *)model{
    _model = model;
    if ([model.appraiseType isEqualToString:@"0"]) {  //真
        self.priceValueLabel.text = model.positive.scoreCost;
        self.preserveValueLabel.text = model.positive.scoreHedging;
        self.rareValueLabel.text = model.positive.scoreRare;
        self.artValueLabel.text = model.positive.scoreCraft;
    }else{
        self.typeValueLabel.text = model.negative.qualitySecondType;
        self.dateValueLabel.text = model.negative.time;
        self.storeValueLabel.text = model.negative.businessName;
    }
}
- (void)configUI{
    
    [self addSubview:self.falseView];
    [self.falseView addSubview:self.typeTagLabel];
    [self.falseView addSubview:self.typeValueLabel];
    [self.falseView addSubview:self.dateTagLabel];
    [self.falseView addSubview:self.dateValueLabel];
    [self.falseView addSubview:self.storeTagLabel];
    [self.falseView addSubview:self.storeValueLabel];
    
    [self addSubview:self.trueView];
    [self.trueView addSubview:self.priceTagLabel];
    [self.trueView addSubview:self.priceValueLabel];
    [self.trueView addSubview:self.preserveTagLabel];
    [self.trueView addSubview:self.preserveValueLabel];
    [self.trueView addSubview:self.rareTagLabel];
    [self.trueView addSubview:self.rareValueLabel];
    [self.trueView addSubview:self.artTagLabel];
    [self.trueView addSubview:self.artValueLabel];

    
    [self.falseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_top).offset(9);
        make.left.mas_equalTo(self.mas_left).offset(9);
        make.right.mas_equalTo(self.mas_right).offset(-9);
        make.height.mas_equalTo(60);   //18*3 + 3*2 = 60;
    }];
    
    [self.typeTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.falseView.mas_top);
        make.left.mas_equalTo(self.falseView.mas_left);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(18);
    }];
    
    [self.typeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.typeTagLabel.mas_top);
        make.left.mas_equalTo(self.typeTagLabel.mas_right).offset(10);
        make.right.mas_equalTo(self.falseView.mas_right);
        make.height.mas_equalTo(18);
    }];
    
    [self.dateTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.typeTagLabel.mas_bottom).offset(3);
        make.left.mas_equalTo(self.falseView.mas_left);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(18);
    }];
    
    [self.dateValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dateTagLabel.mas_top);
        make.left.mas_equalTo(self.dateTagLabel.mas_right).offset(10);
        make.right.mas_equalTo(self.falseView.mas_right);
        make.height.mas_equalTo(18);
    }];
    
    [self.storeTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.dateTagLabel.mas_bottom).offset(3);
        make.left.mas_equalTo(self.falseView.mas_left);
        make.width.mas_equalTo(65);
        make.height.mas_equalTo(18);
    }];
    
    [self.storeValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.storeTagLabel.mas_top);
        make.left.mas_equalTo(self.storeTagLabel.mas_right).offset(10);
        make.right.mas_equalTo(self.falseView.mas_right);
        make.height.mas_equalTo(18);
    }];
    
    [self.trueView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.falseView.mas_bottom);
        make.left.mas_equalTo(self.mas_left).offset(9);
        make.right.mas_equalTo(self.mas_right).offset(-9);
        make.height.mas_equalTo(45);   //23 + 5 + 17 = 45;
        make.bottom.mas_equalTo(self.mas_bottom).offset(-9);
    }];
    
    [self.priceValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.trueView.mas_top);
        make.left.mas_equalTo(self.trueView.mas_left);
        make.width.mas_equalTo(trueItemWidth);
        make.height.mas_equalTo(23);
    }];
    
    [self.priceTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.priceValueLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.priceValueLabel.mas_left);
        make.width.mas_equalTo(trueItemWidth);
        make.height.mas_equalTo(17);
    }];
    
    [self.preserveValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.trueView.mas_top);
        make.left.mas_equalTo(self.priceValueLabel.mas_right);
        make.width.mas_equalTo(trueItemWidth);
        make.height.mas_equalTo(23);
    }];
    
    [self.preserveTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.preserveValueLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.preserveValueLabel.mas_left);
        make.width.mas_equalTo(trueItemWidth);
        make.height.mas_equalTo(17);
    }];
    
    [self.rareValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.trueView.mas_top);
        make.left.mas_equalTo(self.preserveValueLabel.mas_right);
        make.width.mas_equalTo(trueItemWidth);
        make.height.mas_equalTo(23);
    }];
    
    [self.rareTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.rareValueLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.rareValueLabel.mas_left);
        make.width.mas_equalTo(trueItemWidth);
        make.height.mas_equalTo(17);
    }];
    
    [self.artValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.trueView.mas_top);
        make.left.mas_equalTo(self.rareValueLabel.mas_right);
        make.width.mas_equalTo(trueItemWidth);
        make.height.mas_equalTo(23);
    }];
    
    [self.artTagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.artValueLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.artValueLabel.mas_left);
        make.width.mas_equalTo(trueItemWidth);
        make.height.mas_equalTo(17);
    }];
}

/** 假*/
- (UIView *)falseView{
    if (_falseView == nil) {
        _falseView = [[UIView alloc] init];
        _falseView.clipsToBounds = YES;
    }
    return _falseView;
}

- (UILabel *)typeTagLabel{
    if (_typeTagLabel == nil) {
        _typeTagLabel = [[UILabel alloc] init];
        _typeTagLabel.textColor = HEXCOLOR(0x999999);
        _typeTagLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _typeTagLabel.text = @"问题件种类";
    }
    return _typeTagLabel;
}

- (UILabel *)typeValueLabel{
    if (_typeValueLabel == nil) {
        _typeValueLabel = [[UILabel alloc] init];
        _typeValueLabel.textColor = HEXCOLOR(0x222222);
        _typeValueLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _typeValueLabel.text = @"假货";
    }
    return _typeValueLabel;
}

- (UILabel *)dateTagLabel{
    if (_dateTagLabel == nil) {
        _dateTagLabel = [[UILabel alloc] init];
        _dateTagLabel.textColor = HEXCOLOR(0x999999);
        _dateTagLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _dateTagLabel.text = @"处理日期";
    }
    return _dateTagLabel;
}

- (UILabel *)dateValueLabel{
    if (_dateValueLabel == nil) {
        _dateValueLabel = [[UILabel alloc] init];
        _dateValueLabel.textColor = HEXCOLOR(0x222222);
        _dateValueLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _dateValueLabel.text = @"2020-11-11";
    }
    return _dateValueLabel;
}

- (UILabel *)storeTagLabel{
    if (_storeTagLabel == nil) {
        _storeTagLabel = [[UILabel alloc] init];
        _storeTagLabel.textColor = HEXCOLOR(0x999999);
        _storeTagLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _storeTagLabel.text = @"处理商家";
    }
    return _storeTagLabel;
}

- (UILabel *)storeValueLabel{
    if (_storeValueLabel == nil) {
        _storeValueLabel = [[UILabel alloc] init];
        _storeValueLabel.textColor = HEXCOLOR(0x222222);
        _storeValueLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _storeValueLabel.text = @"四会翡翠手镯串珠源头代购";
    }
    return _storeValueLabel;
}


/** 真*/
- (UIView *)trueView{
    if (_trueView == nil) {
        _trueView = [[UIView alloc] init];
        _trueView.clipsToBounds = YES;
    }
    return _trueView;
}

- (UILabel *)priceTagLabel{
    if (_priceTagLabel == nil) {
        _priceTagLabel = [[UILabel alloc] init];
        _priceTagLabel.textColor = HEXCOLOR(0x666666);
        _priceTagLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _priceTagLabel.text = @"性价比";
    }
    return _priceTagLabel;
}

- (UILabel *)priceValueLabel{
    if (_priceValueLabel == nil) {
        _priceValueLabel = [[UILabel alloc] init];
        _priceValueLabel.textColor = HEXCOLOR(0x222222);
        _priceValueLabel.font = [UIFont fontWithName:kFontBoldDIN size:19];
        _priceValueLabel.text = @"00.00";
    }
    return _priceValueLabel;
}

- (UILabel *)preserveTagLabel{
    if (_preserveTagLabel == nil) {
        _preserveTagLabel = [[UILabel alloc] init];
        _preserveTagLabel.textColor = HEXCOLOR(0x666666);
        _preserveTagLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _preserveTagLabel.text = @"保值空间";
    }
    return _preserveTagLabel;
}

- (UILabel *)preserveValueLabel{
    if (_preserveValueLabel == nil) {
        _preserveValueLabel = [[UILabel alloc] init];
        _preserveValueLabel.textColor = HEXCOLOR(0x222222);
        _preserveValueLabel.font = [UIFont fontWithName:kFontBoldDIN size:19];
        _preserveValueLabel.text = @"00.00";
    }
    return _preserveValueLabel;
}

- (UILabel *)rareTagLabel{
    if (_rareTagLabel == nil) {
        _rareTagLabel = [[UILabel alloc] init];
        _rareTagLabel.textColor = HEXCOLOR(0x666666);
        _rareTagLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _rareTagLabel.text = @"稀有度";
    }
    return _rareTagLabel;
}

- (UILabel *)rareValueLabel{
    if (_rareValueLabel == nil) {
        _rareValueLabel = [[UILabel alloc] init];
        _rareValueLabel.textColor = HEXCOLOR(0x222222);
        _rareValueLabel.font = [UIFont fontWithName:kFontBoldDIN size:19];
        _rareValueLabel.text = @"00.00";
    }
    return _rareValueLabel;
}

- (UILabel *)artTagLabel{
    if (_artTagLabel == nil) {
        _artTagLabel = [[UILabel alloc] init];
        _artTagLabel.textColor = HEXCOLOR(0x666666);
        _artTagLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _artTagLabel.text = @"工艺";
    }
    return _artTagLabel;
}

- (UILabel *)artValueLabel{
    if (_artValueLabel == nil) {
        _artValueLabel = [[UILabel alloc] init];
        _artValueLabel.textColor = HEXCOLOR(0x222222);
        _artValueLabel.font = [UIFont fontWithName:kFontBoldDIN size:19];
        _artValueLabel.text = @"00.00";
    }
    return _artValueLabel;
}

@end
