//
//  JHSendOrderProccessGoodServiceView.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/14.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHSendOrderProccessGoodServiceView.h"
#import "JHProccessGoodSubView.h"
#import "JHLine.h"
#import "JHSendOrderModel.h"
#import "TTjianbaoHeader.h"
#import "JHAntiFraud.h"

#define kGoodSubViewHeight 106
#define kFontSize 13
#define kTextColor HEXCOLOR(0x333333)
#define kTextExtColor HEXCOLOR(0x999999)
#define kBackgroundColor [UIColor whiteColor]
#define kDefaultDesc @"加工描述：为避免纠纷，请描述用户的加工需求。"

@interface JHSendOrderProccessGoodServiceView () <UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UIView* backView;
@property (nonatomic, strong) UILabel* titleText;
@property (nonatomic, strong) UIButton* closeButton;
@property (nonatomic, strong) JHProccessGoodSubView* goodSubView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UILabel* totalLabel;
@property (nonatomic, strong) UITextField* goodTextField;
@property (nonatomic, strong) UITextField* workTextField;
@property (nonatomic, strong) UITextView* descTextView;

@end

@implementation JHSendOrderProccessGoodServiceView

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = HEXCOLORA(0x000000, 0.2);
//        [self addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
        [self drawSubview];
    }
    return self;
}


- (void)setOrderModel:(OrderMode *)orderModel {
    _orderModel = orderModel;
    [_goodSubView setData:orderModel];

}

- (void)setStoneModel:(JHLastSaleGoodsModel *)stoneModel {
    _stoneModel = stoneModel;
    OrderMode *orderModel = [OrderMode new];
    orderModel.goodsTitle = stoneModel.goodsTitle;
    orderModel.originOrderPrice = stoneModel.purchasePrice;
    orderModel.orderCode = @"";
    orderModel.goodsImg = stoneModel.goodsUrl;
    [_goodSubView setData:orderModel];
}

- (void)drawSubview
{
    [self addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(52);
        make.centerY.equalTo(self).offset(-30);
        make.width.mas_equalTo(ScreenW-52*2);
        make.height.mas_equalTo(368);//默认
    }];
    
    [self.backView addSubview:self.titleText];
    [self.titleText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(10);
        make.centerX.equalTo(self.backView);
        make.width.mas_equalTo(75);
        make.height.mas_equalTo(21);
    }];
    
    [self addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(28);
        make.right.equalTo(self.backView).offset(28/2);
        make.top.equalTo(self.backView).offset(-28/2);
    }];
    
    _goodSubView = [[JHProccessGoodSubView alloc] init];
    [self.backView  addSubview:_goodSubView];
    [self.goodSubView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(self.backView).offset(41);
        make.width.mas_equalTo(ScreenW-52*2);
        make.height.mas_equalTo(kGoodSubViewHeight);
    }];
    
    //材料费
    UILabel* goodLabel = [[UILabel alloc] init];
    goodLabel.backgroundColor = kBackgroundColor;
    goodLabel.textColor = kTextColor;
    goodLabel.font = [UIFont fontWithName:kFontMedium size:kFontSize];
    goodLabel.textAlignment = NSTextAlignmentLeft;
    goodLabel.text = @"材料费";
    [self.backView addSubview:goodLabel];
    [goodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodSubView.mas_bottom).offset(10);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(39);
        make.height.mas_equalTo(18);
    }];
    
    _goodTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, UI.statusAndNavBarHeight-30.0, ScreenWidth-74, 30)];
    _goodTextField.delegate = self;
    _goodTextField.placeholder = @"¥请输入价格";
    _goodTextField.textColor = kTextExtColor;
    _goodTextField.font = [UIFont fontWithName:kFontMedium size:kFontSize];
    _goodTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _goodTextField.backgroundColor = kBackgroundColor;
    _goodTextField.returnKeyType = UIReturnKeyDone;
    [_goodTextField setTintColor:kTextColor];//光标颜色
    _goodTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    _goodTextField.layer.cornerRadius = 15.f;
    [_goodTextField addTarget:self action:@selector(textFieldDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [_goodTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.backView addSubview:self.goodTextField];
    [_goodTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodLabel);
        make.left.mas_equalTo(goodLabel.mas_right).offset(5);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(18);
    }];
    
    //横线
    JHCustomLine* goodFeeLine = [[JHCustomLine alloc] init];
    [self.backView addSubview:goodFeeLine];
    [goodFeeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodTextField.mas_bottom).offset(3);
        make.left.equalTo(self.goodTextField);
        make.right.mas_equalTo(self.backView.mas_right).offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    //手工费
    UILabel* workLabel = [[UILabel alloc] init];
    workLabel.backgroundColor = kBackgroundColor;
    workLabel.textColor = kTextColor;
    workLabel.font = [UIFont fontWithName:kFontMedium size:kFontSize];
    workLabel.textAlignment = NSTextAlignmentLeft;
    workLabel.text = @"手工费";
    [self.backView addSubview:workLabel];
    [workLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(goodLabel.mas_bottom).offset(20);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(39);
        make.height.mas_equalTo(18);
    }];
    
    _workTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, UI.statusAndNavBarHeight-30.0, ScreenWidth-74, 30)];
    _workTextField.delegate = self;
    _workTextField.placeholder = @"¥请输入价格";
    _workTextField.textColor = kTextExtColor;
    _workTextField.font = [UIFont fontWithName:kFontMedium size:kFontSize];
    _workTextField.keyboardType = UIKeyboardTypeDecimalPad;
    _workTextField.backgroundColor = kBackgroundColor;
    _workTextField.returnKeyType = UIReturnKeyDone;
    [_workTextField setTintColor:kTextColor];//光标颜色
    _workTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
//    _workTextField.layer.cornerRadius = 15.f;
    [_workTextField addTarget:self action:@selector(textFieldDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [_workTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.backView addSubview:self.workTextField];
    [_workTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(workLabel);
        make.left.mas_equalTo(workLabel.mas_right).offset(5);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(18);
    }];
    
    //横线
    JHCustomLine* workFeeLine = [[JHCustomLine alloc] init];
    [self.backView addSubview:workFeeLine];
    [workFeeLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.workTextField.mas_bottom).offset(3);
        make.left.equalTo(self.workTextField);
        make.right.mas_equalTo(self.backView.mas_right).offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    //合计
    UILabel* total = [[UILabel alloc] init];
    total.backgroundColor = kBackgroundColor;
    total.textColor = kTextColor;
    total.font = [UIFont fontWithName:kFontMedium size:kFontSize];
    total.textAlignment = NSTextAlignmentLeft;
    total.text = @"合计";
    [self.backView addSubview:total];
    [total mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(workLabel.mas_bottom).offset(13);
          make.left.mas_equalTo(10);
          make.width.mas_equalTo(26);
          make.height.mas_equalTo(18);
      }];
    //合计总价格
    _totalLabel = [[UILabel alloc] init];
    _totalLabel.backgroundColor = kBackgroundColor;
    _totalLabel.textColor = HEXCOLOR(0xFF4200);
    _totalLabel.font = [UIFont fontWithName:kFontMedium size:15];
    _totalLabel.textAlignment = NSTextAlignmentLeft;
    _totalLabel.text = @"¥0";
    [self.backView addSubview:_totalLabel];
    [_totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(total);
        make.left.mas_equalTo(total.mas_right).offset(19);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(17);
    }];
    //描述
    UITextView* descLabel = [[UITextView alloc] init];
    descLabel.layer.borderColor = HEXCOLOR(0xf7f7f7).CGColor;
    descLabel.layer.borderWidth = 1;
    descLabel.layer.cornerRadius = 2;
    descLabel.layer.masksToBounds = YES;
    descLabel.backgroundColor = kBackgroundColor;
    descLabel.textColor = HEXCOLOR(0xEEEEEE);
    descLabel.font = [UIFont fontWithName:kFontMedium size:kFontSize];
    descLabel.textAlignment = NSTextAlignmentLeft;
    descLabel.text = kDefaultDesc;
//    descLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.descTextView = descLabel;
    descLabel.delegate = self;
    [self.backView addSubview:descLabel];
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(workLabel.mas_bottom).offset(44);
          make.left.mas_equalTo(10);
          make.right.mas_equalTo(-10);
        make.height.offset(50);
      }];
    //button
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.cornerRadius = 20;
    btn.backgroundColor = HEXCOLOR(0xFEE100);
    [btn setTitle:@"确认发送" forState:UIControlStateNormal];
    [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pressSend) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.backView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(descLabel.mas_bottom).offset(10);
//        make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(190);
        make.centerX.equalTo(self);
     }];
}

- (UIView*)backView
{
    if (!_backView)
    {
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = 6;
        _backView.layer.masksToBounds = YES;
    }
    
    return _backView;
}

- (UILabel *)titleText
{
    if (!_titleText)
    {
        _titleText = [UILabel new];
        _titleText.font = [UIFont fontWithName:kFontMedium size:15];
        _titleText.textColor = HEXCOLOR(0x333333);
        _titleText.text = @"加工服务单";
        _titleText.backgroundColor = [UIColor whiteColor];
    }
    
    return _titleText;
}

- (UIButton *)closeButton
{
    if (!_closeButton)
    {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.layer.cornerRadius = 14;
        _closeButton.backgroundColor = HEXCOLOR(0x333333);
//        [_closeButton setTitle:@"×" forState:UIControlStateNormal];
        [_closeButton setImage:[UIImage imageNamed:@"icon_alert_close"] forState:UIControlStateNormal];

        [_closeButton setTitleColor:HEXCOLOR(0xFFFFFF) forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _closeButton.titleLabel.font = [UIFont systemFontOfSize:28];
    }
    
    return _closeButton;
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
#pragma mark - UITextField Methods
- (void)textFieldDidBegin:(UITextField *)field
{
    NSString *text = field.text;
    NSLog(@"text = %@", text);
}

- (void)textFieldChanged:(UITextField *)field
{
    NSString *changeText = field.text;
    NSLog(@"curent text = %@", changeText);

    double total = [_workTextField.text doubleValue] + [_goodTextField.text doubleValue];
    _totalLabel.text = [NSString stringWithFormat:@"¥%.2f", total];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.goodTextField endEditing:YES];
    [self.workTextField endEditing:YES];
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string
{
    if (string.length == 0) {
        return YES;
    }
   
    NSString *checkStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    //正则表达式（只支持两位小数）
    NSString *regex = @"^\\-?([1-9]\\d*|0)(\\.\\d{0,2})?$";
    return [self isValid:checkStr withRegex:regex];
}

//检测改变过的文本是否匹配正则表达式，如果匹配表示可以键入，否则不能键入
- (BOOL) isValid:(NSString*)checkStr withRegex:(NSString*)regex
{
    NSPredicate *predicte = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicte evaluateWithObject:checkStr];
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
//{
//   return [self validateNumber:string];
//}

- (BOOL)validateNumber:(NSString*)number
{
   BOOL res = YES;
   NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
   int i = 0;
   while (i < number.length) {
       NSString * string = [number substringWithRange:NSMakeRange(i, 1)];
       NSRange range = [string rangeOfCharacterFromSet:tmpSet];
       if (range.length == 0) {
           res = NO;
           break;
       }
       i++;
   }
   return res;
}

#pragma event
- (void)dismiss
{
    [self removeFromSuperview];
}

- (void)pressSend
{
    [self endEditing:YES];
    
    NSString *all = [self.totalLabel.text stringByReplacingOccurrencesOfString:@"¥" withString:@""];
    if ([all doubleValue] == 0.0) {
        [self makeToast:@"加工费需大于0元" duration:1.0 position:CSToastPositionCenter];
        return;
    }
    if (self.orderModel) {
        JHSendOrderModel *model = [JHSendOrderModel new];
         model.anchorId = self.orderModel.sellerCustomerId;
         model.orderCategory = @"processingGoods";
         model.parentOrderId = self.orderModel.orderId;
         model.orderPrice = all;
         model.materialCost = self.goodTextField.text;
         model.manualCost = self.workTextField.text;
        
         model.goodsImg = @"";
         if ([self.descTextView.text isEqualToString:kDefaultDesc]) {
             model.processingDes = @"";
         }else {
             model.processingDes = self.descTextView.text;
         }
         model.viewerId = self.orderModel.buyerCustomerId;
         [self requestDataWithModel:model];
    }else if (self.stoneModel) {
        //TODO:yaoyao 加工服务单
        //原石的单独写一个弹窗 这里不需要了
        
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
}

- (void)requestDataWithModel:(JHSendOrderModel *)model {
    NSMutableDictionary *dic = [model mj_keyValues];
    NSString * sm_deviceId = [JHAntiFraud deviceId];
    [dic setObject:(sm_deviceId ? : @"") forKey:@"sm_deviceId"];
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/auth/create") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
            [self makeToast:@"发送成功"];
            [self dismiss];
        
    } failureBlock:^(RequestModel *respondObject) {
        [self makeToast:respondObject.message duration:1 position:CSToastPositionCenter];
    }];
}

@end
