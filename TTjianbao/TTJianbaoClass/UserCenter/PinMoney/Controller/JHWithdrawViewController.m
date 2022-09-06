//
//  JHWithdrawViewController.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/28.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHWithdrawViewController.h"
#import "JHAddBankCardViewController.h"
#import "JHStonePinMoneyViewController.h"
#import "JHBankCardManagerViewController.h"
#import "JHWithdrawSuccessViewController.h"
#import "JHUIFactory.h"
#import "NSString+Extension.h"
#import "UIImage+JHColor.h"
#import "UIView+JHGradient.h"


@interface JHWithdrawViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *topTipView;
@property (nonatomic, strong) UIView *moneyView;
@property (nonatomic, strong) UIView *backCardView;

@property (nonatomic, strong) UILabel *bankLabel;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *branceNameLabel;
@property (nonatomic, strong) UITextField *moneyField;
@property (nonatomic, strong) UILabel *tipLabel;    ///最多可提现
@property (nonatomic, strong) UIButton *submitBtn;
@end

@implementation JHWithdrawViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现申请";
    self.view.backgroundColor = HEXCOLOR(0xF8F8F8);
    // 请求数据
    [self requestData];
    // 初始化subView
    [self setupSubviews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if(self.shouldRefreshPage) {
        [self requestData];
    }
}

#pragma mark - request

- (void)requestData {
    [SVProgressHUD show];
    JH_WEAK(self)
    [kStonePinMoneyData requestWithdrawInfoWith:@"" type:@"" money:self.withdrawableText response:^(id respData, NSString *errorMsg) {
        JH_STRONG(self)
        [SVProgressHUD dismiss];
        if(errorMsg) {
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }
        else {
            [self refreshSubView:respData];
        }
    }];
}

- (void)requestApply {
    if(self.moneyField.text.floatValue > _withdrawableText.floatValue){
        [SVProgressHUD showSuccessWithStatus:@" 提现金额不能大于账户金额"];
        return;
    }
    
    [SVProgressHUD show];
    JH_WEAK(self)
    [kStonePinMoneyData requestWithdrawApplyWith:@"" type:@"" money:self.moneyField.text response:^(id respData, NSString *errorMsg) {
        JH_STRONG(self)
        [SVProgressHUD dismiss];
        if(errorMsg) {
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }
        else
        {
            [SVProgressHUD showSuccessWithStatus:@"提现成功"];
            [self.navigationController pushViewController:[JHWithdrawSuccessViewController new] animated:YES];
            //            [self backWhenWithdrawSuccess];
        }
    }];
}

#pragma mark - subviews

- (void)setupSubviews {
    [self setupTopSubView];
    [self setupMoneySubView];
    [self setupBankCardSubview];
    [self setupSubmitSubview];
}

- (void)setupTopSubView {
    
    UIView *topTipView = [UIView new];
    topTipView.backgroundColor = HEXCOLOR(0xFFFEFC);
    topTipView.layer.cornerRadius = 5.0;
    topTipView.layer.masksToBounds = YES;
    [self.view addSubview:topTipView];
    [topTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(UI.statusAndNavBarHeight+10.f);
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-12.f);
        make.height.mas_equalTo(41.f);
    }];
    
    UIImageView *idCardTipIcon = [[UIImageView alloc] init];
    idCardTipIcon.image = [UIImage imageNamed:@"icon_realName_idCard"];
    
    [topTipView addSubview:idCardTipIcon];
    [idCardTipIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(topTipView);
        make.size.mas_equalTo(16.f);
        make.left.mas_equalTo(12.f);
    }];
    
    UILabel *idCardSubTiplabel = [[UILabel alloc] init];
    idCardSubTiplabel.text = @"账户信息已加密处理，仅用于提现";
    idCardSubTiplabel.numberOfLines = 1;
    idCardSubTiplabel.textAlignment = NSTextAlignmentLeft;
    idCardSubTiplabel.lineBreakMode = NSLineBreakByWordWrapping;
    idCardSubTiplabel.font = [UIFont boldSystemFontOfSize:12.f];
    idCardSubTiplabel.textColor = HEXCOLOR(0xFF999999);
    
    [topTipView addSubview:idCardSubTiplabel];
    [idCardSubTiplabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(idCardTipIcon);
        make.left.mas_equalTo(idCardTipIcon.mas_right).mas_offset(1);
    }];
    
    self.topTipView = topTipView;
}

- (void)setupBankCardSubview {
    
    self.backCardView = [[UIView alloc] init];
    self.backCardView.backgroundColor = HEXCOLOR(0xFFFEFC);
    self.backCardView.layer.cornerRadius = 5.0;
    self.backCardView.layer.masksToBounds = YES;
    [self.backCardView  addGestureRecognizer:[[UITapGestureRecognizer alloc]  initWithTarget:self action:@selector(backCardAction)]];
    
    [self.view addSubview:self.backCardView];
    [self.backCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.moneyView.mas_bottom).mas_offset(10.f);
        make.left.right.equalTo(self.topTipView);
        make.height.mas_equalTo(151.f);
    }];
    
    UILabel *getBackCardTag = [JHUIFactory createLabelWithTitle:@"提现到卡" titleColor:HEXCOLOR(0x333333) font:JHBoldFont(18) textAlignment:NSTextAlignmentLeft];
    [self.backCardView addSubview:getBackCardTag];
    [getBackCardTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(12.f);
        make.height.mas_equalTo(25.f);
    }];
    
    UIView *backCardBGView = [[UIView alloc] init];
    [backCardBGView jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFFF6F6F6),HEXCOLOR(0xFFFFFFFF)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
    backCardBGView.layer.borderWidth = 0.5;
    backCardBGView.layer.borderColor = HEXCOLOR(0xFFDDDDDD).CGColor;
    backCardBGView.layer.cornerRadius = 5;
    
    [self.backCardView addSubview:backCardBGView];
    [backCardBGView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(getBackCardTag.mas_bottom).mas_offset(10.f);
        make.left.mas_equalTo(12.f);
        make.right.mas_equalTo(-12.f);
        make.height.mas_equalTo(92.f);
    }];
    
    UIImageView *bankCardIconIV = [UIImageView jh_imageViewWithImage:[UIImage imageNamed:@"icon_bank_card_tip"] addToSuperview:backCardBGView];
    //    bankCardIconIV.backgroundColor = UIColor.redColor;
    
    [backCardBGView addSubview:bankCardIconIV];
    [bankCardIconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(backCardBGView);
        make.left.mas_equalTo(12.f);
        make.size.mas_equalTo(CGSizeMake(26, 19));
    }];
    
    UILabel *bankCard = [JHUIFactory createLabelWithTitle:@"" titleColor:HEXCOLOR(0xFF333333) font:JHFont(16) textAlignment:NSTextAlignmentLeft];
    [backCardBGView addSubview:bankCard];
    [bankCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(12.f);
        make.left.mas_equalTo(bankCardIconIV.mas_right).mas_offset(12.f);
        make.right.mas_equalTo(-12.f);
    }];
    self.bankLabel = bankCard;
    
    UILabel *bankTag = [JHUIFactory createLabelWithTitle:@"" titleColor:HEXCOLOR(0xFF999999) font:JHFont(12) textAlignment:NSTextAlignmentLeft];
    [backCardBGView addSubview:bankTag];
    [bankTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bankCard.mas_bottom).offset(6.f);
        make.left.equalTo(bankCard);
    }];
    self.branceNameLabel = bankTag;
    
    UILabel *nameTag = [JHUIFactory createLabelWithTitle:@"" titleColor:HEXCOLOR(0xFF999999) font:JHFont(13) textAlignment:NSTextAlignmentLeft];
    [backCardBGView addSubview:nameTag];
    [nameTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(bankTag.mas_bottom).offset(6);
        make.left.equalTo(bankTag);
    }];
    self.userNameLabel = nameTag;
    
    UIImageView *arrowsIconIV = [UIImageView jh_imageViewWithImage:[UIImage imageNamed:@"icon_banckCard_arrow"] addToSuperview:backCardBGView];
    [backCardBGView addSubview:arrowsIconIV];
    [arrowsIconIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(backCardBGView);
        make.right.mas_equalTo(-12.f);
        make.left.mas_equalTo(bankTag.mas_right).mas_equalTo(12.f);
        make.size.mas_equalTo(CGSizeMake(18, 18));
    }];
}

- (void)setupMoneySubView {
    self.moneyView = [[UIView alloc] init];
    self.moneyView.backgroundColor = HEXCOLOR(0xFFFEFC);
    self.moneyView.layer.cornerRadius = 5.0;
    self.moneyView.layer.masksToBounds = YES;
    [self.view addSubview:self.moneyView];
    
    [self.moneyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.topTipView.mas_bottom).offset(10.f);
        make.left.right.equalTo(self.topTipView);
        make.height.mas_equalTo(125.f);
    }];
    
    UILabel *getMoneyTag = [JHUIFactory createLabelWithTitle:@"提现金额" titleColor:HEXCOLOR(0x333333) font:JHBoldFont(18) textAlignment:NSTextAlignmentLeft];
    
    [self.moneyView addSubview:getMoneyTag];
    [getMoneyTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyView).offset(10.f);
        make.left.equalTo(self.moneyView).offset(12.f);
        make.height.mas_equalTo(25.f);
    }];
    
    UILabel *unitTag = [JHUIFactory createLabelWithTitle:@"(元)" titleColor:HEXCOLOR(0xFF666666) font:JHFont(13) textAlignment:NSTextAlignmentLeft];
    
    [self.moneyView addSubview:unitTag];
    [unitTag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(15.f);
        make.left.mas_equalTo(getMoneyTag.mas_right);
    }];
    
    self.moneyField = [[UITextField alloc] init];
    self.moneyField.delegate = self;
    self.moneyField.keyboardType = UIKeyboardTypeDecimalPad;
    self.moneyField.font = JHFont(18);
    self.moneyField.textColor = HEXCOLOR(0xFC4200);
    //    self.moneyField.text = @"0";
    self.moneyField.placeholder = @"请输入提现金额";
    [self.moneyField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.moneyView addSubview:self.moneyField];
    [self.moneyField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(getMoneyTag.mas_left);
        make.top.mas_equalTo(getMoneyTag.mas_bottom).offset(18.f);
    }];
    
    JHCustomLine *line = [[JHCustomLine alloc] init];
    [self.moneyView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.moneyField.mas_bottom).offset(6);
        make.left.equalTo(getMoneyTag.mas_left);
        make.right.equalTo(self.moneyView).offset(-15);
        make.height.mas_equalTo(1);
    }];
    
    self.tipLabel = [JHUIFactory createLabelWithTitle:@"最多可提现0元" titleColor:HEXCOLOR(0x999999) font:JHFont(12) textAlignment:NSTextAlignmentLeft];
    [self.moneyView addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(line.mas_bottom).offset(12.f);
        make.left.equalTo(getMoneyTag.mas_left);
        make.bottom.equalTo(self.moneyView).offset(-11.f);
    }];
    
    UIButton *getBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [getBtn setTitle:@"全部提现" forState:UIControlStateNormal];
    getBtn.titleLabel.font = JHFont(12);
    [getBtn setTitleColor:HEXCOLOR(0x235E96) forState:UIControlStateNormal];
    [getBtn addTarget:self action:@selector(pressGetButton) forControlEvents:UIControlEventTouchUpInside];
    [self.moneyView addSubview:getBtn];
    
    [getBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.moneyField);
        make.right.mas_equalTo(line);
    }];
}

-(void)setupSubmitSubview {
    UIButton *submitBtn = [JHUIFactory createThemeBtnWithTitle:@"立即提现" cornerRadius:44/2.0 target:self action:@selector(pressSubmitButton)];
    submitBtn.titleLabel.font = JHFont(18);
    submitBtn.enabled = NO;
    submitBtn.alpha = 0.5;
    [submitBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100),HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(0, 1)];
    [self.view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.backCardView.mas_bottom).mas_offset(20.f);
        make.left.equalTo(self.view).offset(12);
        make.right.equalTo(self.view).offset(-12);
        make.height.mas_equalTo(44);
    }];
    self.submitBtn = submitBtn;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)backCardAction {
    JHBankCardManagerViewController *vc = [JHBankCardManagerViewController new];
    @weakify(self)
    [vc setBankCardManagerBlock:^(JHBankCardModel * _Nonnull bankCardModel) {
        @strongify(self)
        [self refreshSubView:[self modelConvert:bankCardModel]];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (JHWithdrawInfoModel *)modelConvert:(JHBankCardModel *)bankCardModel {
    JHWithdrawInfoModel *withdrawInfo = [JHWithdrawInfoModel new];
    withdrawInfo.accountNo = bankCardModel.accountNo;   ///(string, optional): 银行卡号 ,
    withdrawInfo.bankBranch = bankCardModel.bankBranch;     ///(string, optional): 银行支行名 ,
    withdrawInfo.bankName = bankCardModel.bankName;     ///(string, optional): 银行名 ,
    withdrawInfo.cardType = bankCardModel.bankType;     /// 银行卡类型
    return withdrawInfo;
}

- (void)refreshSubView:(JHWithdrawInfoModel*)withdrawInfo {
    if(withdrawInfo.accountNo.length>4) {
        self.bankLabel.text = [NSString stringWithFormat:@"%@ %@ (****%@)", withdrawInfo.bankName,withdrawInfo.cardType,[withdrawInfo.accountNo substringWithRange:NSMakeRange(withdrawInfo.accountNo.length-4, 4)]];
    }
    
    self.branceNameLabel.text = withdrawInfo.bankBranch;
    
    NSString *realName =  withdrawInfo.accountName;
    if (realName.length <= 1) return;
    self.userNameLabel.text = [realName stringByReplacingCharactersInRange:NSMakeRange(0, realName.length-1) withString:[realName returnCiphertext:realName.length-1]];
    
    _withdrawableText = [NSString stringWithFormat:@"%@", withdrawInfo.withdrawMoney];
    self.tipLabel.text = [NSString stringWithFormat:@"最多可提现%@元", withdrawInfo.withdrawMoney];
}

#pragma mark - UITextFieldDelegate
- (void)textFieldChanged:(UITextField *)field {
    
    if([field.text length] <= 0) {
        //        field.text = @"0";
        self.submitBtn.enabled = NO;
        self.submitBtn.alpha = 0.5;
    }else {
        self.submitBtn.enabled = YES;
        self.submitBtn.alpha = 1.0;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length == 0) {
        return YES;
    }
    
    if (textField == self.moneyField) {
        NSString *moneyStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        return [NSString validateMoney:moneyStr];
    }
    return YES;
}

#pragma mark - event
- (void)pressGetButton {
    self.moneyField.text = _withdrawableText;
    self.submitBtn.enabled = YES;
    self.submitBtn.alpha = 1.0;
}

- (void)pressSubmitButton {
    [self requestApply];
}

- (void)gotoAddBankCard:(JHWithdrawInfoModel*)withdrawInfo {
    JHAddBankCardViewController* addBank = [JHAddBankCardViewController new];
    [addBank setShowData:withdrawInfo];
    [self.navigationController pushViewController:addBank animated:YES];
}

- (void)backWhenWithdrawSuccess {
    NSArray* controllers = self.navigationController.viewControllers;
    NSInteger count = controllers.count;
    if(count > 1) {
        JHStonePinMoneyViewController* page = [controllers objectAtIndex:count-2];
        page.shouldRefreshPage = YES;
        [self.navigationController popToViewController:page animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
