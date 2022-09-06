//
//  JHForbidAccountViewController.m
//  TTjianbao
//  Created by jiang on 2019/10/24.
//  Copyright © 2019 Netease. All rights reserved.
//

#import"JHForbidAccountViewController.h"
#import"JHForbidAccountView.h"


@interface JHForbidAccountViewController ()
{
    JHForbidAccountView * view;
}
@end

@implementation JHForbidAccountViewController
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initToolsBar];
//    [self.navbar setTitle:@"填写禁封理由"];
    self.title = @"填写禁封理由";
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self  initContentView];
     [self requestInfo];
}

-(void)initContentView{
    
    view=[[JHForbidAccountView alloc]init];
    [view setCustomerId:self.customerId];
    [self.view addSubview:view];
    //
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
        make.bottom.equalTo(self.view).offset(0);
        make.left.right.equalTo(self.view);
        
    }];
}
-(void)requestInfo{

    [HttpRequestTool getWithURL:COMMUNITY_FILE_BASE_STRING(@"/bans/tags") Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        [view setReasonArr:respondObject.data];

    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        [SVProgressHUD dismiss];
    }];

    [SVProgressHUD show];
}

@end
