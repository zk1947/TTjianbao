//
//  JHTextField.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/30.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHTextField.h"

@implementation JHTextField

- (instancetype) initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = HEXCOLOR(0xEEEEEE);
        self.textColor = HEXCOLOR(0x999999);
        self.font = JHFont(12);
        self.placeholder = @"按编号，按名称搜索";
        
        self.leftView = [self leftViewExt];
        self.leftViewMode = UITextFieldViewModeAlways;
        self.returnKeyType = UIReturnKeySearch;
        [self setTintColor:HEXCOLOR(0xFEE100)];//光标颜色
        self.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.layer.cornerRadius = 15.f;
        [self addTarget:self action:@selector(textFieldDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
        [self addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    
    return self;
}

- (UIView *)leftViewExt
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 32, 30)];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dis_glasses"]];
    imgView.center = CGPointMake(16 + 5, 15.0);
    [view addSubview:imgView];
    return view;
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
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self endEditing:YES];
    return YES;
}

@end
