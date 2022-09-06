//
//  JHBePushPriceView.m
//  TTjianbao
//
//  Created by yaoyao on 2019/11/26.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBePushPriceView.h"
#import "JHPopStoneOrderItem.h"
#import "JHPreTitleLabel.h"
#import "JHGoodResaleListModel.h"
#import "JHOrderConfirmViewController.h"


#import "CommAlertView.h"
#import "TTjianbaoBussiness.h"
@interface JHBePushPriceView ()

@property (nonatomic, strong)JHPopStoneOrderItem *stoneOrderItem;
@property (nonatomic, strong)JHPreTitleLabel *priceLabel;
@end

@implementation JHBePushPriceView

- (void)makeUI {
    [super makeUI];
    self.titleLabel.text = @"买家出价";
    self.priceLabel = [JHUIFactory createJHLabelWithTitle:@"" titleColor:kColor333 font:[UIFont fontWithName:kFontMedium size:13] textAlignment:NSTextAlignmentLeft preTitle:@"出价："];
    
    [self.backView addSubview:self.stoneOrderItem];
    [self.backView addSubview:self.priceLabel];
        
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.stoneOrderItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.backView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    
}


- (JHPopStoneOrderItem *)stoneOrderItem {
    if (!_stoneOrderItem) {
        _stoneOrderItem = [[JHPopStoneOrderItem alloc] init];
    }
    return _stoneOrderItem;
}



- (void)okAction {
    JHStoneMessageModel *selfModel = self.model;
    
    if (self.isAgree) {//去支付:不需要区分个人转售        
        JHOrderConfirmViewController *vc = [[JHOrderConfirmViewController alloc] init];
         vc.orderId = selfModel.orderId;
         vc.fromString=JHConfirmFromSellerAgreePrice;
        [JHRootController.homeTabController.navigationController pushViewController:vc animated:YES];
        [self hiddenAlert];

    } else {//同意出价
        JHGoodOrderSaveReqModel *reqm = [JHGoodOrderSaveReqModel new];
        reqm.stoneRestoreOfferId = selfModel.stoneRestoreOfferId;
        reqm.stoneId = selfModel.stoneRestoreId;
        reqm.orderPrice = selfModel.offerPrice;
        //个人(原石)转售
        if([self.model stoneResellMsgType])
        {
            //resaleOrder-个人转售订单, resaleIntentionOrder-个人转售意向金订单
            reqm.orderCategory = @"resaleOrder";
            reqm.channelCategory = @"";
        }
        else
        {
            reqm.orderCategory = @"restoreOrder";
            reqm.channelCategory = JHRoomTypeNameRestoreStone;
        }

        NSString *text = [NSString stringWithFormat: @"是否确认接受此出价¥%@？", selfModel.offerPrice];
        if ([selfModel.offerPrice integerValue]<[selfModel.salePrice integerValue]) {
            text = @"此价格低于一口价！是否接受按此价格成交";
        }
        @weakify(self);
        CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"" andDesc:text cancleBtnTitle:@"取消" sureBtnTitle:@"确定"];
        alert.handle = ^{
            [JHMainLiveSmartModel request:reqm response:^(id respData, NSString *errorMsg) {
                @strongify(self);
                if(errorMsg) {
                    [SVProgressHUD showErrorWithStatus:errorMsg];
                    
                } else {
                    [SVProgressHUD showSuccessWithStatus:@"接受成功"];
                }
                [self hiddenAlert];
                
            }];
        };
        [[UIApplication sharedApplication].keyWindow addSubview:alert];

        
        
//        JHUserAcceptPriceReqModel *model = [JHUserAcceptPriceReqModel new];
//        model.stoneRestoreOfferId = selfModel.stoneRestoreOfferId;
//        [SVProgressHUD show];
//        [JHMainLiveSmartModel request:model response:^(id respData, NSString *errorMsg) {
//            [SVProgressHUD dismiss];
//            if (errorMsg) {
//                [SVProgressHUD showErrorWithStatus:errorMsg];
//            }else {
//                [SVProgressHUD showSuccessWithStatus:@"成功"];
//                [super okAction];
//
//            }
//        }];
        
    }
}


- (void)cancelAction {//拒绝出价
    JHStoneMessageModel *selfModel = self.model;
    
    JHUserRejectPriceReqModel *model = [JHUserRejectPriceReqModel new];
    model.stoneRestoreOfferId = selfModel.stoneRestoreOfferId;
    //个人(原石)转售
    if([self.model stoneResellMsgType])
    {
        model.resaleFlag = 1;
    }

    [SVProgressHUD show];
    [JHMainLiveSmartModel request:model response:^(id respData, NSString *errorMsg) {
        [SVProgressHUD dismiss];
        if (errorMsg) {
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }else {
            [SVProgressHUD showSuccessWithStatus:@"成功"];
            [self hiddenAlert];

        }
    }];
}


- (void)showAlert {
    [self setAgreeStyle:self.isAgree];
    [super showAlert];
}

- (void)setAgreeStyle:(BOOL)isAgree {
    self.stoneOrderItem.model = self.model;
    JHStoneMessageModel *selfModle = self.model;
    [self.priceLabel setJHAttributedText:[NSString stringWithFormat:@"￥%@",selfModle.offerPrice] font:[UIFont fontWithName:kFontBoldDIN size:18] color:HEXCOLOR(0xFC4200)];
    if (isAgree) {
        self.titleLabel.text = @"卖家同意出价";
        [self style1];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.stoneOrderItem.mas_bottom);
            make.centerX.equalTo(self.backView);
            make.bottom.equalTo(self.okBtn.mas_top).offset(-40);
        }];
        
        [self.okBtn setTitle:@"去支付尾款" forState:UIControlStateNormal];
        
        UILabel *des = [JHUIFactory createLabelWithTitle:@"已被接受" titleColor:kColor999 font:[UIFont fontWithName:kFontMedium size:10] textAlignment:NSTextAlignmentCenter];
        
        [self.backView addSubview:des];
        
        [des mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.priceLabel.mas_bottom).offset(8);
            make.centerX.equalTo(self.backView);
            
        }];
        
    }else {
        [self style2];
        
        self.stoneOrderItem.priceLabel.preTitle = @"寄售价格：";
        //个人(原石)转售
        if([self.model stoneResellMsgType])
        {
            self.stoneOrderItem.priceLabel.preTitle = @"转售价格：";
        }
        self.stoneOrderItem.priceLabel.text = [NSString stringWithFormat:@"%@",selfModle.salePrice];
        
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.stoneOrderItem.mas_bottom).offset(10);
            make.centerX.equalTo(self.backView);
            make.bottom.equalTo(self.okBtn.mas_top).offset(-15);
        }];
        
        
        [self.okBtn setTitle:@"接受" forState:UIControlStateNormal];
        [self.cancelBtn setTitle:@"拒绝" forState:UIControlStateNormal];
    }
    
    //个人(原石)转售
    if([self.model stoneResellMsgType])
    {
        [self.stoneOrderItem.codeLabel setHidden:YES];
        [self.stoneOrderItem.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.stoneOrderItem.coverImg);
            make.leading.equalTo(self.stoneOrderItem.coverImg.mas_trailing).offset(10);
            make.trailing.equalTo(self.stoneOrderItem).offset(-10);
        }];
    }
}


@end
