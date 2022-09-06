//
//  JHPersonIdentViewController.m
//  TTjianbao
//
//  Created by apple on 2019/11/12.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHPersonIdentViewController.h"
#import "JHWebViewController.h"
#import "JHSignViewController.h"
#import "JHCustomTextField.h"
#import "NSString+AES.h"
#import "NSObject+JHTools.h"
#import "CommHelp.h"
#import "TTjianbaoMarcoKeyword.h"

@interface JHPersonIdentViewController ()

@property (nonatomic, strong) UIButton *commitButton;

@property (nonatomic, strong) JHCustomTextField *userNameField;
@property (nonatomic, strong) JHCustomTextField *identNumberField;


@end

NSString *const userNamePlaceholder = @"请输入您的真实姓名";
NSString *const identNumberPlaceholder = @"请输入您的身份证号";


@implementation JHPersonIdentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = HEXCOLOR(0xF8F8F8);
    [self configNav];
    
    [self initUI];
    
}

- (void)initUI {
    UIView *backgroundView = [[UIView alloc] init];
    backgroundView.backgroundColor = [UIColor whiteColor];
    
    _userNameField = [[JHCustomTextField alloc] initWithLeftWith:70];
    _userNameField.leftText = @"真实姓名";
    _userNameField.placeholder = userNamePlaceholder;
    _userNameField.showBottomLine = YES;
   
    _identNumberField = [[JHCustomTextField alloc] initWithLeftWith:70];
    _identNumberField.leftText = @"身份证号";
    _identNumberField.placeholder = identNumberPlaceholder;
    _identNumberField.showBottomLine = NO;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(commitDataToServer) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"提交认证" forState:UIControlStateNormal];
    btn.backgroundColor = HEXCOLOR(0xFEE100);
    [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    _commitButton = btn;
    
    UIButton *preLookButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [preLookButton addTarget:self action:@selector(watchProtocolFile) forControlEvents:UIControlEventTouchUpInside];
    [preLookButton setTitle:@"预览协议范本" forState:UIControlStateNormal];
    [preLookButton setTitleColor:HEXCOLOR(0x235E96) forState:UIControlStateNormal];
    preLookButton.titleLabel.font = [UIFont fontWithName:kFontBoldPingFang size:13];
    
    [self.view addSubview:backgroundView];
    [backgroundView addSubview:_userNameField];
    [backgroundView addSubview:_identNumberField];
    [self.view addSubview:_commitButton];
    [self.view addSubview:preLookButton];
    
    [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
        make.top.equalTo(self.jhNavView.mas_bottom).with.offset(16);
        make.height.equalTo(@94);
    }];
    
    [_userNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(backgroundView).with.offset(15);
        make.right.equalTo(backgroundView).with.offset(-15);
        make.top.equalTo(backgroundView);
        make.height.equalTo(@(47 - 0.25));
    }];
    
    [_identNumberField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userNameField);
        make.bottom.equalTo(backgroundView);
        make.right.equalTo(self.userNameField);
        make.height.equalTo(self.userNameField);
    }];
    
    [_commitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(15);
        make.right.equalTo(self.view).with.offset(-15);
        make.bottom.equalTo(self.view).with.offset(-(UI.bottomSafeAreaHeight + 77));
        make.height.equalTo(@44);
    }];
    
    [preLookButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.commitButton.mas_bottom).with.offset(20);
        make.centerX.equalTo(self.commitButton);
        make.width.equalTo(@80);
        make.height.equalTo(@20);
    }];
    
    [self.view layoutIfNeeded];
    backgroundView.layer.cornerRadius = 4.f;
    backgroundView.layer.masksToBounds = YES;
    _commitButton.layer.cornerRadius = _commitButton.height/2.f;
    _commitButton.layer.masksToBounds = YES;
}

- (void)commitDataToServer {
    if (!(_userNameField && _userNameField.text.length)) {
        [UITipView showTipStr:@"请输入您的真实姓名"];
        return;
    }
    if (!(_identNumberField && _identNumberField.text.length)) {
        [UITipView showTipStr:@"请输入您的身份证号"];
        return;
    }
    if (![CommHelp judgeIdentityStringValid:_identNumberField.text]) {
        [UITipView showTipStr:@"请输入正确的身份证号"];
        return;
    }
    
    [SVProgressHUD show];
    NSString *url = COMMUNITY_FILE_BASE_STRING(@"/v1/contract/userCreate");
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:_userNameField.text forKey:@"name"];
    [params setValue:_identNumberField.text forKey:@"ident"];
    
    ///将参数转化成json字符串 然后进行加密
    NSString *paraJsonString = [NSObject convertJSONWithDic:params];
    NSString *paraMD5String = [paraJsonString aci_encryptAESWithKey:SIGN_AES_KEY iv:SIGN_AES_IV_KEY];
    NSLog(@"paraMD5String:---- %@", paraMD5String);
    NSLog(@"------%@", @{@"ept":paraMD5String});
    [HttpRequestTool postWithURL:url Parameters:@{@"ept":paraMD5String} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        NSLog(@"respondObject:--- %@\n%zd\n%@", respondObject.message,respondObject.code, respondObject.data);
        JHSignViewController *vc = [[JHSignViewController alloc] init];
        vc.checkStatus = JHCheckStatusCheckSuccess;
        [self.navigationController pushViewController:vc animated:YES];
        
    } failureBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        NSLog(@"respondObject:--- %@\n%zd\n%@", respondObject.message,respondObject.code, respondObject.data);
        [self toast:respondObject.message];
    }];
}

///查看协议范本
- (void)watchProtocolFile {
    JHWebViewController *webVC = [[JHWebViewController alloc] init];
    webVC.urlString = H5_BASE_STRING(@"/previewAgreementPerson.html");
    [self.navigationController pushViewController:webVC animated:YES];
}

- (void)toast:(NSString *)message {
    NSString *toastString = message ? message : @"认证失败";
    [self.view makeToast:toastString duration:1.0 position:CSToastPositionCenter];
}

- (void)configNav {
//    [self initToolsBar];
//    [self.navbar setTitle:@"个人实名认证"];
    self.title = @"个人实名认证";
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
}

@end
