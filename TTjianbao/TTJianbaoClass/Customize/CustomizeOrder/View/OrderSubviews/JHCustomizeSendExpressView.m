//
//  JHCustomizeSendExpressView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/11/18.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHCustomizeSendExpressView.h"
#define NUM @"0123456789"
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
@interface JHCustomizeSendExpressView ()<UITextFieldDelegate>
@property(nonatomic,strong) UILabel *title;
@end

@implementation JHCustomizeSendExpressView
- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.keyboardType = UIKeyboardTypeASCIICapable;
        _textField.font = [UIFont systemFontOfSize:17];
        _textField.placeholder = @"请输入运单号";
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
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(10);
        // make.height.offset(0);
    }];
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
        make.height.offset(50);
    }];
    
    JHCustomLine *line = [JHUIFactory createLine];
    [chooseView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(chooseView.mas_bottom).offset(0);
        make.height.equalTo(@1);
        make.left.offset(15);
        make.right.offset(-10);
        
    }];
    
    UIImageView *indicator=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_confirm_right_jiantou"]];
    indicator.backgroundColor=[UIColor clearColor];
    [indicator setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [indicator setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    indicator.contentMode = UIViewContentModeScaleAspectFit;
    [chooseView addSubview:indicator];
    
    [indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(chooseView).offset(-15);
        make.centerY.equalTo(chooseView);
        
    }];
    
    UILabel  *expressTitle=[[UILabel alloc]init];
    expressTitle.text=@"物流公司";
    expressTitle.font=[UIFont fontWithName:kFontNormal size:14];
    expressTitle.backgroundColor=[UIColor clearColor];
    expressTitle.textColor=kColor333;
    expressTitle.numberOfLines = 1;
    expressTitle.textAlignment = NSTextAlignmentLeft;
    expressTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [chooseView addSubview:expressTitle];
    
    [expressTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(chooseView).offset(15);
        make.centerY.equalTo(chooseView);
        make.width.offset(70);
    }];
    
    _expressCompany=[[UILabel alloc]init];
    _expressCompany.text=@"123";
    _expressCompany.font=[UIFont fontWithName:kFontNormal size:16];
    _expressCompany.backgroundColor=[UIColor clearColor];
    _expressCompany.textColor=[CommHelp toUIColorByStr:@"#666666"];
    _expressCompany.numberOfLines = 1;
    _expressCompany.textAlignment = NSTextAlignmentLeft;
    _expressCompany.lineBreakMode = NSLineBreakByWordWrapping;
    [chooseView addSubview:_expressCompany];
    
    [_expressCompany mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(expressTitle);
        make.right.equalTo(indicator.mas_left).offset(-10);
        make.left.equalTo(expressTitle.mas_right).offset(10);
    }];
    
    UILabel  *codeTitle=[[UILabel alloc]init];
    codeTitle.text=@"物流单号";
    codeTitle.font=[UIFont fontWithName:kFontNormal size:14];
    codeTitle.backgroundColor=[UIColor clearColor];
    codeTitle.textColor=kColor333;
    codeTitle.numberOfLines = 1;
    codeTitle.textAlignment = NSTextAlignmentLeft;
    codeTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:codeTitle];
    
   
    
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(codeTitle.mas_right).offset(10);
        make.height.equalTo(@50);
        make.top.equalTo(chooseView.mas_bottom);
        make.right.equalTo(self).offset(-60);
        make.bottom.equalTo(self).offset(0);
    }];
    
    [codeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
           make.left.equalTo(@15);
            make.width.offset(70);
           make.centerY.equalTo(self.textField);
       }];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"icon_scan_code"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(scanCodeAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(18, 19));
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
//- (void) textFieldDidChange:(id) sender {
//
//   UITextField *_field = (UITextField *)sender;
// if (_field.text.length > 10){
//        _field.text = [_field.text substringWithRange:NSMakeRange(0, 10)];
//    }
//}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHANUM] invertedSet];
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    if ([string isEqualToString:filtered]) {
        if (textField == self.textField) {
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
