//
//  JHPopForSaleView.m
//  TTjianbao
//
//  Created by mac on 2019/11/23.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHPopForSaleView.h"
#import "JHPopStoneOrderItem.h"
#import "JHTitleTextItemView.h"
#import "JHMainLiveSmartModel.h"
#import "JHLastSaleGoodsModel.h"
#import "JHPickerView.h"
#import "JHKeyValueModel.h"

@interface JHPopForSaleView ()<UITextFieldDelegate, STPickerSingleDelegate>
@property (nonatomic, strong)JHPopStoneOrderItem *stoneOrderItem;
@property (nonatomic, strong)JHTitleTextItemView *dealStyle;
@property (nonatomic, strong)JHTitleTextItemView *priceTitleText;
@property (nonatomic, strong) JHPickerView *picker;
@property (nonatomic, strong) NSMutableArray *pickerArray;

@end

@implementation JHPopForSaleView

- (void)makeUI {
    [super makeUI];
    self.titleLabel.text = @"寄售到回血直播间";
    [self.backView addSubview:self.stoneOrderItem];
    [self.backView addSubview:self.priceTitleText];
    
    [self.backView addSubview:self.dealStyle];
    [self style1];
    
    [self.okBtn setTitle:@"确认" forState:UIControlStateNormal];
    JHCustomLine *line = [JHCustomLine new];
    [self.backView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.equalTo(self.backView);
        make.bottom.equalTo(self.priceTitleText);
        make.leading.equalTo(self.backView).offset(10);
        make.height.offset(1);
    }];

    self.picker = [[JHPickerView alloc] init];
    self.picker.tag = 1;
    self.picker.widthPickerComponent = 300;
    self.picker.delegate = self;
    
    [self requestProsesStyle:NO];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.stoneOrderItem mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.backView);
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
    }];
    
    [self.priceTitleText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.backView);
        make.top.equalTo(self.stoneOrderItem.mas_bottom);
        make.height.offset(48);
    }];
    
    [self.dealStyle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.trailing.equalTo(self.backView);
        make.top.equalTo(self.priceTitleText.mas_bottom);
        make.height.offset(48);
        make.bottom.equalTo(self.okBtn.mas_top).offset(-20);
    }];
    
    
}


- (JHPopStoneOrderItem *)stoneOrderItem {
    if (!_stoneOrderItem) {
        _stoneOrderItem = [[JHPopStoneOrderItem alloc] init];
    }
    return _stoneOrderItem;
}
- (JHTitleTextItemView *)priceTitleText {
    if (!_priceTitleText) {
        _priceTitleText = [[JHTitleTextItemView alloc] initWithTitle:@"寄售价格" textPlace:@"请输入寄售价格" isEdit:YES isShowLine:NO];
        _priceTitleText.textField.textAlignment = NSTextAlignmentRight;
        _priceTitleText.isCarryTwoDote = YES;

    }
    
    return _priceTitleText;
}

- (JHTitleTextItemView *)dealStyle {
    if (!_dealStyle) {
        _dealStyle = [[JHTitleTextItemView alloc] initWithTitle:@"加工方式" textPlace:@"请选择加工方式" isEdit:NO isShowLine:NO];
        _dealStyle.textField.textAlignment = NSTextAlignmentRight;
        [_dealStyle openClickActionRightArrowWithTarget:self action:@selector(showPicker:)];
    }
    
    return _dealStyle;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //新输入的
    if (string.length == 0) {
        return YES;
    }
    
    if (textField == _priceTitleText.textField) {
        
        NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string];

        return [self.priceTitleText isValid:checkStr];
    }
    
    return YES;
    
}

- (void)okAction {

    if (self.priceTitleText.textField.text.length) {
        if (self.dealStyle.textField.text.length) {
            [self request];
        } else {
            [self makeToast:@"请选择加工方式" duration:1 position:CSToastPositionCenter];
        }
    }else {
        [self makeToast:@"请输入价格" duration:1 position:CSToastPositionCenter];
    }
}

- (void)request {
    JHLastSaleGoodsModel *model = self.model;
    JHMainLiveConsignReqModel* consign = [JHMainLiveConsignReqModel new];
    consign.salePrice = self.priceTitleText.textField.text;
    consign.processMode = self.dealStyle.tag;
    consign.channelCategory = self.channelCategory;
    consign.stoneId = model.stoneRestoreId?:model.stoneId;
    [SVProgressHUD show];
    [JHMainLiveSmartModel request:consign response:^(id respData, NSString *errorMsg) {
        [SVProgressHUD dismiss];
        if (errorMsg) {
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }else {
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
            [self hiddenAlert];
        }
    }];
    
}


- (void)setModel:(JHLastSaleGoodsModel *)model {
    [super setModel:model];
    self.stoneOrderItem.model = model;
    self.stoneOrderItem.priceLabel.text = @"";
    self.stoneOrderItem.priceLabel.hidden = YES;
    self.stoneOrderItem.codeLabel.hidden = YES;
    
}

- (void)requestProsesStyle:(BOOL)isShow {
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/app/stone/list-process-mode") Parameters:nil requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel * _Nullable respondObject) {
        
        NSMutableArray *array = [JHKeyValueModel mj_objectArrayWithKeyValuesArray:respondObject.data];
        self.pickerArray = array;
        NSMutableArray *titles = [NSMutableArray array];
        for (JHKeyValueModel *model in array) {
            [titles addObject:model.value];
        }
        self.picker.arrayData = titles;
        
        if (isShow) {
            [self.picker show];
        }
    } failureBlock:^(RequestModel * _Nullable respondObject) {
        
    }];
}


- (void)showPicker:(UIButton *)btn {
    [self endEditing:YES];
    if (_picker.arrayData) {
        [self.picker show];

    }else {
        [self requestProsesStyle:YES];
    }
}

- (void)pickerSingle:(JHPickerView *)pickerSingle selectedTitle:(NSString *)selectedTitle {
    JHKeyValueModel *model = self.pickerArray[ pickerSingle.selectedIndex];
    self.dealStyle.tag = model.key;
    self.dealStyle.textField.text = selectedTitle;
    
}

@end
