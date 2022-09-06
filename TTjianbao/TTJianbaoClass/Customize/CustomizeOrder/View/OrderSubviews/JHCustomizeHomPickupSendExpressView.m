//
//  JHCustomizeHomPickupSendExpressView.m
//  TTjianbao
//
//  Created by haozhipeng on 2021/1/27.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHCustomizeHomPickupSendExpressView.h"
#define NUM @"0123456789"
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"

@interface JHCustomizeHomPickupSendExpressView ()<UITextFieldDelegate>
@property(nonatomic,strong) UILabel *title;
@end

@implementation JHCustomizeHomPickupSendExpressView

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.keyboardType = UIKeyboardTypeASCIICapable;
        _textField.font = [UIFont fontWithName:kFontMedium size:13];;
        _textField.placeholder = @"请填写物流单号";
        _textField.textColor = kColor333;
        _textField.textAlignment = NSTextAlignmentRight;
        _textField.delegate = self;
    }
    return _textField;
}
-(void)setSubViews{
    
    _title=[[UILabel alloc]init];
    _title.text=@"填写发货信息";
    _title.font=[UIFont fontWithName:kFontMedium size:15];
    _title.backgroundColor=[UIColor clearColor];
    _title.textColor=kColor333;
    _title.numberOfLines = 1;
    _title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _title.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:_title];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.top.equalTo(self).offset(0);
        make.height.offset(44);
    }];
    //物流公司
    UIView * chooseView=[[UIView alloc]init];
    //  chooseView.backgroundColor=[UIColor yellowColor];
    chooseView.userInteractionEnabled=YES;
    chooseView.layer.masksToBounds=YES;
    [chooseView  addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(chooseExpress)]];
    [self addSubview:chooseView];
    [chooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_title.mas_bottom).offset(0);
        make.left.equalTo(self).offset(0);
        make.right.equalTo(self).offset(0);
        make.height.offset(44);
    }];
    
    JHCustomLine *line = [JHUIFactory createLine];
    [chooseView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(chooseView.mas_bottom).offset(0);
        make.height.offset(0.5);
        make.left.offset(10);
        make.right.offset(-10);
    }];
    
    UIImageView *indicator=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"customize_homePickup_next_icon"]];
    indicator.backgroundColor=[UIColor clearColor];
    [chooseView addSubview:indicator];
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(chooseView).offset(-10);
        make.centerY.equalTo(chooseView);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
    
    UILabel  *expressTitle=[[UILabel alloc]init];
    expressTitle.text=@"物流公司";
    expressTitle.font=[UIFont fontWithName:kFontNormal size:13];
    expressTitle.backgroundColor=[UIColor clearColor];
    expressTitle.textColor=kColor666;
    expressTitle.numberOfLines = 1;
    expressTitle.textAlignment = NSTextAlignmentLeft;
    expressTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [chooseView addSubview:expressTitle];
    [expressTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(chooseView).offset(10);
        make.centerY.equalTo(chooseView);
        make.width.offset(70);
    }];
    
    _expressCompany=[[UILabel alloc]init];
    _expressCompany.text=@"";
    _expressCompany.font=[UIFont fontWithName:kFontMedium size:13];
    _expressCompany.backgroundColor=[UIColor clearColor];
    _expressCompany.textColor = kColor333;
    _expressCompany.numberOfLines = 1;
    _expressCompany.textAlignment = NSTextAlignmentRight;
    _expressCompany.lineBreakMode = NSLineBreakByWordWrapping;
    [chooseView addSubview:_expressCompany];
    [_expressCompany mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(expressTitle);
        make.right.equalTo(self).offset(-40);
        make.left.equalTo(expressTitle.mas_right).offset(10);
    }];
    
    //物流单号
    UILabel  *codeTitle=[[UILabel alloc]init];
    codeTitle.text=@"物流单号";
    codeTitle.font=[UIFont fontWithName:kFontNormal size:13];
    codeTitle.backgroundColor=[UIColor clearColor];
    codeTitle.textColor=kColor666;
    codeTitle.numberOfLines = 1;
    codeTitle.textAlignment = NSTextAlignmentLeft;
    codeTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:codeTitle];
    
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeTitle.mas_right).offset(10);
        make.height.offset(44);
        make.top.equalTo(chooseView.mas_bottom);
        make.right.equalTo(self).offset(-40);
        make.bottom.equalTo(self).offset(0);
    }];
    
    [codeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.width.offset(70);
        make.centerY.equalTo(self.textField);
    }];
    
    JHCustomLine *line2 = [JHUIFactory createLine];
    [self addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.textField.mas_bottom).offset(0);
        make.height.offset(0.5);
        make.left.offset(10);
        make.right.offset(-10);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"customize_homePickup_scan_icon"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(scanCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18, 18));
        make.centerY.equalTo(self.textField);
        make.right.equalTo(self).offset(-10);
        
    }];
    
}
-(void)chooseExpress{
    [self.textField resignFirstResponder];
    if (self.chooseExpressHandle) {
        self.chooseExpressHandle(nil);
    }
}
- (void)scanCodeAction:(UIButton *)btn{
    if (self.buttonHandle) {
        self.buttonHandle(nil);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    if ([string isEqualToString:filtered]) {
        if (textField == self.textField) {
            //实时回传输入的内容
            self.textFieldString(string);
            // 这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
            if (range.length == 1 && string.length == 0) {
                return YES;
            }  else if (self.textField.text.length >= 30) {
                self.textField.text = [textField.text substringToIndex:30];
                return NO;
            }
        }
        return YES;
    }
    
    return NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [_textField resignFirstResponder];
    return NO;
}
-(void)setTitleString:(NSString *)titleString{
    
    _titleString=titleString;
    self.title.text=_titleString;
    if(_titleString){
        [_title mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(20);
            make.top.equalTo(self).offset(10);
        }];
    }
}
-(void)setIsStoneResellSend:(BOOL)isStoneResellSend{
    
    _isStoneResellSend=isStoneResellSend;
    if (_isStoneResellSend) {
        _phoneNum.textAlignment = NSTextAlignmentRight;
    }
    
}

@end
