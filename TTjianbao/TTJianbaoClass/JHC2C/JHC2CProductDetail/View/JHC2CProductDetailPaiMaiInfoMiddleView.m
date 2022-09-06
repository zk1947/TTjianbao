//
//  JHC2CProductDetailPaiMaiInfoMiddleView.m
//  TTjianbao
//
//  Created by jingxuelong on 2021/5/20.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CProductDetailPaiMaiInfoMiddleView.h"

@interface JHC2CProductDetailPaiMaiInfoMiddleView()

@property(nonatomic) BOOL  hasRefersh;

@property(nonatomic, strong) UILabel * buyCountValueLbl;
@property(nonatomic, strong) UILabel * beginMoneyLbl;
@property(nonatomic, strong) UILabel * addMoneyLbl;


@end

@implementation JHC2CProductDetailPaiMaiInfoMiddleView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setItems];
        [self layoutItems];
    }
    return self;
}

- (void)setItems{
    [self addSubview:self.titleLbl];
    [self addSubview:self.beginLbl];
    [self addSubview:self.beginMoneyLbl];
    [self addSubview:self.addPriceLbl];
    [self addSubview:self.addMoneyLbl];
    [self addSubview:self.bugCountLbl];
    [self addSubview:self.buyCountValueLbl];
}

- (void)layoutItems{
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(14);
        make.left.equalTo(@0).offset(12);
    }];
    [self.beginLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLbl);
        make.left.equalTo(self.titleLbl.mas_right).offset(15);
    }];
    [self.beginMoneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLbl);
        make.left.equalTo(self.beginLbl.mas_right).offset(4);
//        make.width.mas_greaterThanOrEqualTo(45);
    }];
    [self.addPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLbl);
        make.left.equalTo(self.beginMoneyLbl.mas_right).offset(10);
    }];
    [self.addMoneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLbl);
        make.left.equalTo(self.addPriceLbl.mas_right).offset(4);
//        make.width.mas_greaterThanOrEqualTo(45);
    }];
    
    [self.bugCountLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLbl);
        make.left.equalTo(self.addMoneyLbl.mas_right).offset(10);
        make.bottom.equalTo(@0).offset(-14);
    }];
    [self.buyCountValueLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bugCountLbl);
        make.left.equalTo(self.bugCountLbl.mas_right).offset(4);
    }];
}

- (void)refrshStartMoney:(NSString *)startMoney andAddMoney:(NSString *)addMoney andCount:(NSString *)count{
    self.beginMoneyLbl.text = [@"￥" stringByAppendingString:startMoney];
    self.addMoneyLbl.text = [@"￥" stringByAppendingString:addMoney];
    self.buyCountValueLbl.text = count;

    CGFloat height1 = [self getHeightForString: startMoney];
    CGFloat height2 = [self getHeightForString: addMoney];
    if (height1 + height2 > 60 && !self.hasRefersh) {
        self.hasRefersh = YES;
        [self.bugCountLbl mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLbl.mas_bottom).offset(14);
            make.left.equalTo(@0).offset(12);
            make.bottom.equalTo(@0).offset(-14);
        }];
        [NSNotificationCenter.defaultCenter postNotificationName:@"JHC2CProductDetailControllerNeedReloadLoad" object:nil];
    }
}

- (CGFloat)getHeightForString:(NSString*)str{
    CGSize size = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:@{NSFontAttributeName : [UI getDINBoldFont:14]} context:nil].size;
    return size.width;
}


- (UILabel *)titleLbl{
    if (!_titleLbl) {
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(14);
        label.text = @"拍卖说明";
        label.textColor = HEXCOLOR(0x333333);
        _titleLbl = label;
    }
    return _titleLbl;
}

- (UILabel *)beginMoneyLbl{
    if (!_beginMoneyLbl) {
        UILabel *label = [UILabel new];
        label.font = [UI getDINBoldFont:14];
        label.text = @"￥0";
        label.textColor = HEXCOLOR(0x222222);
        _beginMoneyLbl = label;
    }
    return _beginMoneyLbl;
}

- (UILabel *)addMoneyLbl{
    if (!_addMoneyLbl) {
        UILabel *label = [UILabel new];
        label.font = [UI getDINBoldFont:14];
        label.text = @"￥0";
        label.textColor = HEXCOLOR(0x222222);
        _addMoneyLbl = label;
    }
    return _addMoneyLbl;

}

- (UILabel *)buyCountValueLbl{
    if (!_buyCountValueLbl) {
        UILabel *label = [UILabel new];
        label.font = [UI getDINBoldFont:14];
        label.text = @"0次";
        label.textColor = HEXCOLOR(0x222222);
        _buyCountValueLbl = label;
    }
    return _buyCountValueLbl;
}


- (YYLabel *)beginLbl{
    if (!_beginLbl) {
        YYLabel *label = [YYLabel new];
        label.font = JHFont(10);
        label.textContainerInset = UIEdgeInsetsMake(1, 4, 1, 4);
        label.backgroundColor = HEXCOLORA(0xF23730,0.1);
        label.layer.cornerRadius = 2;
        label.text = @"起拍价";
        label.textColor = HEXCOLOR(0xF63421);
        _beginLbl = label;
    }
    return _beginLbl;
}
- (YYLabel *)addPriceLbl{
    if (!_addPriceLbl) {
        YYLabel *label = [YYLabel new];
        label.font = JHFont(10);
        label.textContainerInset = UIEdgeInsetsMake(1, 4, 1, 4);
        label.backgroundColor = HEXCOLORA(0xF23730,0.1);
        label.layer.cornerRadius = 2;
        label.text = @"加价幅度";
        label.textColor = HEXCOLOR(0xF63421);
        _addPriceLbl = label;
    }
    return _addPriceLbl;
}
- (YYLabel *)bugCountLbl{
    if (!_bugCountLbl) {
        YYLabel *label = [YYLabel new];
        label.font = JHFont(10);
        label.textContainerInset = UIEdgeInsetsMake(1, 4, 1, 4);
        label.backgroundColor = HEXCOLORA(0xF23730,0.1);
        label.layer.cornerRadius = 2;
        label.text = @"出价次数";
        label.textColor = HEXCOLOR(0xF63421);
        _bugCountLbl = label;
    }
    return _bugCountLbl;
}


@end
