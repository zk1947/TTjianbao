//
//  JHOrderApplyReturnViewController.m
//  TTjianbao
//
//  Created by jiang on 2019/10/17.
//  Copyright © 2019 Netease. All rights reserved.
//

#import "JHOrderApplyReturnViewController.h"
#import "JHOrderApplyReturnView.h"
#import "JHWebViewController.h"
#import "JHOrderReturnMode.h"
#import "JHQYChatManage.h"

@interface JHOrderApplyReturnViewController ()
{
     JHOrderApplyReturnView * orderView;
}
@end

@implementation JHOrderApplyReturnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initToolsBar];
//    [self.navbar setTitle:@"退货退款"];
    self.title = @"退货退款";
//    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
//    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [self  initContentView];
    [self requestInfo];
}

-(void)initContentView{
    
    orderView=[[JHOrderApplyReturnView alloc]init];
    orderView.orderMode=self.orderMode;
    [self.view addSubview:orderView];
  //
    [orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
        make.bottom.equalTo(self.view.mas_bottom).offset(-UI.bottomSafeAreaHeight - 5.f);
        make.left.right.equalTo(self.view);
        
    }];
    
    @weakify(self);
    orderView.completeBlock = ^(id obj) {
    @strongify(self);
    NSDictionary * dic =(NSDictionary*)obj;
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/orderRefund/apply/auth") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
    [[UIApplication sharedApplication].keyWindow makeToast:@"提交成功" duration:1.0 position:CSToastPositionCenter];
    [[NSNotificationCenter defaultCenter] postNotificationName:ORDERSTATUSCHANGENotifaction object:nil];//
    [self.navigationController popViewControllerAnimated:NO];
    [[JHQYChatManage shareInstance] showShopChatWithViewcontroller:JHRootController.homeTabController  anchorId:self.orderMode.sellerCustomerId defaultText:[@"我发起了退货申请，请及时处理，订单号:" stringByAppendingString:OBJ_TO_STRING(self.orderMode.orderCode)]];
            
    } failureBlock:^(RequestModel *respondObject) {
    [SVProgressHUD dismiss];
    [[UIApplication sharedApplication].keyWindow makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        }];
    [SVProgressHUD show];
        
    };
}
-(void)requestInfo{
    
    [HttpRequestTool getWithURL:[FILE_BASE_STRING(@"/orderRefund/preApply/auth?orderId=") stringByAppendingString:OBJ_TO_STRING(self.orderId)] Parameters:nil successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        orderView.orderReturnMode = [JHOrderReturnMode mj_objectWithKeyValues: respondObject.data[@"refundAmountVo"]];
        [orderView setReasonArr:respondObject.data[@"reasons"]];
        
    } failureBlock:^(RequestModel *respondObject) {
        [self.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        [SVProgressHUD dismiss];
    }];
    
    [SVProgressHUD show];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
