//
//  JHWithdrawSuccessViewController.m
//  TTjianbao
//
//  Created by 张坤 on 2021/3/26.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHWithdrawSuccessViewController.h"
#import "JHSuccessTipView.h"

@interface JHWithdrawSuccessViewController ()
@property (nonatomic, strong) JHSuccessTipView *successTipView;
@end

@implementation JHWithdrawSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加银行卡";
    self.view.backgroundColor = RGB(248, 248, 248);
    
    [self.view addSubview:self.successTipView];
    [self.successTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(58.f+UI.statusAndNavBarHeight);
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
    }];
}

- (void)backActionButton:(UIButton *)sender {
    [self popToVC];
}

- (void)popToVC {
    NSMutableArray *vcs = [self.navigationController.childViewControllers mutableCopy];
    [vcs removeLastObject];
    [vcs removeLastObject];
    [self.navigationController setViewControllers:vcs animated:YES];
}

- (JHSuccessTipView *)successTipView {
    if (!_successTipView) {
        _successTipView = [[JHSuccessTipView alloc] initWithTitle:@"提现成功" des:@"银行预计1-3个工作日打款" imageStr:@"icon_withdraw_bankCard_success" btnTitle:@"返回（3）"];
        _successTipView.backgroundColor = UIColor.clearColor;
        @weakify(self)
        [_successTipView setSuccessTipViewBlock:^(UIButton * _Nonnull btn) {
            @strongify(self)
            [self popToVC];
        }];
    }
    return _successTipView;
}
@end
