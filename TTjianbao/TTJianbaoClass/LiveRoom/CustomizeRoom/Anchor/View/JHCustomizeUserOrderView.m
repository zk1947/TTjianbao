//
//  JHCustomizeUserCardView.m
//  TTjianbao
//
//  Created by apple on 2020/9/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeUserOrderView.h"
#import "JHTitleTextItemView.h"
#import "NTESGrowingInternalTextView.h"
#import "JHSendOrderModel.h"
#import "OrderMode.h"
#import "JHOrderConfirmViewController.h"
#import "UIView+JHGradient.h"
#import "NSString+Common.h"
#import "IQKeyboardManager.h"
#import "JHGrowingIO.h"
#import "JHAntiFraud.h"

@interface JHCustomizeUserOrderView ()<UITextFieldDelegate,UITextViewDelegate>
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *topTitleLabel;
@property (strong, nonatomic) NTESGrowingInternalTextView *descText;
@property (strong, nonatomic) UILabel *descLabel;
@property (strong, nonatomic) UITextField *servePrice;  //服务费
@property (strong, nonatomic) UITextField *materPrice; //材料
@property (strong, nonatomic) UITextField *allPrice;   //总计
@end

@implementation JHCustomizeUserOrderView

//主播端
- (void)makeUI {
    [self.backView addSubview:self.topTitleLabel];
    [self.backView addSubview:self.imageView];
    float backHeight = 537;
    if(self.orderType == JHCustomizeUserOrderTypeSure){
        self.topTitleLabel.text = @"定制服务单";
    }else if(self.orderType == JHCustomizeUserOrderTypeIntent){
        self.topTitleLabel.text = @"定制意向单";
        backHeight = 476;
    }
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.width.equalTo(@260);
        make.height.mas_equalTo(backHeight);
    }];
    
    [self.topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.height.offset(25);
        make.top.equalTo(self.backView).offset(20);
    }];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topTitleLabel.mas_bottom).offset(10);
        make.centerX.equalTo(self.backView);
        make.height.width.equalTo(@240);
    }];
    
    NSMutableArray *titles = [NSMutableArray array];
    
    if (self.orderType == JHCustomizeUserOrderTypeSure) {
        [titles addObject:@"定制服务金"];
        [titles addObject:@"材料费      "];
        [titles addObject:@"合计金额   "];
    }else if(self.orderType == JHCustomizeUserOrderTypeIntent){
        [titles addObject:@"定制意向金"];
    }
    
    NSArray *place = @[@"¥请输入价格",@"¥请输入价格",@"¥请输入价格",@"¥请输入价格"];
    
    for (int i = 0; i<titles.count; i++) {
        JHTitleTextItemView *view = [[JHTitleTextItemView alloc] initWithTitle:titles[i] textPlace:place[i] isEdit:YES isShowLine:YES];
        
        if (i == 0 && self.orderType == JHCustomizeUserOrderTypeIntent) {
            view.textField.enabled = NO;
            view.line.hidden = YES;
            view.textField.textColor = HEXCOLOR(0xFF4200);
            view.textField.font = [UIFont fontWithName:kFontBoldDIN size:13];
            view.textField.text = [NSString stringWithFormat:@"¥%@",[UserInfoRequestManager sharedInstance].customizedIntentionPriceMax];
            
        }
        [view.textField addTarget:self action:@selector(changedTextField:) forControlEvents:UIControlEventEditingChanged];
        
        view.textField.keyboardType = UIKeyboardTypeDecimalPad;
        view.textField.delegate = self;
        [self.backView addSubview:view];
        
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageView.mas_bottom).offset(12+(12+18)*i);
            make.leading.trailing.equalTo(self.backView);
            make.height.offset(18);
        }];
        if (self.orderType == JHCustomizeUserOrderTypeSure) {
            if (i == 0){
                self.servePrice = view.textField;
                view.textField.keyboardType = UIKeyboardTypeNumberPad;
            }else if (i == 1){
                self.materPrice = view.textField;
            }else if (i == 2) {
                self.allPrice = view.textField;
                view.textField.enabled = NO;
                view.line.hidden = YES;
                view.textField.textColor = HEXCOLOR(0xFF4200);
                view.textField.font = [UIFont fontWithName:kFontBoldDIN size:15];
                view.textField.text = @" ";
            }
        }
        
    }
    
    [self.backView addSubview:self.descText];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(clickSendOrder:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"发送订单" forState:UIControlStateNormal];
    [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:kFontMedium size:14];
    [btn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    btn.layer.cornerRadius = 19;
    btn.layer.masksToBounds = YES;
    [self.backView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(10);
        make.trailing.offset(-10);
        make.height.offset(38);
        make.bottom.offset(-20);
    }];
    
    [self.descText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(70);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.mas_equalTo(btn.mas_top).offset(-15);
    }];
    
}

//用户端
- (void)makeUI_User {
    self.imageUrl = self.model.goodsUrl;
    [self.backView addSubview:self.imageView];
    [self.backView addSubview:self.topTitleLabel];
    self.topTitleLabel.font = JHMediumFont(14);
    float backHeight = 479;
    if(self.orderType == JHCustomizeUserOrderTypeIntentUser){
        backHeight = 440;
    }
    self.topTitleLabel.text = self.model.goodsTitle;
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self);
        make.width.equalTo(@260);
        make.height.mas_equalTo(backHeight);
    }];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(37);
        make.centerX.equalTo(self.backView);
        make.height.width.equalTo(@240);
    }];
    [self.topTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.offset(20);
        make.top.equalTo(self.imageView.mas_bottom).offset(10);
    }];
    
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = HEXCOLOR(0xF5F6FA);
    [self.backView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.height.offset(1);
        make.top.equalTo(self.topTitleLabel.mas_bottom).offset(10);
    }];
    
    NSMutableArray *titles = [NSMutableArray array];
    
    if (self.orderType == JHCustomizeUserOrderTypeSureUser) {
        [titles addObject:@"定制服务金"];
        [titles addObject:@"材料费      "];
        [titles addObject:@"合计金额   "];
    }else if(self.orderType == JHCustomizeUserOrderTypeIntentUser){
        [titles addObject:@"定制意向金"];
    }
    
    for (int i = 0; i<titles.count; i++) {
        JHTitleTextItemView *view = [[JHTitleTextItemView alloc] initWithTitle:titles[i] textPlace:@"1" isEdit:NO isShowLine:NO];
        view.textField.enabled = NO;
        view.textField.font = [UIFont fontWithName:kFontBoldDIN size:13];
        if(self.orderType == JHCustomizeUserOrderTypeIntentUser){
            if (i == 0) {
                view.textField.textColor = HEXCOLOR(0xFF4200);
                
                if([NSString isEmpty:self.model.orderPrice])
                    view.textField.text = @"¥0";
                else
                    view.textField.text = [NSString stringWithFormat:@"¥%@",self.model.orderPrice];
                
            }
        }else if(self.orderType == JHCustomizeUserOrderTypeSureUser){
            if (i == 0) {
                if([NSString isEmpty:self.model.manualCost])
                    view.textField.text = @"¥0";
                else
                    view.textField.text = [NSString stringWithFormat:@"¥%@",self.model.manualCost];
            }else if(i == 1){
                if([NSString isEmpty:self.model.materialCost])
                    view.textField.text = @"¥0";
                else
                    view.textField.text = [NSString stringWithFormat:@"¥%@",self.model.materialCost];
            }else if(i == 2){
                view.textField.textColor = HEXCOLOR(0xFF4200);
                view.textField.font = [UIFont fontWithName:kFontBoldDIN size:15];
                if([NSString isEmpty:self.model.orderPrice])
                    view.textField.text = @"¥0";
                else
                    view.textField.text = [NSString stringWithFormat:@"¥%@",self.model.orderPrice];
            }
        }
        
        
        [self.backView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(line.mas_bottom).offset(10+(10+18)*i);
            make.leading.trailing.equalTo(self.backView);
            make.height.offset(18);
        }];
        
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(clickPayOrder:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"确认支付" forState:UIControlStateNormal];
    [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:kFontMedium size:14];
    [btn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    btn.layer.cornerRadius = 19;
    btn.layer.masksToBounds = YES;
    [self.backView addSubview:btn];
    
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.offset(10);
        make.trailing.offset(-10);
        make.height.offset(38);
        make.bottom.offset(-20);
    }];
    if(self.orderType == JHCustomizeUserOrderTypeIntentUser){
        [self.backView addSubview:self.descLabel];
        [self.descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(17);
            make.left.mas_equalTo(10);
            make.right.mas_equalTo(-10);
            make.bottom.mas_equalTo(btn.mas_top).offset(-5);
        }];
    }
    
    
}


- (void)showAlert {
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 10.0f;
    
    if (self.orderType == JHCustomizeUserOrderTypeIntent || self.orderType == JHCustomizeUserOrderTypeSure) {
        [self makeUI];
    }else if (self.orderType == JHCustomizeUserOrderTypeIntentUser || self.orderType == JHCustomizeUserOrderTypeSureUser){
        [self makeUI_User];
    }
    
    [super showAlert];
    
}

- (void)clickPayOrder:(UIButton *)btn{
    [JHGrowingIO trackEventId:JHTrackOrderlive_pay_sure_click variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
    //确认支付
    JHOrderConfirmViewController *vc = [[JHOrderConfirmViewController alloc] init];
    vc.orderId = self.model.orderId;
    vc.fromString = JHConfirmFromOrderDialog;
    [self.viewController.navigationController pushViewController:vc animated:YES];
    [self hiddenAlert];
}
- (void)clickSendOrder:(UIButton *)btn {
    [self endEditing:YES];
    
    JHSendOrderModel *model = [JHSendOrderModel new];
    
    if (self.orderType == JHCustomizeUserOrderTypeSure) {
        if (!self.servePrice.text || self.servePrice.text.length == 0) {
            [self makeToast:@"请输入价格" duration:1.0 position:CSToastPositionCenter];
            return;
        }
        model.orderPrice = [self.allPrice.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
        model.materialCost = self.materPrice.text;
        model.manualCost = self.servePrice.text;
    }else if(self.orderType == JHCustomizeUserOrderTypeIntent){
        model.orderPrice = [UserInfoRequestManager sharedInstance].customizedIntentionPriceMax;
    }
    model.parentOrderId = self.parentOrderId;
    model.anchorId = self.anchorId;
    model.orderCategory = self.orderCategory;
    model.orderType = @7;
    model.goodsImg = self.imageUrl;
    model.barCode = @"";
    if (self.descText.text.length>0) {
        model.processingDes = self.descText.text;
    }
//    model.inputManual = @"2";
    model.viewerId = self.customerId;
//    model.biddingId = self.biddingId;
//    model.goodsCateId = self.selectedCate[@"id"];
    [self requestDataWithModel:model];
    
}

- (void)requestDataWithModel:(JHSendOrderModel *)model {
    NSMutableDictionary *dic = [model mj_keyValues];
    NSString * sm_deviceId = [JHAntiFraud deviceId];
    [dic setObject:(sm_deviceId ? : @"") forKey:@"sm_deviceId"];
    [SVProgressHUD show];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/auth/create") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showSuccessWithStatus:@"发送成功"];
        [self hiddenAlert];
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [SVProgressHUD showErrorWithStatus:respondObject.message];
    }];
}

#pragma mark -
- (void)changedTextField:(UITextField *)textField {
    if (self.allPrice) {
        double allPrice = [self.servePrice.text doubleValue]+[self.materPrice.text doubleValue];
        self.allPrice.text = [NSString stringWithFormat:@"¥%.2f",allPrice];

    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSendOrderKeyBoard object:@(YES)];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] postNotificationName:NotificationNameSendOrderKeyBoard object:@(NO)];
    
    return YES;
}

//参数一：range，要被替换的字符串的range，如果是新输入的，就没有字符串被替换，range.length = 0
//参数二：替换的字符串，即键盘即将输入或者即将粘贴到textField的string
//返回值为BOOL类型，YES表示允许替换，NO表示不允许
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    //新输入的
    if (string.length == 0) {
        return YES;
    }
    
    //第一个参数，被替换字符串的range
    //第二个参数，即将键入或者粘贴的string
    //返回的是改变过后的新str，即textfield的新的文本内容
    NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    //正则表达式（只支持两位小数）
    NSString *regex = @"^\\-?([1-9]\\d*|0)(\\.\\d{0,2})?$";
    //判断新的文本内容是否符合要求
    return [self isValid:checkStr withRegex:regex];
    
}
#pragma mark UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length>50) {
        textView.text = [textView.text substringToIndex:50];
    }
}

//检测改变过的文本是否匹配正则表达式，如果匹配表示可以键入，否则不能键入
- (BOOL) isValid:(NSString*)checkStr withRegex:(NSString*)regex
{
    NSPredicate *predicte = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicte evaluateWithObject:checkStr];
}

- (UILabel *)topTitleLabel {
    if (!_topTitleLabel) {
        _topTitleLabel = [UILabel new];
        _topTitleLabel.font = [UIFont fontWithName:kFontNormal size:18];
        _topTitleLabel.textColor = HEXCOLOR(0x333333);
        _topTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _topTitleLabel;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.layer.cornerRadius = 8;
        _imageView.layer.masksToBounds = YES;
        [_imageView jhSetImageWithURL:[NSURL URLWithString:self.imageUrl] placeholder:kDefaultCoverImage];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}
- (UILabel *)descLabel{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] init];
        _descLabel.text = @"意向金确认支付后，不予退回";
        _descLabel.textColor = HEXCOLOR(0x999999);
        _descLabel.font = JHFont(12);
        _descLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _descLabel;
}
- (NTESGrowingInternalTextView *)descText{
    if (!_descText) {
        _descText = [[NTESGrowingInternalTextView alloc] init];
        _descText.layer.cornerRadius = 8;
        _descText.layer.borderColor = HEXCOLOR(0xF5F6FA).CGColor;
        _descText.layer.borderWidth = 0.5;
        _descText.layer.masksToBounds = YES;
        _descText.delegate = self;
        NSAttributedString * placestr = [[NSAttributedString alloc] initWithString:@"意向描述：为避免纠纷，请描述用户的加工需求" attributes:@{NSFontAttributeName:JHFont(12),NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        _descText.placeholderAttributedText = placestr;
        _descText.font = JHFont(12);
        _descText.textColor = HEXCOLOR(0x333333);
    }
    return _descText;
}
- (void)closeAction:(UIButton *)btn{

    if (self.orderType == JHCustomizeUserOrderTypeSureUser || self.orderType == JHCustomizeUserOrderTypeIntentUser){
        //用户端意向单 服务单关闭买点
        [JHGrowingIO trackEventId:JHTrackOrderlive_pay_close_click variables:[[JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel] mj_keyValues]];
    }
    [super closeAction:btn];
}
@end
