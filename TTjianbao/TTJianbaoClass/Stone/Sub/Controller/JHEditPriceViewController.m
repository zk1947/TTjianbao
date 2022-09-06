//
//  JHEditPriceViewController.m
//  TTjianbao
//
//  Created by yaoyao on 2019/12/9.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHEditPriceViewController.h"
#import "JHAnchorBreakPaperItemView.h"
#import "JHMainLiveSmartModel.h"

@interface JHEditPriceViewController ()
@property (nonatomic, strong) JHAnchorBreakPaperItemView *priceText;
@end

@implementation JHEditPriceViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self makeNav];
    self.priceText = [JHAnchorBreakPaperItemView new];
    [self.priceText makeUIPrice];
    self.priceText.breakPrice.textField.text = self.price;
    self.priceText.breakPrice.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.priceText];
     
      [self.priceText mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.equalTo(self.jhNavView.mas_bottom).offset(10);
          make.trailing.offset(-10);
          make.leading.equalTo(self.view).offset(10);
      }];
    
    UIButton *submitBtn = [JHUIFactory createThemeBtnWithTitle:@"确认修改" cornerRadius:22 target:self action:@selector(finshAction)];
    [self.view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceText.mas_bottom).offset(50);
        make.leading.equalTo(self.view).offset(40);
        make.trailing.equalTo(self.view).offset(-40);
        make.height.equalTo(@(44));
        
    }];
}

- (void)makeNav
{
    self.view.backgroundColor = HEXCOLOR(0xf7f7f7);
//    [self initToolsBar];
//    [self.navbar setTitle:@"修改价格"];
    self.title = @"修改价格";
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)finshAction {
    
    [JHMainLiveUpdatePriceReqModel requestWithStoneId:self.stoneId price:self.priceText.breakPrice.textField.text flag:1 finish:^(NSString *errorMsg) {
        if(errorMsg){
            [SVProgressHUD showErrorWithStatus:errorMsg];
        } else {
            [SVProgressHUD showSuccessWithStatus:@"发送成功"];
            if (self.baseFinishBlock) {
                self.baseFinishBlock(self.priceText.breakPrice.textField.text);
            }
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        
    }];
}
@end
