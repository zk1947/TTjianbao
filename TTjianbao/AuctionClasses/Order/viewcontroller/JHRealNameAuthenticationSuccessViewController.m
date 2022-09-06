//
//  JHRealNameAuthenticationSuccessViewController.m
//  TTjianbao
//
//  Created by 张坤 on 2021/3/30.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHRealNameAuthenticationSuccessViewController.h"
#import "JHSuccessTipView.h"

@interface JHRealNameAuthenticationSuccessViewController ()
@property (nonatomic, strong) JHSuccessTipView *successTipView;
@end

@implementation JHRealNameAuthenticationSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"实名认证";
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
    [UserInfoRequestManager sharedInstance].user.isFaceAuth = @"1";
    NSMutableArray *vcs = [self.navigationController.childViewControllers mutableCopy];
    [vcs removeLastObject];
    [vcs removeLastObject];
    [vcs removeLastObject];
    [self.navigationController setViewControllers:vcs animated:YES];
    [NSNotificationCenter.defaultCenter postNotificationName:@"JHC2CRealNameSuccess" object:nil];
}

- (JHSuccessTipView *)successTipView {
    if (!_successTipView) {
        _successTipView = [[JHSuccessTipView alloc] initWithTitle:@"实名认证成功" des:@"" imageStr:@"icon_withdraw_bankCard_success" btnTitle:@"返回（3）"];
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
