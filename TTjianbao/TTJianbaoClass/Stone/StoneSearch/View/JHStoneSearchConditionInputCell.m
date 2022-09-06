//
//  JHStoneSearchConditionInputCell.m
//  TTjianbao
//
//  Created by apple on 2020/2/28.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHStoneSearchConditionInputCell.h"

@implementation JHStoneSearchConditionInputCell

-(void)addSelfSubViews
{
    _lowPriceTf = [self cellTextFieldWithPlaceholder:@"最低价"];
    [_lowPriceTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.top.equalTo(self.contentView);
        make.right.equalTo(self.contentView.mas_centerX).offset(-16);
    }];
    
    _heighPriceTf = [self cellTextFieldWithPlaceholder:@"最高价"];;
    [_heighPriceTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.top.equalTo(self.contentView);
        make.left.equalTo(self.contentView.mas_centerX).offset(16);
    }];

    [_lowPriceTf addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    [_heighPriceTf addTarget:self action:@selector(textFieldTextChange:) forControlEvents:UIControlEventEditingChanged];
    
    
    UIView *lineView = [UIView jh_viewWithColor:RGB(206, 206, 206) addToSuperview:self.contentView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(20, 1));
    }];
}

-(void)textFieldTextChange:(UITextField *)textField{
    if([textField.text hasPrefix:@"0"] && textField.text.length > 1)
    {
        textField.text = [textField.text substringFromIndex:1];
    }
    if(_inputChangeBlock)
    { _inputChangeBlock(self.lowPriceTf.text,self.heighPriceTf.text);
    }
}

- (UITextField*)cellTextFieldWithPlaceholder:(NSString *)placeholder
{
    UITextField* textField = [[UITextField alloc] init];
    textField.textAlignment = NSTextAlignmentCenter;
    textField.keyboardType = UIKeyboardTypeNumberPad;
    textField.font = JHFont(12);
    textField.textColor = HEXCOLOR(0x333333);
    textField.placeholder = placeholder;
    [self.contentView addSubview:textField];
    textField.backgroundColor = RGB(244, 244, 244);
    [textField jh_cornerRadius:[JHStoneSearchConditionInputCell itemSize].height/2.0];
    return textField;
}

+(CGSize)itemSize
{
    return CGSizeMake(276, 34.0);
}
@end
