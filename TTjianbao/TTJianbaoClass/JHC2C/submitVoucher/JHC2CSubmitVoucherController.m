//
//  JHC2CSubmitVoucherController.m
//  TTjianbao
//
//  Created by jiangchao on 2021/6/16.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHC2CSubmitVoucherController.h"
#import "JHSubmitVoucherView.h"
#import "JHWebViewController.h"
#import "JHOrderReturnMode.h"
#import "JHQYChatManage.h"

@interface JHC2CSubmitVoucherController ()
{
    JHSubmitVoucherView * orderView;
}
@end

@implementation JHC2CSubmitVoucherController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    [self initToolsBar];
    self.title = @"提交凭证";
    //    [self.navbar addBtn:nil withImage:kNavBackBlackImg withHImage:kNavBackBlackImg withFrame:CGRectMake(0,0,44,44)];
    //    [self.navbar.comBtn addTarget :self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [JHTracking trackEvent:@"appPageView" property:@{@"page_name":@"集市提交介入凭证买家页"}];
    [self  initContentView];
    [self requestInfo];
}

-(void)initContentView{
    
    orderView=[[JHSubmitVoucherView alloc]init];
    orderView.orderId=self.orderId;
    orderView.workOrderId=self.workOrderId;
    [self.view addSubview:orderView];
    //
    [orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(UI.statusAndNavBarHeight);
        make.bottom.equalTo(self.view).offset(0);
        make.left.right.equalTo(self.view);
        
    }];
    
    @weakify(self);
    orderView.completeBlock = ^(id obj) {
        @strongify(self);
        NSDictionary * dic =(NSDictionary*)obj;
        [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/marketOrder/auth/commitPlatformHandler") Parameters:dic requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
            [SVProgressHUD dismiss];
            
            if (self.successBlock) {
                self.successBlock();
            }
            [[UIApplication sharedApplication].keyWindow makeToast:@"提交成功" duration:1.0 position:CSToastPositionCenter];
            [self.navigationController popViewControllerAnimated:YES];
            
        } failureBlock:^(RequestModel *respondObject) {
            [SVProgressHUD dismiss];
            [[UIApplication sharedApplication].keyWindow makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        }];
        [SVProgressHUD show];
        
    };
}
-(void)requestInfo{
    
    [HttpRequestTool postWithURL:FILE_BASE_STRING(@"/order/marketOrder/auth/platformHandler") Parameters:nil requestSerializerType:RequestSerializerTypeJson successBlock:^(RequestModel *respondObject) {
        [SVProgressHUD dismiss];
        //        orderView.orderReturnMode = [JHOrderReturnMode mj_objectWithKeyValues: respondObject.data[@"refundAmountVo"]];
        [orderView setReasonArr:respondObject.data[@"applyReason"]];
        [orderView setStatusArr:respondObject.data[@"cargoStatus"]];
        
        
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
