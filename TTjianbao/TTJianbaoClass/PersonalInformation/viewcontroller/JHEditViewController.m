//
//  JHEditViewController.m
//  TTjianbao
//
//  Created by yaoyao on 2018/12/17.
//  Copyright © 2018年 Netease. All rights reserved.
//

#import "JHEditViewController.h"

#import "UserInfoRequestManager.h"

@interface JHEditViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;

@end

@implementation JHEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self  initToolsBar];
//    [self.navbar setTitle:@"修改昵称"];
    self.title = @"修改昵称"; //背景颜色不一致
    [self initRightButtonWithName:@"完成" action:@selector(actionSave:)];
    [self.jhRightButton setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
    self.jhRightButton.backgroundColor = kGlobalThemeColor;
    self.jhRightButton.layer.cornerRadius = 4;
    self.jhRightButton.layer.masksToBounds = YES;
    [self.jhRightButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(55);
        make.right.equalTo(self.jhNavView).offset(-10);
    }];
//    self.navbar.ImageView.hidden = YES;
//    self.navbar.backgroundColor = HEXCOLOR(0xf7f7f7);
//    self.view.backgroundColor = HEXCOLOR(0xf7f7f7);
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.navbar addrightBtn:@"完成" withImage:nil  withHImage:nil withFrame:CGRectMake(ScreenW-65,0,55,25)];
//    [self.navbar.rightBtn addTarget:self action:@selector(actionSave:) forControlEvents:UIControlEventTouchUpInside];
//    self.navbar.rightBtn.backgroundColor = kGlobalThemeColor;
//    self.navbar.rightBtn.layer.cornerRadius = 4;
//    self.navbar.rightBtn.layer.masksToBounds = YES;
//    [self.navbar.rightBtn setTitleColor:HEXCOLOR(0x222222) forState:UIControlStateNormal];
    
    self.textField.delegate = self;
    self.textField.text = self.nickname;
    self.topHeight.constant = UI.statusAndNavBarHeight+10;
    self.textField.placeholder = self.nickname;
    
//    if ([UserInfoRequestManager sharedInstance].user.nameModifyLimit == 0) {
//        self.textField.enabled = NO;
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)actionSave:(id)sender {
    

    if (!self.textField.text || self.textField.text.length == 0) {
    
        [self.view makeToast:@"请输入昵称" duration:1. position:CSToastPositionCenter];
        return;
    }
    
    if ( self.textField.text.length > 10) {
        
        [self.view makeToast:@"昵称太长啦" duration:1. position:CSToastPositionCenter];
        return;
    }

    if ([self.textField.text isEqualToString:self.nickname]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:@"确定修改吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"取消" style: UIAlertActionStyleDefault handler:nil]];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [HttpRequestTool putWithURL:FILE_BASE_STRING(@"/auth/customer/customer") Parameters:@{@"name":self.textField.text} requestSerializerType:RequestSerializerTypeHttp successBlock:^(RequestModel *respondObject) {
            [UserInfoRequestManager sharedInstance].user.name = self.textField.text;
            [SVProgressHUD showSuccessWithStatus:@"修改成功"];
            [[UserInfoRequestManager sharedInstance] getUserInfo]; //更新可修改昵称次数
            [self.navigationController popViewControllerAnimated:YES];
        } failureBlock:^(RequestModel *respondObject) {
            [SVProgressHUD showErrorWithStatus:respondObject.message];
            
        }];
    }]];

    [self presentViewController:alertVc animated:YES completion:nil];

    
    
    
    
}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    if (textField.text.length>=10) {
//        if (string.length>0) {
//            [self.view makeToast:@"昵称太长啦" duration:1. position:CSToastPositionCenter];
//            return NO;
//        }
//    }
//    return YES;
//}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//
//    if ([string length]>0&&range.location>=10) {
//        return NO;
//    }
//    if(string.length == 1)
//    {
//        int asciiCode = [string characterAtIndex:0];
//        if ((asciiCode>=65&&asciiCode<=90)||(asciiCode>=97&&asciiCode<=122)||(asciiCode>=48&&asciiCode<=57)) {
//            return YES;
//        }
//        else
//        {
//            if( asciiCode > 0x4e00 && asciiCode < 0x9fff)//19968,40959
//            {
//                return YES;
//
//            }else {
//
//                [self.view makeToast:@"非法字符" duration:1. position:CSToastPositionTop];
//                return NO;
//            }
//
//        }
//    }
//
//    return YES;
//}
@end
