//
//  JHMarketContactCell.m
//  TTjianbao
//
//  Created by 王记伟 on 2021/5/18.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMarketContactCell.h"
#import "JHMarketOrderModel.h"
#import "JHSessionViewController.h"
#import "JHIMEntranceManager.h"

@interface JHMarketContactCell()
/** 背景色视图*/
@property (nonatomic, strong) UIView *backView;
/** 复制按钮*/
@property (nonatomic, strong) UIButton *contactButton;
@end

@implementation JHMarketContactCell

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
}

- (void)setIsBuyer:(BOOL)isBuyer {
    _isBuyer = isBuyer;
    [self.contactButton setTitle: isBuyer ? @"联系卖家" : @"联系买家" forState:UIControlStateNormal];
}

- (void)contactButtonClick {
    JHChatOrderInfoModel *model = [[JHChatOrderInfoModel alloc] init];
    model.marketOrderType = self.isBuyer ? 1 : 2;
    model.iconUrl = self.model.goodsUrl.small;
    model.title = self.model.goodsName;
    model.price = self.model.orderPrice;
    model.orderState = self.model.orderStatusText;
    model.orderDate = self.model.orderCreateTime;
    model.orderId = self.model.orderId;
    model.orderCode = self.model.orderCode;
    model.orderLoadingCategory = @"market";
    [JHIMEntranceManager pushSessionWithUserId:self.model.customerId orderInfo:model];
}

- (void)configUI {
    [self.contentView addSubview:self.backView];
    [self.backView addSubview:self.contactButton];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).offset(10);
        make.bottom.mas_equalTo(self.contentView).offset(-50);
        make.left.mas_equalTo(self.contentView).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.height.mas_equalTo(36);
    }];
    
    [self.contactButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
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

- (UIButton *)contactButton {
    if (_contactButton == nil) {
        _contactButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_contactButton setImage:[UIImage imageNamed:@"c2c_contactSeller_icon"] forState:UIControlStateNormal];
        [_contactButton setTitle:@"联系卖家" forState:UIControlStateNormal];
        _contactButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:13];
        [_contactButton setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
        [_contactButton addTarget:self action:@selector(contactButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _contactButton;
}

@end
