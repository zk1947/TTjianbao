//
//  JHAddCardViewController.m
//  TaodangpuAuction
//
//  Created by apple on 2019/11/7.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHAddCardViewController.h"

@interface JHAddCardViewController ()

@property (nonatomic, strong) UITextField *owerTextField;
@property (nonatomic, strong) UITextField *numberTextField;
@property (nonatomic, strong) UITextField *bankTextField;


@end

@implementation JHAddCardViewController

- (void)configNavBar {
    [self  initToolsBar];
    [self.navbar setTitle:@"添加银行卡"];
    [self.navbar addBtn:nil withImage:[UIImage imageNamed:@"返回.png"] withHImage:[UIImage imageNamed:@"返回.png"] withFrame:CGRectMake(0,0,44,44)];
    [self.navbar.comBtn addTarget :self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavBar];
    [self setupContentView];
    
}

- (void)setupContentView {
    UITextField *owerTF = [[UITextField alloc] init];
    owerTF.placeholder = @"请输入户名";
    owerTF.borderStyle = UITextBorderStyleLine;
    _owerTextField = owerTF;
    
    UITextField *numberTF = [[UITextField alloc] init];
    numberTF.placeholder = @"请输入卡号";
    numberTF.borderStyle = UITextBorderStyleLine;
    numberTF.keyboardType = UIKeyboardTypeNumberPad;
    _numberTextField = numberTF;
    
    UITextField *bankTF = [[UITextField alloc] init];
    bankTF.placeholder = @"请输入开户行";
    bankTF.borderStyle = UITextBorderStyleLine;
    _bankTextField = bankTF;
    
    UIButton *commitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [commitButton setTitle:@"添   加" forState:UIControlStateNormal];
    commitButton.backgroundColor = [UIColor orangeColor];
    commitButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [commitButton addTarget:self action:@selector(commitData) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_owerTextField];
    [self.view addSubview:_numberTextField];
    [self.view addSubview:_bankTextField];
    [self.view addSubview:commitButton];
    
    [_owerTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(StatusBarAddNavigationBarH + 100);
        make.width.equalTo(@(ScreenW - 40));
        make.height.equalTo(@50);
        make.centerX.equalTo(self.view);
    }];
    
    [_numberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.owerTextField.mas_bottom).with.offset(20);
        make.width.equalTo(self.owerTextField.mas_width);
        make.height.equalTo(self.owerTextField.mas_height);
        make.centerX.equalTo(self.owerTextField.mas_centerX);
    }];
    
    [_bankTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.numberTextField.mas_bottom).with.offset(20);
        make.width.equalTo(self.numberTextField.mas_width);
        make.height.equalTo(self.numberTextField.mas_height);
        make.centerX.equalTo(self.numberTextField.mas_centerX);
    }];
    
    [commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@50);
        make.top.equalTo(self.bankTextField.mas_bottom).with.offset(100);
        make.centerX.equalTo(self.bankTextField.mas_centerX);
    }];
}

- (void)commitData {
    if (!(_owerTextField.text && _owerTextField.text.length)) {
        [ShowMessage showMessage:@"请输入账户名称"];
        return;
    }
    
    if (!(_numberTextField.text && _numberTextField.text.length)) {
        [ShowMessage showMessage:@"请输入账号"];
        return;
    }
    
    if (!(_bankTextField.text && _bankTextField.text.length)) {
        [ShowMessage showMessage:@"请输入开户行"];
        return;
    }
    
    
    NSString *url = @"";
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"李惠" forKey:@"cardOwerName"];
    [params setValue:@"67848999366475893" forKey:@"cardNumber"];
    [params setValue:@"宁波银行" forKey:@"cardBankName"];

    [HttpRequestTool postWithURL:url Parameters:params requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        NSLog(@"上传成功");
        
        
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failureBlock:^(RequestModel *respondObject) {
        
        NSLog(@"上传失败");
        
        
        
    }];
}







@end
