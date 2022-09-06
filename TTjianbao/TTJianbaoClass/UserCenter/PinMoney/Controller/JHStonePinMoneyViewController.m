//
//  JHStonePinMoneyViewController.m
//  TTjianbao
//
//  Created by Jesse on 2019/12/2.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHStonePinMoneyViewController.h"
#import "JHOCKAddBankCardViewController.h"
#import "JHRealNameAuthenticationViewController.h"
#import "JHWebViewController.h"

#import "JHStonePinMoneyView.h"
#import "JHWithdrawViewController.h"
#import "CommAlertView.h"

@interface JHStonePinMoneyViewController ()

@property (nonatomic, strong) JHStonePinMoneyView* spmView;

@end

@implementation JHStonePinMoneyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //优先请求数据
    [self requestData];
    self.title = @" ";
    // nav & title
#ifdef JH_UNION_PAY
//    [self setupToolBarWithTitle:@" " backgroundColor:[UIColor clearColor]];
    self.jhNavView.backgroundColor = [UIColor clearColor];
#else
//    [self setupToolBarWithTitle:@" " backgroundColor:HEXCOLOR(0xFFF199)];
    self.jhNavView.backgroundColor = HEXCOLOR(0xFFF199);
#endif
    //subview
    [self.view insertSubview:self.spmView belowSubview:self.jhNavView];
    JH_WEAK(self)
    [_spmView drawSubviews:^(id sender) {
        JH_STRONG(self)
        [self gotoWithdrawPage:sender];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(self.shouldRefreshPage)
    {
        [self requestData];
    }
}

- (JHStonePinMoneyView*)spmView
{
    if(!_spmView)
    {
#ifdef JH_UNION_PAY
        _spmView = [[JHStonePinMoneyView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
#else
        _spmView = [[JHStonePinMoneyView alloc] initWithFrame:CGRectMake(0, kHeaderViewHeight, self.view.width, self.view.height - kHeaderViewHeight)];
#endif
    }
    
    return _spmView;
}

#pragma mark - request
- (void)requestData
{
    [SVProgressHUD show];
    JH_WEAK(self)
    [kStonePinMoneyData requestAccountInfoWith:@"" type:@"" response:^(id respData, NSString *errorMsg) {
        JH_STRONG(self)
        [SVProgressHUD dismiss];
        if(errorMsg)
        {
            [SVProgressHUD showErrorWithStatus:errorMsg];
        }
        else
            [self.spmView refreshHeaderView:respData reloadTable:self.shouldRefreshPage];
    }];
}
#pragma mark - skip page
- (void)gotoWithdrawPage:(NSString*)sender {
    User *user = [UserInfoRequestManager sharedInstance].user;
    if (user.isFaceAuth.intValue == 0 &&
        user.authType != JHUserAuthTypeCommonBunsiness) {
        [self showRealNameAlertView];
        return;
    }
    
    if (user.isBindBank.intValue == 0) {
        [self showBandingBankCardAlertView];
        return;
    }
    
    JHWithdrawViewController *withdrawPage = [[JHWithdrawViewController alloc] init];
    withdrawPage.withdrawableText = sender;
    [self.navigationController pushViewController:withdrawPage animated:YES];
}

- (void)showRealNameAlertView {
    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"实名认证" andDesc:@"为了提现账号安全，请先进行实名认证" cancleBtnTitle:@"去认证"];
    [alert dealTitleToCenter];
    @weakify(self)
    [alert setCancleHandle:^{
        @strongify(self)
        [self.navigationController pushViewController:[JHRealNameAuthenticationViewController new] animated:YES];
    }];
    [alert setDesFont: [UIFont systemFontOfSize:13.f]];
    [alert addCloseBtn];
    [alert addBackGroundTap];
    [alert show];
}

- (void)showBandingBankCardAlertView {
    CommAlertView *alert = [[CommAlertView alloc] initWithTitle:@"绑定银行卡" andDesc:@"请先绑定银行卡，再进行提现" cancleBtnTitle:@"去绑定"];
    @weakify(self)
    [alert setCancleHandle:^{
        @strongify(self)
        if ([UserInfoRequestManager sharedInstance].user.authType != JHUserAuthTypeCommonBunsiness) {
            [self.navigationController pushViewController:[JHOCKAddBankCardViewController new] animated:YES];
            return;
        }
        
        if ([UserInfoRequestManager sharedInstance].user.authType == JHUserAuthTypeCommonBunsiness) {
            JHWebViewController *webView = [[JHWebViewController alloc] init];
            webView.urlString = H5_BASE_STRING(@"/jianhuo/app/recycle/tiedCard.html");
            [self.navigationController pushViewController:webView animated:YES];
            return;
        }
        
    }];
    [alert setDesFont: [UIFont systemFontOfSize:13.f]];
    [alert addCloseBtn];
    [alert addBackGroundTap];
    [alert show];
}


- (void)dealloc{
    NSLog(@"%@*************被释放",[self class])
}

@end
