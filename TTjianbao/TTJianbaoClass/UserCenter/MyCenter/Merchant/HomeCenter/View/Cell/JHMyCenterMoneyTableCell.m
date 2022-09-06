//
//  JHMyCenterMoneyTableCell.m
//  TTjianbao
//
//  Created by lihui on 2021/4/7.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMyCenterMoneyTableCell.h"
#import "JHMyCenterMerchantCellModel.h"
#import "YYControl.h"
#import "JHMyCenterDotModel.h"



@interface JHMyCenterMoneyTableCell ()
@property (nonatomic, strong) YYControl *moneyView;
@property (nonatomic, strong) YYControl *shopView;
@property (nonatomic, strong) UILabel *moneyTitleLabel;
@property (nonatomic, strong) UILabel *shopTitleLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UILabel *priceTipsLabel;
@property (nonatomic, strong) UIView *centerLine;

@property (nonatomic, strong) UILabel *shopTipsLabel;
@property (nonatomic, strong) UILabel *shopPriceTipsLabel;
@property (nonatomic, strong) UILabel *shopLastDataLabel;


@property(nonatomic, strong) UIImageView * noticeImageView;

@end

@implementation JHMyCenterMoneyTableCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = HEXCOLOR(0xF8F8F8);
        [self initViews];
    }
    return self;
}

- (void)initViews {
    UIView *content = [[UIView alloc] init];
    content.layer.cornerRadius = 6.f;
    content.layer.masksToBounds = YES;
    content.backgroundColor = kColorFFF;
    [self.contentView addSubview:content];
    [content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 12, 5, 12));
    }];
    
    ///中间的线条
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = HEXCOLOR(0xEDEDED);
    [content addSubview:line];
    _centerLine = line;
    
    ///资金管理相关
    YYControl *moneyView = [[YYControl alloc] init];
    moneyView.backgroundColor = kColorFFF;
    moneyView.exclusiveTouch = YES;
    _moneyView = moneyView;
    [content addSubview:moneyView];
    @weakify(self);
    _moneyView.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        @strongify(self);
        if (state == YYGestureRecognizerStateEnded) {
            UITouch *touch = touches.anyObject;
            CGPoint p = [touch locationInView:self];
            if (CGRectContainsPoint(self.bounds, p)) {
                [self clickMoney];
//                if (self.actionBlock) {
//                    self.actionBlock();
//                }
            }
        }
    };
    
    UILabel *moneyTitleLabel = [[UILabel alloc] init];
    moneyTitleLabel.text = @"资金管理";
    moneyTitleLabel.font = [UIFont fontWithName:kFontMedium size:15.];
    moneyTitleLabel.textColor = kColor222;
    [_moneyView addSubview:moneyTitleLabel];
    _moneyTitleLabel = moneyTitleLabel;
    
    [_moneyView addSubview:self.noticeImageView];
    [self.noticeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(moneyTitleLabel.mas_right).offset(3);
        make.centerY.equalTo(moneyTitleLabel);
        make.size.mas_equalTo(CGSizeMake(44.f, 16));
    }];
    UILabel *priceLabel = [[UILabel alloc] init];
    priceLabel.text = @"0";
    priceLabel.font = [UIFont fontWithName:kFontBoldDIN size:19.];
    priceLabel.textColor = kColor222;
    [_moneyView addSubview:priceLabel];
    _priceLabel = priceLabel;
    
    UILabel *yuanLabel = [[UILabel alloc] init];
    yuanLabel.text = @"元";
    yuanLabel.font = [UIFont fontWithName:kFontNormal size:10.];
    yuanLabel.textColor = kColor222;
    [_moneyView addSubview:yuanLabel];

    UILabel *priceTipsLabel = [[UILabel alloc] init];
    priceTipsLabel.text = @"可提现金额";
    priceTipsLabel.font = [UIFont fontWithName:kFontNormal size:12.];
    priceTipsLabel.textColor = kColor222;
    [_moneyView addSubview:priceTipsLabel];
    _priceTipsLabel = priceTipsLabel;
    
    YYControl *shopView = [[YYControl alloc] init];
    shopView.backgroundColor = kColorFFF;
    shopView.exclusiveTouch = YES;
    [content addSubview:shopView];
    _shopView = shopView;
    
    shopView.touchBlock = ^(YYControl *view, YYGestureRecognizerState state, NSSet *touches, UIEvent *event) {
        @strongify(self);
        if (state == YYGestureRecognizerStateEnded) {
            UITouch *touch = touches.anyObject;
            CGPoint p = [touch locationInView:self];
            if (CGRectContainsPoint(self.bounds, p)) {
                [self clickShopLastData];

//                if (self.actionBlock) {
//                    self.actionBlock();
//                }
            }
        }
    };
    
    UILabel *shopTitleLabel = [[UILabel alloc] init];
    shopTitleLabel.text = @"店铺数据";
    shopTitleLabel.font = [UIFont fontWithName:kFontMedium size:15.];
    shopTitleLabel.textColor = kColor222;
    [_shopView addSubview:shopTitleLabel];
    _shopTitleLabel = shopTitleLabel;
    
    UILabel *shopTipsLabel = [[UILabel alloc] init];
    shopTipsLabel.text = @"敬请期待";
    shopTipsLabel.font = [UIFont fontWithName:kFontNormal size:12.];
    shopTipsLabel.hidden = NO;
    shopTipsLabel.textColor = kColor999;
    [_shopView addSubview:shopTipsLabel];
    _shopTipsLabel = shopTipsLabel;
    
    UILabel *shopLastDataLabel = [[UILabel alloc] init];
    shopLastDataLabel.font = [UIFont fontWithName:kFontBoldDIN size:19.];
    shopLastDataLabel.textColor = kColor222;
    shopLastDataLabel.hidden = YES;
    [_shopView addSubview:shopLastDataLabel];
    _shopLastDataLabel = shopLastDataLabel;
    
    UILabel *shopPriceTipsLabel = [[UILabel alloc] init];
    shopPriceTipsLabel.text = @"昨日成交金额";
    shopPriceTipsLabel.font = [UIFont fontWithName:kFontNormal size:12.];
    shopPriceTipsLabel.textColor = kColor222;
    shopPriceTipsLabel.hidden = YES;
    [_shopView addSubview:shopPriceTipsLabel];
    _shopPriceTipsLabel = shopPriceTipsLabel;
    
    UILabel *yuanShopLabel = [[UILabel alloc] init];
    yuanShopLabel.text = @"元";
    yuanShopLabel.font = [UIFont fontWithName:kFontNormal size:10.];
    yuanShopLabel.textColor = kColor222;
    [_shopView addSubview:yuanShopLabel];
    
    
    [_centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(content).offset(-16);
        make.centerX.equalTo(content);
        make.size.mas_equalTo(CGSizeMake(.5f, 37.f));
    }];
    
    ///资金管理布局
    [_moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(content);
        make.right.equalTo(self.centerLine.mas_left);
        make.top.bottom.equalTo(content);
    }];
    
    ///店铺数据
    [_shopView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerLine.mas_right);
        make.right.equalTo(content).offset(-12);
        make.top.bottom.equalTo(content);
    }];

    [_moneyTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.moneyView).offset(12);
        make.top.equalTo(self.moneyView).offset(15);
    }];
    
    [_priceTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.moneyView);
        make.bottom.equalTo(self.moneyView).offset(-15);
    }];
    
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.priceTipsLabel.mas_top).offset(-5);
        make.centerX.equalTo(self.moneyView).offset(-5);
    }];
    
    [yuanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel.mas_right).offset(1);
        make.bottom.equalTo(self.priceLabel).offset(-2);
    }];
    
    
    
    ///

    [_shopTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerLine).offset(12);
        make.centerY.height.equalTo(self.moneyTitleLabel);
    }];
    
    [_shopPriceTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.shopView);
        make.bottom.equalTo(self.shopView).offset(-15);
    }];
    
    [_shopLastDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.shopPriceTipsLabel.mas_top).offset(-5);
        make.centerX.equalTo(self.shopView).offset(-5);
    }];
                
    [_shopTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.shopView);
        make.top.equalTo(self.shopTitleLabel.mas_bottom).offset(35);
    }];
    
    [yuanShopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopLastDataLabel.mas_right).offset(1);
        make.bottom.equalTo(self.shopLastDataLabel).offset(-2);
    }];
}

- (void)clickMoney {
    JHMyCenterMerchantCellButtonModel *model = [JHMyCenterMerchantCellButtonModel new];
    model.cellType = JHMyCenterMerchantPushTypeMoneyManger;
    [model pushViewController];
}

- (void)clickShopLastData {
    JHMyCenterMerchantCellButtonModel *model = [JHMyCenterMerchantCellButtonModel new];
    model.cellType = JHMyCenterMerchantPushTypeShopLastDayData;
    [model pushViewController];
}

- (void)setMoney:(NSString *)money {
    _money = money;
    if ([money isNotBlank]) {
        _priceLabel.text = money;
    }
}

- (void)setLastDayMoney:(NSString *)lastDayMoney {
    _lastDayMoney = lastDayMoney;
    if ([_lastDayMoney isNotBlank]) {
        _shopLastDataLabel.text    = lastDayMoney;
        _shopTipsLabel.hidden      = YES;
        _shopPriceTipsLabel.hidden = NO;
        _shopLastDataLabel.hidden  = NO;
    } else {
        _shopLastDataLabel.text    = @"0.00";
        _shopTipsLabel.hidden      = YES;
        _shopPriceTipsLabel.hidden = NO;
        _shopLastDataLabel.hidden  = NO;
    }
    NSInteger fundWaitManageCount =  [JHMyCenterDotModel shareInstance].fundWaitManageCount;
    self.noticeImageView.hidden = fundWaitManageCount == 0;
}

- (UIImageView *)noticeImageView{
    if (!_noticeImageView) {
        UIImageView *view = [UIImageView new];
        view.image = [UIImage imageNamed:@"center_zijinnotice"];
        
        UILabel *label = [UILabel new];
        label.font = JHMediumFont(11);
        label.textColor = HEXCOLOR(0xffffff);
        label.text = @"待缴费";
        [view addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(@0);
            make.centerX.equalTo(@0).offset(5);
        }];

        _noticeImageView = view;
    }
    return _noticeImageView;
}
@end
