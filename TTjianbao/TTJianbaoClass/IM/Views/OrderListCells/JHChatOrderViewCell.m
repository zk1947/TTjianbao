//
//  JHChatOrderViewCell.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/25.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatOrderViewCell.h"
#import "JHChatUserManager.h"
const static CGFloat LeftSpace = 12.f;

@interface JHChatOrderViewCell()
@property (nonatomic, strong) UILabel *orderIDLabel;
@property (nonatomic, strong) UILabel *orderStateLabel;
@property (nonatomic, strong) UIImageView *goodsIcon;
@property (nonatomic, strong) UILabel *goodsTitleLabel;
@property (nonatomic, strong) UILabel *orderDateLabel;
/// 商品金额
@property (nonatomic, strong) UILabel *priceLabel;
/// ¥
@property (nonatomic, strong) UILabel *priceTLabel;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIButton *showButton;
@property (nonatomic, strong) UIView *line;
@end

@implementation JHChatOrderViewCell
#pragma mark - Init
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self layoutViews];
}
- (void)didClickSend : (UIButton *)sender {
    [self.sendSubject sendNext:nil];
}

- (void)gotoDetailPage : (UIButton *)sender {
    [self.detailSubject sendNext:nil];
}

- (void)bindData {
    if (self.model == nil) return;
    JHChatOrderInfoModel *model = self.model;
    self.priceLabel.text = model.price;
    self.goodsTitleLabel.text = model.title;
    self.orderDateLabel.text = model.orderDate;
    
    [self.goodsIcon jh_setImageWithUrl:model.iconUrl placeHolder:@""];
    self.orderIDLabel.text = [@"订单号:" stringByAppendingString: model.orderCode];
    
    NSString *userId = [JHChatUserManager sharedManager].userId;
    if ([self.model.customerId isEqualToString:userId]) {
        self.orderStateLabel.text = model.orderStatusDescBuyer;
    }else {
        self.orderStateLabel.text = model.orderStatusDescSeller;
    }
}
- (void)setupUI {
    [self addSubview:self.orderIDLabel];
    [self addSubview:self.orderStateLabel];
    [self addSubview:self.goodsIcon];
    [self addSubview:self.goodsTitleLabel];
    [self addSubview:self.orderDateLabel];
    [self addSubview:self.priceLabel];
    [self addSubview:self.priceTLabel];
    [self addSubview:self.sendButton];
    [self addSubview:self.showButton];
    [self addSubview:self.line];
}
- (void)layoutViews {
    [self.orderIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12);
        make.left.mas_equalTo(LeftSpace);
    }];
    [self.orderStateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.orderIDLabel);
        make.right.mas_equalTo(-LeftSpace);
    }];
    [self.goodsIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(40);
        make.left.mas_equalTo(self.orderIDLabel);
        make.bottom.mas_equalTo(-18);
        make.width.mas_equalTo(self.goodsIcon.mas_height);
    }];
    [self.goodsTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodsIcon.mas_top).offset(2);
        make.left.mas_equalTo(self.goodsIcon.mas_right).offset(8);
        make.right.mas_equalTo(-98);
    }];
    [self.orderDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-18);
        make.left.mas_equalTo(self.goodsTitleLabel);
        make.right.mas_equalTo(self.goodsTitleLabel);
    }];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodsIcon.mas_top).offset(4);
        make.right.mas_equalTo(self.orderStateLabel);
    }];
    [self.priceTLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.priceLabel);
        make.right.mas_equalTo(self.priceLabel.mas_left).offset(-1);
        make.left.mas_greaterThanOrEqualTo(self.goodsTitleLabel.mas_right).offset(5);
    }];
    [self.sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-12);
        make.right.mas_equalTo(-LeftSpace);
        make.size.mas_equalTo(CGSizeMake(64, 28));
    }];
    [self.showButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-12);
        make.right.mas_equalTo(self.sendButton.mas_left).offset(-LeftSpace);
        make.size.mas_equalTo(CGSizeMake(64, 28));
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(LeftSpace);
        make.right.mas_equalTo(-LeftSpace);
        make.height.mas_equalTo(0.5);
    }];
}
#pragma mark - LAZY
- (void)setModel:(JHChatOrderInfoModel *)model {
    _model = model;
    [self bindData];
}

- (UILabel *)orderIDLabel {
    if (!_orderIDLabel) {
        _orderIDLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _orderIDLabel.textColor = HEXCOLOR(0x999999);
        _orderIDLabel.font = [UIFont fontWithName:kFontMedium size:11];
        _orderIDLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _orderIDLabel;
}
- (UILabel *)orderStateLabel {
    if (!_orderStateLabel) {
        _orderStateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _orderStateLabel.textColor = HEXCOLOR(0xf23730);
        _orderStateLabel.font = [UIFont fontWithName:kFontMedium size:13];
        _orderStateLabel.textAlignment = NSTextAlignmentRight;
    }
    return _orderStateLabel;
}
- (UIImageView *)goodsIcon {
    if (!_goodsIcon) {
        _goodsIcon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _goodsIcon.image = [UIImage imageNamed:@"jh_newStore_type_defaulticon"];
        _goodsIcon.contentMode = UIViewContentModeScaleAspectFill;
        [_goodsIcon jh_cornerRadius:5];
    }
    return _goodsIcon;
}
- (UILabel *)goodsTitleLabel {
    if (!_goodsTitleLabel) {
        _goodsTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _goodsTitleLabel.numberOfLines = 2;
        _goodsTitleLabel.textColor = HEXCOLOR(0x333333);
        _goodsTitleLabel.font = [UIFont fontWithName:kFontMedium size:14];
        _goodsTitleLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _goodsTitleLabel;
}
- (UILabel *)orderDateLabel {
    if (!_orderDateLabel) {
        _orderDateLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _orderDateLabel.textColor = HEXCOLOR(0x999999);
        _orderDateLabel.font = [UIFont fontWithName:kFontMedium size:11];
        _orderDateLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _orderDateLabel;
}
- (UILabel *)priceTLabel {
    if (!_priceTLabel) {
        _priceTLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceTLabel.text = @"¥";
        _priceTLabel.textColor = HEXCOLOR(0x333333);
        _priceTLabel.font = [UIFont fontWithName:kFontNormal size:9];
        _priceTLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _priceTLabel;
}
- (UILabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.textColor = HEXCOLOR(0x333333);
        _priceLabel.font = [UIFont fontWithName:kFontBoldDIN size:14];
        _priceLabel.textAlignment = NSTextAlignmentRight;
    }
    return _priceLabel;
}
- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton jh_cornerRadius:4];
        _sendButton.backgroundColor = HEXCOLOR(0xffd70f);
        [_sendButton setTitle:@"发送订单" forState:UIControlStateNormal];
        [_sendButton setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _sendButton.tag = 2021;
        [_sendButton addTarget:self action:@selector(didClickSend:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}
- (UIButton *)showButton {
    if (!_showButton) {
        _showButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_showButton jh_cornerRadius:4];
        _showButton.backgroundColor = HEXCOLOR(0xffffff);
        [_showButton setTitle:@"查看详情" forState:UIControlStateNormal];
        [_showButton setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
        _showButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
        _showButton.layer.borderColor = HEXCOLOR(0xBDBFC2).CGColor;
        _showButton.layer.borderWidth = 0.5;
        _showButton.tag = 2022;
        [_showButton addTarget:self action:@selector(gotoDetailPage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _showButton;
}
- (UIView *)line {
    if (!_line) {
        _line = [[UIView alloc] initWithFrame:CGRectZero];
        _line.backgroundColor = HEXCOLOR(0xf0f0f0);
    }
    return _line;
}
- (RACSubject *)sendSubject {
    if (!_sendSubject) {
        _sendSubject = [RACSubject subject];
    }
    return _sendSubject;
}
- (RACSubject *)detailSubject {
    if (!_detailSubject) {
        _detailSubject = [RACSubject subject];
    }
    return _detailSubject;
}
@end
