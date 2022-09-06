//
//  JHOrderSendExpressView.m
//  TTjianbao
//
//  Created by jiangchao on 2020/5/22.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOrderSendExpressView.h"
#define NUM @"0123456789"
#define ALPHA @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#define ALPHANUM @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
@interface JHOrderSendExpressView ()<UITextFieldDelegate>
@property(nonatomic,strong) UILabel *title;
@end

@implementation JHOrderSendExpressView
- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, ScreenW-80, 50)];
        _textField.keyboardType = UIKeyboardTypeASCIICapable;
        _textField.font = [UIFont systemFontOfSize:17];
        _textField.placeholder = @"请输入运单号";
        _textField.delegate = self;
//          [_textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}
-(void)setSubViews{
    
    _title=[[UILabel alloc]init];
    _title.text=@"";
    _title.font=[UIFont fontWithName:kFontMedium size:15];
    _title.backgroundColor=[UIColor clearColor];
    _title.textColor=kColor333;
    _title.numberOfLines = 1;
    _title.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _title.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:_title];
    
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.top.equalTo(self).offset(0);
         make.height.offset(0);
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
    expressTitle.text=@"选择快递公司";
    expressTitle.font=[UIFont fontWithName:kFontNormal size:14];
    expressTitle.backgroundColor=[UIColor clearColor];
    expressTitle.textColor=kColor333;
    expressTitle.numberOfLines = 1;
    expressTitle.textAlignment = UIControlContentHorizontalAlignmentCenter;
    expressTitle.lineBreakMode = NSLineBreakByWordWrapping;
    [chooseView addSubview:expressTitle];
    
    [expressTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(chooseView).offset(15);
        make.centerY.equalTo(chooseView);
    }];
    
    _expressCompany=[[UILabel alloc]init];
    _expressCompany.text=@"";
    _expressCompany.font=[UIFont fontWithName:kFontNormal size:16];
    _expressCompany.backgroundColor=[UIColor clearColor];
    _expressCompany.textColor=[CommHelp toUIColorByStr:@"#666666"];
    _expressCompany.numberOfLines = 1;
    _expressCompany.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _expressCompany.lineBreakMode = NSLineBreakByWordWrapping;
    [chooseView addSubview:_expressCompany];
    
    [_expressCompany mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(expressTitle);
        make.right.equalTo(indicator.mas_left).offset(-10);
    }];
    [self addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.height.equalTo(@40);
        make.top.equalTo(chooseView.mas_bottom);
        make.right.equalTo(self).offset(-60);
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
    
    JHCustomLine *line = [JHUIFactory createLine];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textField.mas_bottom).offset(0);
        make.height.equalTo(@1);
        make.left.offset(15);
        make.right.offset(0);
        
    }];
    
    UIView * addressDetailView=[[UIView alloc]init];
    // addressDetailView.backgroundColor=[UIColor yellowColor];
    //  addressDetailView.backgroundColor=[UIColor redColor];
    [self addSubview:addressDetailView];
    [addressDetailView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(90);
        make.bottom.equalTo(self).offset(0);
    }];
    UIImageView *icon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_confirm_location_logo"]];
    // icon.backgroundColor=[UIColor greenColor];
    [icon setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [icon setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    icon.contentMode = UIViewContentModeScaleAspectFit;
    [addressDetailView addSubview:icon];
    
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressDetailView).offset(10);
        make.centerY.equalTo(addressDetailView).offset(-10);
        make.size.mas_equalTo(CGSizeMake(14, 16));
    }];
    UILabel *tip=[[UILabel alloc]init];
    tip.font=[UIFont fontWithName:kFontNormal size:11];
    tip.textColor=kColor999;
    tip.numberOfLines = 1;
    tip.text=@"寄回";
    tip.textAlignment = UIControlContentHorizontalAlignmentCenter;
    tip.lineBreakMode = NSLineBreakByWordWrapping;
    [addressDetailView addSubview:tip];
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(icon);
        make.top.equalTo(icon.mas_bottom).offset(5);
        
    }];
    
    _name=[[UILabel alloc]init];
    _name.font=[UIFont fontWithName:kFontMedium size:14];
    _name.textColor=kColor333;
    _name.numberOfLines = 1;
    _name.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _name.lineBreakMode = NSLineBreakByWordWrapping;
    [addressDetailView addSubview:_name];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(icon.mas_right).offset(25);
        make.centerY.equalTo(addressDetailView).offset(-12);
        
    }];
    _phoneNum=[[UILabel alloc]init];
    _phoneNum.font=[UIFont fontWithName:kFontMedium size:14];
    _phoneNum.backgroundColor=[UIColor clearColor];
    _phoneNum.textColor=kColor333;
    _phoneNum.numberOfLines = 1;
    _phoneNum.textAlignment = NSTextAlignmentLeft;
    _phoneNum.lineBreakMode = NSLineBreakByWordWrapping;
    [addressDetailView addSubview:_phoneNum];
    [_phoneNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_name.mas_right).offset(10);
         make.right.equalTo(addressDetailView.mas_right).offset(-10);
        make.centerY.equalTo(_name);
        
    }];
    
    _address=[[UILabel alloc]init];
    _address.font=[UIFont fontWithName:kFontNormal size:12];
    _address.backgroundColor=[UIColor clearColor];
    _address.textColor=kColor333;
    _address.numberOfLines = 2;
    _address.textAlignment = UIControlContentHorizontalAlignmentCenter;
    _address.lineBreakMode = NSLineBreakByWordWrapping;
    [addressDetailView addSubview:_address];
    [_address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_name);
        make.right.equalTo(addressDetailView.mas_right).offset(-10);
        make.top.equalTo(_name.mas_bottom).offset(5);
    }];
}
-(void)chooseExpress{
    
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
/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
