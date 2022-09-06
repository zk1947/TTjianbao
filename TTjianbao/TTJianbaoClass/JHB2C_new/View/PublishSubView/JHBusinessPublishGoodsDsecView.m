//
//  JHBusinessPublishGoodsDsecView.m
//  TTjianbao
//
//  Created by liuhai on 2021/8/11.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHBusinessPublishGoodsDsecView.h"
#import "NSString+Common.h"
#import "JHSwitch.h"
#define kMaxAmount 90000000.00

@interface JHBusinessPublishGoodsDsecView ()<UITextViewDelegate,UITextFieldDelegate>
@property(nonatomic, strong) UITextView * textView;
@property(nonatomic, strong) UILabel * placeholderLbl;
@property(nonatomic, strong) UILabel *gupinLabel;
@property(nonatomic, strong) UITextField *salePricefield;
@property(nonatomic, strong) UITextField *saleNumfield;
@property(nonatomic, strong) JHSwitch  *switchView;

@property(nonatomic, assign) JHB2CPublishGoodsType publishtype;
@property(nonatomic, strong) UITextField *startPricefield; //起拍价
@property(nonatomic, strong) UITextField *addPricefield;  //加价
@property(nonatomic, strong) UITextField *guaranteefield;    //保证金
@end

@implementation JHBusinessPublishGoodsDsecView
- (instancetype)initWithType:(JHB2CPublishGoodsType)type{
    self = [super init];
    if (self) {

        self.publishtype = type;
        [self setItems];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setItems{
    self.backgroundColor = HEXCOLOR(0xFFFFFF);
    UILabel * cateLabel = [[UILabel alloc] init];
    cateLabel.font = JHMediumFont(15);
    cateLabel.textColor = HEXCOLOR(0x222222);
    cateLabel.text = @"商品描述";
    [self addSubview:cateLabel];
    [cateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0).offset(14);
        make.left.equalTo(@0).offset(12);
    }];
    
    [self addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.equalTo(@0).inset(12);
        make.top.equalTo(cateLabel.mas_bottom).offset(12);
        make.height.mas_equalTo(75);
    }];
    [self.textView addSubview:self.placeholderLbl];
    [self.placeholderLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(@0).inset(10);
        make.right.mas_equalTo(self.mas_right).offset(-10);
    }];
    self.gupinLabel = [[UILabel alloc] init];
    self.gupinLabel.font = JHMediumFont(15);
    self.gupinLabel.textColor = HEXCOLOR(0x222222);
    self.gupinLabel.text = @"是否为孤品：否";
    [self addSubview:self.gupinLabel];
    [self.gupinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textView.mas_bottom).offset(14);
        make.left.equalTo(@0).offset(12);
    }];
    self.switchView = [[JHSwitch alloc]init];
    self.switchView.onTintColor= kColorMain;
    self.switchView.on = NO;
    [self.switchView addTarget:self action:@selector(switchAction) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.switchView];
    [self.switchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-12);
        make.centerY.equalTo(self.gupinLabel);
    }];
    
    UILabel * desclabel = [[UILabel alloc] init];
    desclabel.font = JHFont(11);
    desclabel.textColor = HEXCOLOR(0x999999);
    
    [self addSubview:desclabel];
    [desclabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.gupinLabel.mas_bottom).offset(10);
        make.left.equalTo(@0).offset(12);
    }];
    if (self.publishtype == JHB2CPublishGoodsType_BuyNow) {
        desclabel.text = @"！标记为孤品后，前端将显示孤品标签；孤品库存为1且不可修改";
        [self creatPriceUI];//一口价
    }else if(self.publishtype == JHB2CPublishGoodsType_Auction){
        desclabel.text = @"！标记为孤品后，前端将显示孤品标签";
//        拍卖
        [self creatAuctionUI];
    }
    
}
- (void)creatAuctionUI{
    UILabel * priceLabel = [[UILabel alloc] init];
    priceLabel.font = JHMediumFont(15);
    priceLabel.textColor = HEXCOLOR(0x222222);
    priceLabel.text = @"起拍价";
    [self addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.gupinLabel.mas_bottom).offset(53);
        make.left.equalTo(@0).offset(12);
    }];
    UIImageView *starImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recycle_uploadproduct_star"]];
    [self addSubview:starImageView];
    [starImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(priceLabel);
        make.left.equalTo(priceLabel.mas_right).offset(2);
    }];
    self.startPricefield = [UITextField jh_textFieldWithFont:13 textAlignment:NSTextAlignmentLeft textColor:HEXCOLOR(0x333333) placeholderText:@"商品售价0.00（您可接受的最低成交价）" placeholderColor:HEXCOLOR(0xFF999999) addToSupView:self];
    self.startPricefield.delegate = self;
    self.startPricefield.keyboardType = UIKeyboardTypeDecimalPad;
    [self.startPricefield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceLabel);
        make.left.equalTo(@0).offset(101);
        make.right.equalTo(self);
        make.height.equalTo(@21);
    }];
    
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(priceLabel).offset(13);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(102);
        make.right.equalTo(self);
    }];
    
    UILabel * numLabel = [[UILabel alloc] init];
    numLabel.font = JHMediumFont(15);
    numLabel.textColor = HEXCOLOR(0x222222);
    numLabel.text = @"加价幅度";
    [self addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line).offset(13);
        make.left.equalTo(@0).offset(12);
    }];
    UIImageView *starImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recycle_uploadproduct_star"]];
    [self addSubview:starImageView2];
    [starImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(numLabel);
        make.left.equalTo(numLabel.mas_right).offset(2);
    }];
    self.addPricefield = [UITextField jh_textFieldWithFont:13 textAlignment:NSTextAlignmentLeft textColor:HEXCOLOR(0x333333) placeholderText:@"加价幅度0.00（买家每次加价幅度）" placeholderColor:HEXCOLOR(0xFF999999) addToSupView:self];
    self.addPricefield.delegate = self;
    self.addPricefield.keyboardType = UIKeyboardTypeDecimalPad;
    [self.addPricefield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(numLabel);
        make.left.equalTo(@0).offset(101);
        make.right.equalTo(self);
        make.height.equalTo(@21);
    }];
    
    UIView * line2 = [[UIView alloc] init];
    line2.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(numLabel).offset(13);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(102);
        make.right.equalTo(self);
    }];
    
    UILabel * guaranLabel = [[UILabel alloc] init];
    guaranLabel.font = JHMediumFont(15);
    guaranLabel.textColor = HEXCOLOR(0x222222);
    guaranLabel.text = @"保证金";
    [self addSubview:guaranLabel];
    [guaranLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line2).offset(13);
        make.left.equalTo(@0).offset(12);
    }];
    
    self.guaranteefield = [UITextField jh_textFieldWithFont:13 textAlignment:NSTextAlignmentLeft textColor:HEXCOLOR(0x333333) placeholderText:@"保证金0.00" placeholderColor:HEXCOLOR(0xFF999999) addToSupView:self];
    self.guaranteefield.delegate = self;
    self.guaranteefield.keyboardType = UIKeyboardTypeDecimalPad;
    [self.guaranteefield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(guaranLabel);
        make.left.equalTo(@0).offset(101);
        make.right.equalTo(self);
        make.height.equalTo(@21);
    }];
    
    UIView * line3 = [[UIView alloc] init];
    line3.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self addSubview:line3];
    [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(guaranLabel).offset(13);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(102);
        make.right.equalTo(self);
    }];
    
    UILabel * desclabel = [[UILabel alloc] init];
    desclabel.font = JHFont(11);
    desclabel.textColor = HEXCOLOR(0x999999);
    desclabel.text = @"！保证金为买家出价时支付，若买家中拍未付款则保证金补偿给商家";
    [self addSubview:desclabel];
    [desclabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line3.mas_bottom).offset(10);
        make.left.equalTo(@0).offset(12);
    }];
    
}
- (void)creatPriceUI{
    UILabel * priceLabel = [[UILabel alloc] init];
    priceLabel.font = JHMediumFont(15);
    priceLabel.textColor = HEXCOLOR(0x222222);
    priceLabel.text = @"售价";
    [self addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.gupinLabel.mas_bottom).offset(53);
        make.left.equalTo(@0).offset(12);
    }];
    UIImageView *starImageView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recycle_uploadproduct_star"]];
    [self addSubview:starImageView2];
    [starImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(priceLabel);
        make.left.equalTo(priceLabel.mas_right).offset(2);
    }];
    self.salePricefield = [UITextField jh_textFieldWithFont:13 textAlignment:NSTextAlignmentLeft textColor:HEXCOLOR(0x333333) placeholderText:@"商品售价0.00" placeholderColor:HEXCOLOR(0xFF999999) addToSupView:self];
    self.salePricefield.delegate = self;
    self.salePricefield.keyboardType = UIKeyboardTypeDecimalPad;
    [self.salePricefield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(priceLabel);
        make.left.equalTo(@0).offset(101);
        make.right.equalTo(self);
        make.height.equalTo(@21);
    }];
    
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = HEXCOLOR(0xEEEEEE);
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(priceLabel).offset(13);
        make.height.mas_equalTo(1);
        make.left.mas_equalTo(102);
        make.right.equalTo(self);
    }];
    
    UILabel * numLabel = [[UILabel alloc] init];
    numLabel.font = JHMediumFont(15);
    numLabel.textColor = HEXCOLOR(0x222222);
    numLabel.text = @"可售库存";
    [self addSubview:numLabel];
    [numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line).offset(13);
        make.left.equalTo(@0).offset(12);
    }];
    UIImageView *starImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recycle_uploadproduct_star"]];
    [self addSubview:starImageView];
    [starImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(numLabel);
        make.left.equalTo(numLabel.mas_right).offset(2);
    }];
    self.saleNumfield = [UITextField jh_textFieldWithFont:13 textAlignment:NSTextAlignmentLeft textColor:HEXCOLOR(0x333333) placeholderText:@"请填写商品库存" placeholderColor:HEXCOLOR(0xFF999999) addToSupView:self];
    self.saleNumfield.delegate = self;
    self.saleNumfield.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
    [self.saleNumfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(numLabel);
        make.left.equalTo(@0).offset(101);
        make.right.equalTo(self);
        make.height.equalTo(@21);
    }];
}

- (void)switchAction{
    self.publishModle.uniqueStatus = self.switchView.on?1:0;
    if (self.switchView.on) {
        self.gupinLabel.text = @"是否为孤品：是";
        self.saleNumfield.text = @"1";
        self.saleNumfield.enabled = NO;
        self.publishModle.stock = 1;
    }else{
        self.saleNumfield.enabled = YES;
        self.gupinLabel.text = @"是否为孤品：否";
    }
    
}

- (UILabel *)placeholderLbl{
    if (!_placeholderLbl) {
        
        UILabel *label = [UILabel new];
        label.font = JHFont(13);
        label.textColor = HEXCOLOR(0x999999);
        label.numberOfLines = 1;
        NSString *placeStr = @"请输入商品描述";
        label.text = placeStr;
        _placeholderLbl = label;
    }
    return _placeholderLbl;
}


- (UITextView *)textView{
    if (!_textView) {
        UITextView *view = [UITextView new];
        view.backgroundColor = HEXCOLOR(0xF9F9F9);
//        view.textContainerInset = UIEdgeInsetsMake(10, 10, 10, 10);
        view.layer.cornerRadius = 5;
        view.font = JHFont(13);
        view.delegate = self;
        view.textColor = HEXCOLOR(0x222222);
        view.tintColor = HEXCOLOR(0xFED73A);
        _textView = view;
    }
    return _textView;
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.placeholderLbl.hidden = YES;
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    self.placeholderLbl.hidden = textView.text.length;
}
- (void)textViewDidChange:(UITextView *)textView{
    self.publishModle.productDesc = textView.text;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSInteger maxlenth = 600;
    if (textView.text.length + text.length > maxlenth) {return NO;}
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.saleNumfield) {
        self.publishModle.stock = [self.saleNumfield.text intValue];
    }else if(textField == self.salePricefield){
        self.publishModle.price = self.salePricefield.text;
    }else if(textField == self.startPricefield){
        self.publishModle.startPrice = self.startPricefield.text;
    }else if(textField == self.addPricefield){
        self.publishModle.bidIncrement = self.addPricefield.text;
    }else if(textField == self.guaranteefield){
        self.publishModle.earnestMoney = self.guaranteefield.text;
    }
}

- (void)setNetModelData{
    self.textView.text = self.publishModle.productDesc;
    if (self.publishModle.productDesc.length>0) {
        self.placeholderLbl.hidden = YES;
    }
    self.saleNumfield.text = [NSString stringWithFormat:@"%d",self.publishModle.sellStock];
    self.publishModle.stock = self.publishModle.sellStock;
    self.salePricefield.text = self.publishModle.price;
    self.startPricefield.text = self.publishModle.startPrice ;
    self.addPricefield.text = self.publishModle.bidIncrement;
    self.guaranteefield.text = self.publishModle.earnestMoney;
    
    if (self.publishModle.uniqueStatus == 1) {
        self.switchView.on = YES;
    }else{
        self.switchView.on = NO;
    }
    [self switchAction];
}


#pragma mark - TextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.salePricefield ||
        textField == self.startPricefield ||
        textField == self.addPricefield ||
        textField == self.guaranteefield) {
        return [self judgeTextFieldInputDecimals:textField replacementString:string shouldChangeCharactersInRange:range];
    }
    if (textField == self.saleNumfield) {
        if (textField.text.length + string.length > 8) {return NO;}
    }
    return YES;
}

- (BOOL)judgeTextFieldInputDecimals:(UITextField *)textField
                  replacementString:(NSString *)string
      shouldChangeCharactersInRange:(NSRange)range {
    // 1 不能直接输入小数点
    if ( [textField.text isEqualToString:@""] && [string isEqualToString:@"."] )  return NO;
    // 2 输入框第一个字符为“0”时候，第二个字符如果不是“.”,那么文本框内的显示内容就是新输入的字符[textField.text length] == 1  防止例如0.5会变成5
    NSRange zeroRange = [textField.text rangeOfString:@"0"];
    if(zeroRange.length == 1 && [textField.text length] == 1 && ![string isEqualToString:@"."]){
        textField.text = string;
        return NO;
    }
    // 3 保留两位小数
    NSUInteger remain = 2;
    NSRange pointRange = [textField.text rangeOfString:@"."];
    // 拼接输入的最后一个字符
    NSString *tempStr = [textField.text stringByAppendingString:string];
    NSUInteger strlen = [tempStr length];
    // 输入框内存在小数点， 不让再次输入“.” 或者 总长度-包括小数点之前的长度>remain 就不能再输入任何字符
    if(pointRange.length > 0 &&([string isEqualToString:@"."] || strlen - (pointRange.location + 1) > remain))
        return NO;
    // 4 小数点已经存在情况下可以输入的字符集  and 小数点还不存在情况下可以输入的字符集
    NSCharacterSet *numbers = (pointRange.length > 0)?[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] : [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    
    NSScanner *scanner = [NSScanner scannerWithString:string];
    NSString *buffer;
    // 判断string在不在numbers的字符集合内
    BOOL scan = [scanner scanCharactersFromSet:numbers intoString:&buffer];
    
    if ( !scan && ([string length] != 0) ) { // 包括输入空格scan为NO， 点击删除键[string length]为0
        return NO;
    }
    if (pointRange.length > 0) { /// 包含小数
        if (textField.text.length > 11) {
            if ([string isEqualToString:@""]) {

            } else {
                return NO;
            }
        }
    } else { /// 不包含小数
        if (textField.text.length > 7) {
            if ([string isEqualToString:@""] || [string isEqualToString:@"."]) {

            } else {
                return NO;
            }
        }
    }
    
    double priceNum = [[NSString stringWithFormat:@"%@%@",textField.text,string] doubleValue];
    if (priceNum > kMaxAmount) {
        textField.text = [textField.text substringAtRange:NSMakeRange(0, textField.text.length -1)];
    }
    
    return YES;
}
@end
