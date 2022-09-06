//
//  JHConfirmDealOrderView.m
//  TTjianbao
//
//  Created by yaoyao on 2019/12/4.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHConfirmDealOrderView.h"
#import "JHPopStoneOrderItem.h"
#import "JHOrderConfirmViewController.h"
#import "OrderMode.h"

#import "TTjianbaoBussiness.h"
@interface JHConfirmDealOrderView ()
@property (nonatomic, strong)JHPopStoneOrderItem *stoneOrderItem;
@property (nonatomic, strong)JHPreTitleLabel *priceLabel;
@property (nonatomic, strong)JHPreTitleLabel *codeLabel;

@property (nonatomic, strong)JHPreTitleLabel *metaLabel;//材料
@property (nonatomic, strong)JHPreTitleLabel *handLabel;//手工
@property (nonatomic, strong)JHPreTitleLabel *desLabel;//描述

@end
@implementation JHConfirmDealOrderView
- (void)makeUI {
    [super makeUI];
    self.titleLabel.text = @"加工单";
    [self.okBtn setTitle:@"去支付" forState:UIControlStateNormal];
    [self style1];
    
    self.codeLabel = [JHUIFactory createJHLabelWithTitle:@"" titleColor:kColor333 font:[UIFont fontWithName:kFontNormal size:12] textAlignment:NSTextAlignmentLeft preTitle:@"订单号："];
    [self.backView addSubview:self.codeLabel];
    
    self.stoneOrderItem = [[JHPopStoneOrderItem alloc] init];
    [self.backView addSubview:self.stoneOrderItem];
    
    self.metaLabel = [JHUIFactory createJHLabelWithTitle:@"" titleColor:kColor333 font:[UIFont fontWithName:kFontMedium size:13] textAlignment:NSTextAlignmentLeft preTitle:@"材料费 "];
    [self.backView addSubview:self.metaLabel];
    
    self.handLabel = [JHUIFactory createJHLabelWithTitle:@"" titleColor:kColor333 font:[UIFont fontWithName:kFontMedium size:13] textAlignment:NSTextAlignmentLeft preTitle:@"手工费 "];
    [self.backView addSubview:self.handLabel];
    
    self.priceLabel = [JHUIFactory createJHLabelWithTitle:@"" titleColor:kColor333 font:[UIFont fontWithName:kFontMedium size:13] textAlignment:NSTextAlignmentLeft preTitle:@"合计 "];
    [self.backView addSubview:self.priceLabel];
    
    
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(10);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.height.offset(34);
    }];
    
    [self.stoneOrderItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.backView);
        make.top.equalTo(self.codeLabel.mas_bottom);
    }];
    
    [self.metaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stoneOrderItem.mas_bottom).offset(5);
        make.leading.offset(10);
    }];
    
    [self.handLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.metaLabel.mas_bottom).offset(10);
        make.leading.equalTo(self.metaLabel);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.handLabel.mas_bottom).offset(10);
        make.leading.equalTo(self.metaLabel);
    }];
    
    self.desLabel =  [JHUIFactory createJHLabelWithTitle:@"" titleColor:kColor333 font:[UIFont fontWithName:kFontNormal size:13] textAlignment:NSTextAlignmentLeft preTitle:@"加工说明 "];
    [self.backView addSubview:self.desLabel];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLabel.mas_bottom).offset(10);
        make.leading.equalTo(self.metaLabel);
        make.trailing.equalTo(self.backView).offset(-10);
        make.bottom.equalTo(self.okBtn.mas_top).offset(-20);
    }];
    
    
    [self.priceLabel setJHAttributedText:@"￥1234" font:[UIFont fontWithName:kFontBoldDIN size:15] color:HEXCOLOR(0xFC4200)];
    
    
}

- (void)setModel:(OrderMode *)model {
    [super setModel:model];
    [self.priceLabel setJHAttributedText:[NSString stringWithFormat:@"￥%@",model.orderPrice] font:[UIFont fontWithName:kFontBoldDIN size:15] color:HEXCOLOR(0xFC4200)];
    self.codeLabel.text = model.orderCode;
    self.metaLabel.text = [NSString stringWithFormat:@"¥%@",model.materialCost];
       self.handLabel.text = [NSString stringWithFormat:@"¥%@",model.manualCost];
       self.desLabel.text = [NSString stringWithFormat:@"%@",model.processingDes];

    self.stoneOrderItem.titleLabel.text = model.parentOrder.goodsTitle;
    self.stoneOrderItem.codeLabel.text = @"";
    [self.stoneOrderItem.coverImg jhSetImageWithURL:[NSURL URLWithString:model.parentOrder.goodsUrl] placeholder:kDefaultCoverImage];
    self.stoneOrderItem.priceLabel.text = model.parentOrder.originOrderPrice;
}

- (void)okAction {
    JHOrderConfirmViewController *vc = [[JHOrderConfirmViewController alloc] init];
    OrderMode *order = self.model;
    vc.orderId = order.orderId;
    vc.fromString = JHConfirmFromCommonWorkOrder;
    [JHRootController.homeTabController.navigationController pushViewController:vc animated:YES];
    [self hiddenAlert];
}

@end
