//
//  JHMyCenterViewModel.m
//  TTjianbao
//
//  Created by apple on 2020/4/ 17.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHMyCenterViewModel.h"
#import "UserInfoRequestManager.h"
#import "TTjianbaoMarcoEnum.h"

#import "JHQRViewController.h"
#import "JHOrderDetailViewController.h"
#import "JHSessionViewController.h"
#import "JHNumberKeyboard.h"
#import "JHNewPaySuccessViewController.h"
#import "JHBeginIdentifyViewController.h"
#import "JHWebViewController.h"

@implementation JHMyCenterViewModel

- (void)scanAction {
    if (![JHRootController isLogin]) {
        [JHRootController presentLoginVC];
        return;
    }

    JHQRViewController *vc = [[JHQRViewController alloc] init];
    vc.titleString = JHLocalizedString(@"scaleCard");
    JH_WEAK(self)
    vc.scanFinish = ^(NSString * _Nullable scanString, JHQRViewController * _Nonnull obj) {
        JH_STRONG(self)
        [self requestOrder:scanString scanVC:obj];
        [obj performSelector:@selector(reStartDevice) withObject:nil afterDelay:2];
    };

    [[JHRouterManager jh_getViewController].navigationController pushViewController:vc animated:YES];
}

- (void)requestOrder:(NSString *)barCode scanVC:(JHQRViewController *)vc {
    [vc showHud];
    NSString *url = [NSString stringWithFormat:FILE_BASE_STRING(@"/order/auth/detailByBarCode?barCode=%@"),barCode];
    [HttpRequestTool getWithURL:url Parameters:nil successBlock:^(RequestModel *respondObject) {
        [vc dismissHud];
        OrderMode *model = [OrderMode mj_objectWithKeyValues:respondObject.data];
        JHOrderDetailViewController *orderDetailVc = [[JHOrderDetailViewController alloc] init];
        orderDetailVc.orderId = model.orderId;
        orderDetailVc.orderMode = (JHOrderDetailMode *)model;
        [vc.navigationController popViewControllerAnimated:YES];
        [[JHRouterManager jh_getViewController].navigationController pushViewController:orderDetailVc animated:NO];
        
    } failureBlock:^(RequestModel *respondObject) {
        [vc.view makeToast:respondObject.message duration:1.0 position:CSToastPositionCenter];
        [vc dismissHud];
    }];
}
@end
