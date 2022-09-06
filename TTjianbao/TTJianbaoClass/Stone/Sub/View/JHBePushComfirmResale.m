//
//  JHBePushComfirmResale.m
//  TTjianbao
//
//  Created by yaoyao on 2019/11/26.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHBePushComfirmResale.h"
#import "JHPopStoneOrderItem.h"
#import "JHPreTitleLabel.h"
#import "JHMainLiveSmartModel.h"
#import "JHStoneMessageModel.h"
#import "JHWebViewController.h"

#import "CommAlertView.h"
@interface JHBePushComfirmResale ()
@property (nonatomic, strong)JHPopStoneOrderItem *stoneOrderItem;
@property (nonatomic, strong)JHPreTitleLabel *priceLabel;
@property (nonatomic, strong)UIButton *checkBtn;

@end

@implementation JHBePushComfirmResale

- (void)makeUI {
    [super makeUI];
    self.titleLabel.text = @"确认寄售";
    self.priceLabel = [JHUIFactory createJHLabelWithTitle:@"" titleColor:kColor333 font:[UIFont fontWithName:kFontMedium size:13] textAlignment:NSTextAlignmentLeft preTitle:@"寄售价格："];
    
    [self.backView addSubview:self.stoneOrderItem];
    [self.backView addSubview:self.priceLabel];
    
    [self style2];
    
    
    [self.okBtn setTitle:@"确认寄售" forState:UIControlStateNormal];
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    
    
    UIControl *backControl = [UIControl new];
    [backControl addTarget:self action:@selector(protocolAction) forControlEvents:UIControlEventTouchUpInside];
    [self.backView addSubview:backControl];
    
    JHPreTitleLabel *label = [JHUIFactory createJHLabelWithTitle:@"" titleColor:kColor666 font:[UIFont fontWithName:kFontMedium size:10] textAlignment:NSTextAlignmentLeft preTitle:@"我已同意"];
    [label setJHAttributedText:@"《原石回血交易协议》" font:[UIFont fontWithName:kFontMedium size:10] color:HEXCOLOR(0x408FFE)];
    label.userInteractionEnabled = NO;
    [backControl addSubview:label];
    
    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkBtn setImage:[UIImage imageNamed:@"icon_stone_right"] forState:UIControlStateNormal];
    [checkBtn setImage:[UIImage imageNamed:@"icon_stone_right_no"] forState:UIControlStateSelected];
    [checkBtn addTarget:self action:@selector(checkAction:) forControlEvents:UIControlEventTouchUpInside];
    self.checkBtn = checkBtn;
//    UIImageView *tipImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_stone_right"]];
    [backControl addSubview:checkBtn];

    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.centerX.equalTo(backControl);
    }];
    
    [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(label.mas_leading);
        make.centerY.equalTo(label);
        make.width.height.equalTo(@30);
    }];
    [backControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.height.offset(20);
        make.leading.trailing.equalTo(self.backView);
    }];
    
    
    [self.okBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.backView).offset(-25);
        make.height.equalTo(@(40));
        make.bottom.equalTo(backControl.mas_top).offset(-17);
        
        
    }];
    UILabel *des = [JHUIFactory createLabelWithTitle:@"作为卖家承担相应的责任和风险不能\n发布虚假信息和商品" titleColor:kColor999 font:[UIFont fontWithName:kFontMedium size:10] textAlignment:NSTextAlignmentCenter];
    des.numberOfLines = 0;
    des.lineBreakMode = NSLineBreakByCharWrapping;
    [self.backView addSubview:des];
    
    [des mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backControl.mas_bottom).offset(8);
        make.bottom.equalTo(self.backView.mas_bottom).offset(-15);
        make.centerX.equalTo(self.backView);
        
    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.stoneOrderItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.backView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stoneOrderItem.mas_bottom).offset(10);
        make.centerX.equalTo(self.backView);
        make.bottom.equalTo(self.okBtn.mas_top).offset(-15);
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
  
    if (self.checkBtn.selected) {
        [self makeToast:@"请同意《原石回血交易协议》" duration:1 position:CSToastPositionCenter];
        return;
    }
    if (self.isEdit) {
        [JHMainLiveUpdatePriceReqModel requestWithStoneId:selfModel.stoneRestoreId price:selfModel.salePrice flag:1 finish:^(NSString *errorMsg) {
            if(errorMsg){
                [SVProgressHUD showErrorWithStatus:errorMsg];
            } else {
                [SVProgressHUD showSuccessWithStatus:@"修改成功"];
                [self hiddenAlert];
            }
            
            
        }];
    }else {
        NSString *msg = [NSString stringWithFormat:@"请确认是否按此价格 ¥%@ 寄售",selfModel.salePrice];
        CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"提示" andDesc:msg cancleBtnTitle:@"取消" sureBtnTitle:@"确定"];
        [[UIApplication sharedApplication].keyWindow addSubview:alert];
        JH_WEAK(self)
        alert.handle = ^{
            JH_STRONG(self)
            [self confirm];
        };

    }
    
}

- (void)confirm {
    JHStoneMessageModel *selfModel = self.model;

    [SVProgressHUD show];
           JHUserConfirmConsignReqModel *model = [JHUserConfirmConsignReqModel new];
             model.stoneId = selfModel.stoneId;
             model.channelCategory = selfModel.channelCategory;
             
           [JHMainLiveSmartModel request:model response:^(id respData, NSString *errorMsg) {
               [SVProgressHUD dismiss];
               if (errorMsg) {
                   [SVProgressHUD showErrorWithStatus:errorMsg];
               }else {
                   [SVProgressHUD showSuccessWithStatus:@"寄售成功"];
                   [self hiddenAlert];
                   
               }
           }];
           
       
       
       if (self.actionBlock) {
           self.actionBlock(nil, RequestTypeConfirmResale);
       }
}

- (void)cancelAction {
    
    if (self.isEdit) {
        [super hiddenAlert];
    }else {
        [super hiddenAlert];
        return;
        JHStoneMessageModel *selfModel = self.model;
        JHUserRejectConsignReqModel *model = [JHUserRejectConsignReqModel new];
        model.stoneId = selfModel.stoneId;
        model.channelCategory = selfModel.channelCategory;
        [SVProgressHUD show];
        [JHMainLiveSmartModel request:model response:^(id respData, NSString *errorMsg) {
            [SVProgressHUD dismiss];
            if (errorMsg) {
                [SVProgressHUD showErrorWithStatus:errorMsg];
            }else {
                [SVProgressHUD showSuccessWithStatus:@"取消成功"];
                [self hiddenAlert];
            }
        }];
    }
    
    
    if (self.actionBlock) {
        self.actionBlock(nil, RequestTypeCancelResale);
    }
}

- (void)checkAction:(UIButton *)btn {
    btn.selected = !btn.selected;
}

- (void)protocolAction {
    
    JHWebViewController *web = [[JHWebViewController alloc] init];
    web.urlString = StoneRestoreProtocolURL;
    [JHRootController.homeTabController.navigationController pushViewController:web animated:YES];
    if (self.actionBlock) {
        self.actionBlock(nil, RequestTypeProtocol);
    }
}

- (void)setModel:(JHStoneMessageModel *)model {
    [super setModel:model];
    self.stoneOrderItem.model = self.model;
    [self.priceLabel setJHAttributedText:[NSString stringWithFormat:@"￥%@", model.salePrice] font:[UIFont fontWithName:kFontBoldDIN size:18] color:HEXCOLOR(0xFC4200)];
    self.stoneOrderItem.priceLabel.text = [NSString stringWithFormat:@"%@",model.purchasePrice];

}

- (void)showAlert {
    if (self.isEdit) {
        [self.okBtn setTitle:@"确认修改" forState:UIControlStateNormal];
        [self.cancelBtn setTitle:@"取消修改" forState:UIControlStateNormal];
    }
    [super showAlert];
}

- (void)showAlertWithView:(UIView *)view {
    if (self.isEdit) {
        [self.okBtn setTitle:@"确认修改" forState:UIControlStateNormal];
        [self.cancelBtn setTitle:@"取消修改" forState:UIControlStateNormal];
    }
    [super showAlertWithView:view];
}

@end

