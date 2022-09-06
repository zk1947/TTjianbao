//
//  JHBePushStoneSaledView.m
//  TTjianbao
//
//  Created by yaoyao on 2019/11/28.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBePushStoneSaledView.h"
#import "JHPopStoneOrderItem.h"
#import "JHOfferPriceViewController.h"


@interface JHBePushStoneSaledView ()
@property (nonatomic, strong)JHPopStoneOrderItem *stoneOrderItem;
@property (nonatomic, strong)JHPreTitleLabel *priceLabel;
@property (nonatomic, strong)UIImageView *statusImg;


@end

@implementation JHBePushStoneSaledView

- (void)makeUI {
    [super makeUI];
    [self.backView addSubview:self.stoneOrderItem];
    [self.backView addSubview:self.statusImg];
    
    [self style1];
    

}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.stoneOrderItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.backView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    
    [self.statusImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.backView);
        make.bottom.equalTo(self.stoneOrderItem).offset(-10);
    }];
    


    //个人(原石)转售
    if([self.model stoneResellMsgType])
    {
        [self.stoneOrderItem.codeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.stoneOrderItem.coverImg.mas_bottom).offset(5);
            make.leading.equalTo(self.stoneOrderItem.coverImg);
            make.height.offset(0);
        }];
    }
    else
    {
        [self.stoneOrderItem.codeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.stoneOrderItem.coverImg.mas_bottom).offset(5);
            make.leading.equalTo(self.stoneOrderItem.coverImg);
            make.height.offset(18);
        }];
    }
}


- (JHPopStoneOrderItem *)stoneOrderItem {
    if (!_stoneOrderItem) {
        _stoneOrderItem = [[JHPopStoneOrderItem alloc] initVer];
    }
    return _stoneOrderItem;
}

- (JHPreTitleLabel *)priceLabel {
    if (!_priceLabel) {
        _priceLabel = [JHUIFactory createJHLabelWithTitle:@"" titleColor:kColor333 font:[UIFont fontWithName:kFontNormal size:13] textAlignment:NSTextAlignmentLeft preTitle:@"成交价："];

    }
    
    return _priceLabel;

}

- (UIImageView *)statusImg {
    if (!_statusImg) {
        _statusImg = [JHUIFactory createImageView];
    }
    return _statusImg;
}


- (void)okAction {
    [super okAction];
    if (self.tag == 3) {//重新出价
        JHOfferPriceViewController *vc = [[JHOfferPriceViewController alloc] init];
        vc.resaleFlag = [self.model stoneResellMsgType];
        vc.stoneRestoreId = ((JHStoneMessageModel *)self.model).stoneRestoreId;
                       
        [JHRootController.homeTabController.navigationController pushViewController:vc animated:YES];
    }
}

- (void)anchorRecvSaled {
    self.tag = 1;
    self.stoneOrderItem.model = self.model;
   
    JHStoneMessageModel *selfModle = self.model;
    self.titleLabel.text = @"宝友购买";
    self.statusImg.image = [UIImage imageNamed:@"icon_stone_saled"];
    [self.okBtn setTitle:@"我知道了" forState:UIControlStateNormal];
    JHCustomLine *line = [JHUIFactory createLine];
    [self.backView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stoneOrderItem.mas_bottom);
        make.height.equalTo(@1);
        make.trailing.equalTo(self.backView);
        make.leading.equalTo(self.backView).offset(10);
    }];
    
    UILabel *buyTitle = [JHUIFactory createLabelWithTitle:@"买家" titleColor:kColor333 font:[UIFont fontWithName:kFontNormal size:13] textAlignment:NSTextAlignmentLeft];
    [self.backView addSubview:buyTitle];
    
    [buyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self.backView).offset(10);
        make.top.equalTo(self.stoneOrderItem.mas_bottom).offset(5);
        make.height.equalTo(@20);
    }];
    
    UIImageView *buyIcon = [JHUIFactory createCircleImageViewWithRadius:6];
    [self.backView addSubview:buyIcon];
    [buyIcon jhSetImageWithURL:[NSURL URLWithString:selfModle.purchaseCustomerImg] placeholder:kDefaultAvatarImage];
    
    
    
    [buyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(buyTitle.mas_trailing);
        make.centerY.equalTo(buyTitle);
        make.height.width.equalTo(@12);
        
    }];
    
    
    UILabel *buyerName = [JHUIFactory createLabelWithTitle:selfModle.purchaseCustomerName titleColor:kColor333 font:[UIFont fontWithName:kFontNormal size:13] textAlignment:NSTextAlignmentLeft];
    [self.backView addSubview:buyerName];
    
    [buyerName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(buyIcon.mas_trailing).offset(3);
        make.centerY.equalTo(buyIcon);
    }];
    
    [self.backView addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(buyTitle);
        make.top.equalTo(buyTitle.mas_bottom).offset(5);
        make.bottom.equalTo(self.okBtn.mas_top).offset(-10);
    }];

    [self.priceLabel setJHAttributedText:[NSString stringWithFormat:@"￥%@",selfModle.dealPrice] font:[UIFont fontWithName:kFontBoldDIN size:18] color:HEXCOLOR(0xFC4200)];

    [self.stoneOrderItem.priceLabel setJHAttributedText:[NSString stringWithFormat:@"￥%@",selfModle.salePrice] font:[UIFont fontWithName:kFontBoldDIN size:15] color:HEXCOLOR(0xFC4200)];

    
}

- (void)sellerRecvSaled {

    self.tag = 2;
    self.stoneOrderItem.model = self.model;
    JHStoneMessageModel *selfModle = self.model;

    self.titleLabel.text = @"恭喜你，你的原石已售出";
    self.statusImg.image = [UIImage imageNamed:@"icon_stone_saled"];
    self.stoneOrderItem.shelveLabel.hidden = YES;
    [self.okBtn setTitle:@"我知道了" forState:UIControlStateNormal];
    
    [self.okBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(40));
          make.leading.equalTo(self.backView).offset(36);
          make.trailing.equalTo(self.backView).offset(-36);
          make.bottom.equalTo(self.backView).offset(-40);
        make.top.equalTo(self.stoneOrderItem.mas_bottom).offset(20);
    }];
    
    UILabel *des = [JHUIFactory createLabelWithTitle:selfModle.tips titleColor:kColor999 font:[UIFont fontWithName:kFontNormal size:12] textAlignment:NSTextAlignmentCenter];
    //@"3天后系统会自动结算到你的原石零钱"

    [self.backView addSubview:des];
    
    [des mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.okBtn.mas_bottom);
        make.centerX.equalTo(self.backView);
        make.bottom.equalTo(self.backView);
        
    }];

    [self.stoneOrderItem.priceLabel setJHAttributedText:[NSString stringWithFormat:@"￥%@",selfModle.salePrice] font:[UIFont fontWithName:kFontBoldDIN size:18] color:HEXCOLOR(0xFC4200)];
}

- (void)sellerRejectPrice {
    self.tag = 3;
    self.stoneOrderItem.model = self.model;
    JHStoneMessageModel *selfModle = self.model;
    
    self.titleLabel.text = @"很遗憾，你的出价已被拒绝";
    self.statusImg.image = [UIImage imageNamed:@"icon_stone_bereject"];
    [self.okBtn setTitle:@"重新出价" forState:UIControlStateNormal];
    JHCustomLine *line = [JHUIFactory createLine];
    [self.backView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stoneOrderItem.mas_bottom);
        make.height.equalTo(@1);
        make.trailing.equalTo(self.backView);
        make.leading.equalTo(self.backView).offset(10);
    }];
    
    UIImageView *icon = [JHUIFactory createCircleImageViewWithRadius:0];
    icon.image = [UIImage imageNamed:@"icon_stone_info"];
       [self.backView addSubview:icon];
       
       
       [icon mas_makeConstraints:^(MASConstraintMaker *make) {
           make.leading.equalTo(self.backView).offset(10);
           make.height.width.equalTo(@10);
           
       }];
       
    NSString *string = [NSString stringWithFormat:@"我的出价%@被拒绝",selfModle.offerPrice];
       UILabel *des = [JHUIFactory createLabelWithTitle:string titleColor:kColor333 font:[UIFont fontWithName:kFontNormal size:13] textAlignment:NSTextAlignmentLeft];
       [self.backView addSubview:des];
       
       [des mas_makeConstraints:^(MASConstraintMaker *make) {
           make.leading.equalTo(icon.mas_trailing).offset(3);
           make.centerY.equalTo(icon);
           make.bottom.equalTo(self.okBtn.mas_top).offset(-10);
           make.height.equalTo(@40);
           make.top.equalTo(line.mas_bottom).offset(10);
       }];
    

    [self.priceLabel setJHAttributedText:[NSString stringWithFormat:@"￥%@",selfModle.offerPrice] font:[UIFont fontWithName:kFontBoldDIN size:18] color:HEXCOLOR(0xFC4200)];

}

- (void)setModel:(id)model {
    [super setModel:model];
//    self.stoneOrderItem.model = self.model;

}

@end
