//
//  JHStoneDealPaperView.m
//  TTjianbao
//
//  Created by yaoyao on 2019/12/10.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStoneDealPaperView.h"
#import "JHPopStoneOrderItem.h"
#import "JHGoodResaleListModel.h"
#import "ChannelMode.h"


#define kDefaultDesc @"加工描述：为避免纠纷，请描述用户的加工需求。"

@interface JHStoneDealPaperView ()<UITextViewDelegate>
@property (nonatomic, strong)JHPopStoneOrderItem *stoneOrderItem;
@property (nonatomic, strong)JHPreTitleLabel *codeLabel;
@property (nonatomic, strong) JHTitleTextItemView *metaText;
@property (nonatomic, strong) JHTitleTextItemView *handText;
@property (nonatomic, strong)JHPreTitleLabel *priceLabel;
@property (nonatomic, strong) UITextView* descTextView;
@property (nonatomic, assign) double allPrice;


@end
@implementation JHStoneDealPaperView

- (void)makeUI {
    [super makeUI];
    self.titleLabel.text = @"加工单";
    [self.okBtn setTitle:@"发送订单" forState:UIControlStateNormal];
    [self style1];
    
    self.codeLabel = [JHUIFactory createJHLabelWithTitle:@"" titleColor:kColor333 font:[UIFont fontWithName:kFontNormal size:12] textAlignment:NSTextAlignmentLeft preTitle:@"订单号："];
    [self.backView addSubview:self.codeLabel];
    
    self.stoneOrderItem = [[JHPopStoneOrderItem alloc] init];
    [self.backView addSubview:self.stoneOrderItem];
    
    self.metaText = [[JHTitleTextItemView alloc] initWithTitle:@"材料费：" textPlace:@"￥请输入价格" isEdit:YES isShowLine:YES];
    self.metaText.isCarryTwoDote = YES;
    [self.backView addSubview:self.metaText];
    
    self.handText = [[JHTitleTextItemView alloc] initWithTitle:@"手工费：" textPlace:@"￥请输入价格" isEdit:YES isShowLine:YES];
    self.handText.isCarryTwoDote = YES;
    [self.backView addSubview:self.handText];
    
     [self.handText.textField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.metaText.textField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];

    
    self.priceLabel = [JHUIFactory createJHLabelWithTitle:@"" titleColor:kColor333 font:[UIFont fontWithName:kFontMedium size:13] textAlignment:NSTextAlignmentLeft preTitle:@"合计 "];
    [self.backView addSubview:self.priceLabel];
    
    //描述
    UITextView* descLabel = [[UITextView alloc] init];
    descLabel.layer.borderColor = HEXCOLOR(0xf7f7f7).CGColor;
    descLabel.layer.borderWidth = 1;
    descLabel.layer.cornerRadius = 2;
    descLabel.layer.masksToBounds = YES;
    descLabel.textColor = HEXCOLOR(0xEEEEEE);
    descLabel.font = [UIFont fontWithName:kFontMedium size:13];
    descLabel.textAlignment = NSTextAlignmentLeft;
    descLabel.text = kDefaultDesc;
    //    descLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.descTextView = descLabel;
    descLabel.delegate = self;
    [self.backView addSubview:descLabel];
    
    [self.codeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(10);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.height.offset(34);
    }];
    
    [self.stoneOrderItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.backView);
        make.top.equalTo(self.codeLabel.mas_bottom);
    }];
    
    [self.metaText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stoneOrderItem.mas_bottom);
        make.leading.offset(0);
        make.height.offset(30);
        make.trailing.offset(-10);
        
    }];
    
    [self.handText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.metaText.mas_bottom).offset(5);
        make.leading.trailing.equalTo(self.metaText);
        make.height.offset(30);

    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.handText.mas_bottom).offset(10);
        make.leading.equalTo(self.handText).offset(10);
    }];
    
    
    [self.descTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceLabel.mas_bottom).offset(10);
        make.leading.trailing.equalTo(self.metaText).offset(10);
        make.bottom.equalTo(self.okBtn.mas_top).offset(-20);
        make.height.equalTo(@(50));
    }];
    
}

- (void)setModel:(JHLastSaleGoodsModel *)model {
    [super setModel:model];
    self.stoneOrderItem.model = model;
    self.codeLabel.text = model.orderCode;
    
}


- (void)changedTextField:(UITextField *)textField {
    if (self.priceLabel) {
        double allPrice = [self.metaText.textField.text doubleValue]+[self.handText.textField.text doubleValue];
        self.allPrice = allPrice;
        [self.priceLabel setJHAttributedText:[NSString stringWithFormat:@"￥%.2f", allPrice] font:[UIFont fontWithName:kFontBoldDIN size:15] color:HEXCOLOR(0xFC4200)];

    }
}

#pragma mark -
- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:kDefaultDesc]) {
        textView.text = @"";
        textView.textColor = HEXCOLOR(0x333333);
    }

}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        textView.text = kDefaultDesc;
        textView.textColor = HEXCOLOR(0xeeeeee);
    }
}

#pragma mark -


- (void)okAction {
    
    if (self.allPrice == 0.0) {
        [self makeToast:@"加工费需大于0元" duration:1.0 position:CSToastPositionCenter];
        return;
    }

    JHLastSaleGoodsModel *selfModel = self.model;
    JHGoodOrderSaveReqModel *model = [JHGoodOrderSaveReqModel new];
    
    model.channelCategory = self.channelCategory;
    model.manualCost = self.handText.textField.text;
    model.materialCost = self.metaText.textField.text;
    model.processingDes = [self.descTextView.text isEqualToString:kDefaultDesc]?@"":self.descTextView.text;
    model.orderPrice = @(self.allPrice).stringValue;
    model.stoneId = [self.channelCategory isEqualToString:JHRoomTypeNameRoughStone]?selfModel.stoneId:selfModel.stoneRestoreId;
    model.onlyGoodsId = selfModel.goodsCode;
    model.orderCategory = [self.channelCategory isEqualToString:JHRoomTypeNameRoughStone]?@"processingGoods":@"restoreProcessingGoods";
        
    
    [SVProgressHUD show];
    [JHMainLiveSmartModel request:model response:^(id respData, NSString *errorMsg) {
        [SVProgressHUD dismiss];
        if (errorMsg) {
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }else {
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
            [self hiddenAlert];
        }
    }];
    
}

@end
