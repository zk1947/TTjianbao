//
//  JHAddBankCardViewController.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/28.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHAddBankCardViewController.h"
#import "JHWithdrawViewController.h"
#import "JHStonePinMoneyDataModel.h"
#import "JHUIFactory.h"
#import "UITextField+PlaceHolderColor.h"

@interface JHAddBankCardViewController ()<UITextFieldDelegate>
{
    UITextField* nameField;
    UITextField* accountField;
    UITextField* bankField;
    JHWithdrawInfoModel* dataModel;
}

@end

@implementation JHAddBankCardViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //绘制
    self.view.backgroundColor = HEXCOLOR(0xF8F8F8);
//    [self setupToolBarWithTitle:@"添加银行卡"];
    self.title = @"添加银行卡";
    [self drawSubviews];
}

- (void)setShowData:(JHWithdrawInfoModel*)model
{
    dataModel = model;
}

#pragma mark - subviews
- (void)drawSubviews
{
    UIView* bgView = [[UIView alloc] init];
    bgView.backgroundColor = HEXCOLOR(0xFFFFFF);
    bgView.layer.cornerRadius = 4.0;
    bgView.layer.masksToBounds = YES;
    [self.view addSubview:bgView];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight+17);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(147);
    }];
    
    UILabel* nameLabel = [JHUIFactory createLabelWithTitle:@"户名" titleColor:HEXCOLOR(0x333333) font:JHFont(15) textAlignment:NSTextAlignmentLeft];
    [bgView addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView).offset(14);
        make.left.equalTo(bgView).offset(10);
    }];
    
    nameField = [[UITextField alloc] init];
    nameField.font = JHFont(15);
    nameField.textColor = HEXCOLOR(0x333333);
    nameField.placeholder = @"请输入您的户名";
    [bgView addSubview:nameField];
    [nameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(nameLabel.mas_right).offset(35);
        make.top.equalTo(nameLabel);
    }];
    
    JHCustomLine* line1 = [[JHCustomLine alloc] init];
    line1.color = HEXCOLOR(0xF0F0F0);
    [bgView addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(13);
        make.left.equalTo(nameLabel);
        make.right.equalTo(bgView).offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    UILabel* accountLabel = [JHUIFactory createLabelWithTitle:@"账号" titleColor:HEXCOLOR(0x333333) font:JHFont(15) textAlignment:NSTextAlignmentLeft];
    [bgView addSubview:accountLabel];
    [accountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1).offset(13);
        make.left.equalTo(line1);
    }];
    
    accountField = [[UITextField alloc] init];
    accountField.delegate = self;
    accountField.keyboardType = UIKeyboardTypeNumberPad;
    accountField.font = JHFont(15);
    accountField.textColor = HEXCOLOR(0x333333);
    accountField.placeholder = @"请输入您的账号";
    [bgView addSubview:accountField];
    [accountField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(accountLabel.mas_right).offset(35);
        make.top.equalTo(accountLabel);
    }];
    
    JHCustomLine* line2 = [[JHCustomLine alloc] init];
    line2.color = HEXCOLOR(0xF0F0F0);
    [bgView addSubview:line2];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(accountLabel.mas_bottom).offset(14);
        make.left.equalTo(accountLabel);
        make.right.equalTo(bgView).offset(-10);
        make.height.mas_equalTo(1);
    }];
    
    UILabel* bankLabel = [JHUIFactory createLabelWithTitle:@"开户行" titleColor:HEXCOLOR(0x333333) font:JHFont(15) textAlignment:NSTextAlignmentLeft];
    [bgView addSubview:bankLabel];
    [bankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line2).offset(14);
        make.left.equalTo(line2);
    }];
    
    bankField = [[UITextField alloc] init];
    bankField.font = JHFont(15);
    bankField.textColor = HEXCOLOR(0x333333);
    bankField.placeholder = @"请准确填写开户行信息";
    [bankField placeHolderColor:HEXCOLOR(0x999999)];
    [bgView addSubview:bankField];
    [bankField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bankLabel.mas_right).offset(20);
        make.top.equalTo(bankLabel);
    }];
    
    //开户行下增加红色示例
    UILabel* bankTipLabel = [JHUIFactory createJHLabelWithTitle:@"中国工商银行北京市雅宝路支行" titleColor:HEXCOLOR(0xFF4200) font:JHFont(13) textAlignment:NSTextAlignmentLeft preTitle:@"开户行示例："];
    bankTipLabel.numberOfLines = 0;
    [self.view addSubview:bankTipLabel];
    [bankTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bgView.mas_bottom).offset(10);
        make.left.equalTo(bgView).offset(10);
        make.right.equalTo(bgView).offset(-10);
    }];
    
    UIButton* addBtn = [JHUIFactory createThemeBtnWithTitle:@"添加" cornerRadius:44/2.0 target:self action:@selector(pressAddButton)];
    addBtn.titleLabel.font = JHFont(18);
    [self.view addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bankTipLabel.mas_bottom).offset(21);
        make.left.equalTo(self.view).offset(10);
        make.right.equalTo(self.view).offset(-10);
        make.height.mas_equalTo(44);
    }];
    
    //增加重要提示
    UIImageView* tipMark = [UIImageView new];
    [tipMark setImage:[UIImage imageNamed:@"add_card_tip_mark"]];
    [self.view addSubview:tipMark];
    [tipMark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(10);
        make.top.mas_equalTo(addBtn.mas_bottom).offset(14);
        make.size.mas_equalTo(15);
    }];
    
    UILabel* importantLabel = [JHUIFactory createJHLabelWithTitle:@"为避免提现失败，开户行需包含完整准确的支行信息，若不了解开户行信息，请致电银行了解后填写" titleColor:HEXCOLOR(0x333333) font:JHFont(13) textAlignment:NSTextAlignmentLeft preTitle:@"重要提示："];
    importantLabel.numberOfLines = 0;
    [self.view addSubview:importantLabel];
    [importantLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(addBtn.mas_bottom).offset(12);
        make.left.mas_equalTo(tipMark.mas_right).offset(5);
        make.right.equalTo(addBtn).offset(-5);
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (string.length == 0)
    {
        return YES;
    }
    
    if (textField == accountField)
    {
        return [self validateNumber:string];
    }
    return YES;
}

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

- (void)pressAddButton
{
    if([nameField.text length] <= 0)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入您的户名"];
    }
    else if([accountField.text length] <= 0)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入您的账户"];
    }
    else if([bankField.text length] <= 0)
    {
        [SVProgressHUD showInfoWithStatus:@"请输入开户行"];
    }
    else
    {
        [SVProgressHUD show];
        JH_WEAK(self)
        [kStonePinMoneyData requestAddBankcardWith:nameField.text cardNo:accountField.text bank:bankField.text response:^(id respData, NSString *errorMsg) {
            JH_STRONG(self)
            [SVProgressHUD dismiss];
            if(errorMsg)
                [SVProgressHUD showErrorWithStatus:errorMsg];
            else
            {
                [SVProgressHUD showSuccessWithStatus:@"添加成功"];
                [self backWhenAddBankSuccess];
            }
        }];
    }
}

- (void)backWhenAddBankSuccess
{
    NSArray* controllers = self.navigationController.viewControllers;
    NSInteger count = controllers.count;
    if(count > 1)
    {
        JHWithdrawViewController* page = [controllers objectAtIndex:count-2];
        page.shouldRefreshPage = YES;
        [self.navigationController popToViewController:page animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)backAction
{
//    [super back];
    for (UIViewController* vc in self.navigationController.viewControllers)
    {
        if ([vc isKindOfClass: NSClassFromString(@"JHStonePinMoneyViewController")])
        {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
