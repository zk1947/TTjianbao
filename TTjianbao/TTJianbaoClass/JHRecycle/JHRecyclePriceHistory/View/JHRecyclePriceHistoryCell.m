//
//  JHRecyclePriceHistoryCell.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/3/23.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRecyclePriceHistoryCell.h"
#import "JHRecyclePriceHistoryModel.h"
#import "UIImageView+JHWebImage.h"
#import "NSString+AttributedString.h"
#import "JHRecyleRowLabelView.h"
#import "JHRecycleOrderDetailViewController.h"
#import "JHWebViewController.h"
@interface JHRecyclePriceHistoryCell()
/** 背景色视图*/
@property (nonatomic, strong) UIView *backView;
/** 图片*/
@property (nonatomic, strong) UIImageView *productImageView;
/** 标题*/
@property (nonatomic, strong) UILabel *productTitleLabel;
/** 分类*/
@property (nonatomic, strong) UILabel *productTypeLabel;
/** 状态*/
@property (nonatomic, strong) UILabel *statusLabel;
/** 我的出价*/
@property (nonatomic, strong) UILabel *priceLabel;
/** 小贴士*/
@property (nonatomic, strong) JHRecyleRowLabelView *arrowTipsLabel;
/** 按钮*/
@property (nonatomic, strong) UIButton *payButton;
/** 蒙层*/
@property (nonatomic, strong) UIView *hubView;

@end
@implementation JHRecyclePriceHistoryCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = HEXCOLOR(0xf5f5f8);
        [self configUI];
    }
    return self;
}

- (void)setModel:(JHRecyclePriceHistoryModel *)model {
    _model = model;
    [self.productImageView jh_setImageWithUrl:model.productImage.small];
    self.productTitleLabel.text = [NSString stringWithFormat:@"回收说明: %@", model.productDesc];
    self.productTypeLabel.text = [NSString stringWithFormat:@"回收分类: %@", model.categoryName];
    self.priceLabel.text = [NSString stringWithFormat:@"我的出价: ¥%@", model.bidPriceYuan];
    
    switch (model.bidStatus) {
        case 0:
            self.statusLabel.text = @"待用户确认出价";
            break;
        case 3:
            self.statusLabel.text = @"中标";
            break;
        case 6:
            self.statusLabel.text = @"失效";
            break;
        default:
            break;
    }
    //出价
    NSMutableArray *itemsArrayPrice = [NSMutableArray array];
    itemsArrayPrice[0] = @{@"string":@"我的出价: ", @"color":HEXCOLOR(0x333333), @"font":[UIFont fontWithName:kFontNormal size:13]};
    if (model.bidStatus != 0 && model.bidStatus != 3) {
        itemsArrayPrice[1] = @{@"string":[NSString stringWithFormat:@"¥%@", model.bidPriceYuan], @"color":HEXCOLOR(0x333333), @"font":[UIFont fontWithName:kFontBoldDIN size:18]};
    } else {
        itemsArrayPrice[1] = @{@"string":[NSString stringWithFormat:@"¥%@", model.bidPriceYuan], @"color":HEXCOLOR(0xff4200), @"font":[UIFont fontWithName:kFontBoldDIN size:18]};
    }
    self.priceLabel.attributedText = [NSString mergeStrings:itemsArrayPrice];

    
    if (model.bidStatus == 3) {
        [self.payButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.arrowTipsLabel.mas_bottom).offset(12);
            make.height.mas_equalTo(30);
        }];
    } else {
        [self.payButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.arrowTipsLabel.mas_bottom);
            make.height.mas_equalTo(0);
        }];
    }
    
    if (model.bidStatus != 0 && model.bidStatus != 3) {
        self.hubView.hidden = NO;
        self.arrowTipsLabel.tipsbackColor = HEXCOLOR(0xeeeeee);
        self.arrowTipsLabel.tipsLabel.textColor = HEXCOLOR(0x999999);
        self.arrowTipsLabel.tipsLabel.text = [NSString stringWithFormat:@"小贴士: %@", model.tipDesc];
        
        self.statusLabel.textColor = HEXCOLOR(0x666666);
    } else {
        self.hubView.hidden = YES;
        self.arrowTipsLabel.tipsbackColor = HEXCOLORA(0xffd70f, 0.1);
        
        //小贴士
        NSMutableArray *itemsArraytips = [NSMutableArray array];
        itemsArraytips[0] = @{@"string":@"小贴士: ", @"color":HEXCOLOR(0x666666), @"font":[UIFont fontWithName:kFontNormal size:12]};
        itemsArraytips[1] = @{@"string":model.tipDesc, @"color":HEXCOLOR(0xff4200), @"font":[UIFont fontWithName:kFontNormal size:12]};
        self.arrowTipsLabel.tipsLabel.attributedText = [NSString mergeStrings:itemsArraytips];
        
        self.statusLabel.textColor = HEXCOLOR(0xff4200);
    }
}

- (void)buttonClickAction:(UIButton *)sender {
    JHWebViewController *webView = [[JHWebViewController alloc] init];
    webView.urlString = [NSString stringWithFormat:H5_BASE_STRING(@"/jianhuo/app/recycle/order/orderDetail.html?orderId=%@"), self.model.orderId];
    [self.viewController.navigationController pushViewController:webView animated:YES];
}

- (void)configUI {
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.productImageView];
    [self.backView addSubview:self.productTypeLabel];
    [self.backView addSubview:self.productTitleLabel];
    [self.backView addSubview:self.statusLabel];
    [self.backView addSubview:self.priceLabel];
    [self.backView addSubview:self.arrowTipsLabel];
    [self.backView addSubview:self.payButton];
    [self.backView addSubview:self.hubView];
    
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.bottom.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-10);
    }];
    
    [self.productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backView).offset(10);
        make.left.mas_equalTo(self.backView).offset(10);
        make.width.height.mas_equalTo(75);
    }];
    
    [self.productTypeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.productImageView);
        make.left.mas_equalTo(self.productImageView.mas_right).offset(10);
        make.right.mas_equalTo(self.backView).offset(-10);
    }];
    
    [self.productTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.productTypeLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(self.productImageView.mas_right).offset(10);
        make.right.mas_equalTo(self.backView).offset(-10);
    }];
    
    [self.statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.productImageView.mas_bottom).offset(12);
        make.left.mas_equalTo(self.backView).offset(10);
        make.height.mas_equalTo(17);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.statusLabel);
        make.right.mas_equalTo(self.backView).offset(-10);
    }];
    
    [self.arrowTipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.statusLabel.mas_bottom).offset(3);
        make.left.mas_equalTo(self.backView).offset(10);
        make.right.mas_equalTo(self.backView).offset(-10);
    }];
    
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.arrowTipsLabel.mas_bottom).offset(12);
        make.right.mas_equalTo(self.backView).offset(-10);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(84);
        make.bottom.mas_equalTo(self.backView).offset(-10);
    }];
    
    [self.hubView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.backView);
    }];
}

- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = HEXCOLOR(0xffffff);
        _backView.layer.cornerRadius = 8;
        _backView.clipsToBounds = YES;
    }
    return _backView;
}

- (UIImageView *)productImageView {
    if (_productImageView == nil) {
        _productImageView = [[UIImageView alloc] init];
        _productImageView.image = kDefaultCoverImage;
        _productImageView.layer.cornerRadius = 4;
        _productImageView.clipsToBounds = YES;
        _productImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _productImageView;
}

- (UILabel *)productTypeLabel {
    if (_productTypeLabel == nil) {
        _productTypeLabel = [[UILabel alloc] init];
        _productTypeLabel.textColor = HEXCOLOR(0x333333);
        _productTypeLabel.font = [UIFont fontWithName:kFontMedium size:14];
        _productTypeLabel.text = @"";
    }
    return _productTypeLabel;
}

- (UILabel *)productTitleLabel {
    if (_productTitleLabel == nil) {
        _productTitleLabel = [[UILabel alloc] init];
        _productTitleLabel.textColor = HEXCOLOR(0x666666);
        _productTitleLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _productTitleLabel.text = @"";
        _productTitleLabel.numberOfLines = 2;
    }
    return _productTitleLabel;
}

- (UILabel *)statusLabel {
    if (_statusLabel == nil) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor = HEXCOLOR(0xff4200);
        _statusLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _statusLabel.text = @"";
    }
    return _statusLabel;
}

- (UILabel *)priceLabel {
    if (_priceLabel == nil) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.textColor = HEXCOLOR(0x333333);
        _priceLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _priceLabel.text = @"";
    }
    return _priceLabel;
}

- (JHRecyleRowLabelView *)arrowTipsLabel {
    if (_arrowTipsLabel == nil) {
        _arrowTipsLabel = [[JHRecyleRowLabelView alloc] init];
        [_arrowTipsLabel drawArrowWithPoint:25];
    }
    return _arrowTipsLabel;
}

- (UIButton *)payButton {
    if (_payButton == nil) {
        _payButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_payButton setTitle:@"查看订单" forState:UIControlStateNormal];
        _payButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
        [_payButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        _payButton.layer.cornerRadius = 15;
        _payButton.clipsToBounds = YES;
        _payButton.backgroundColor = HEXCOLOR(0xffd70f);
        [_payButton addTarget:self action:@selector(buttonClickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _payButton;
}

- (UIView *)hubView {
    if (_hubView == nil) {
        _hubView = [[UIView alloc] init];
        _hubView.backgroundColor = HEXCOLORA(0xffffff, 0.3);
        _hubView.hidden = YES;
    }
    return _hubView;
}


@end
