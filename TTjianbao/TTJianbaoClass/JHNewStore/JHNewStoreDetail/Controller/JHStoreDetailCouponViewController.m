//
//  JHStoreDetailCouponViewController.m
//  TTjianbao
//
//  Created by 韩啸 on 2021/2/6.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHStoreDetailCouponViewController.h"
#import "JHStoreDetailCouponListView.h"
#import "LoginViewController.h"
#import "BaseNavViewController.h"

@interface JHStoreDetailCouponViewController ()
@property (nonatomic, strong) JHStoreDetailCouponListView *contentView;
@end

@implementation JHStoreDetailCouponViewController

#pragma mark - Life Cycle Functions
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    [self bindData];
   
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    [self layoutViews];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        if (touch.view == self.view) {
            [self dismissViewControllerAnimated:true completion:nil];
            return;
        }
    }
    
}
#pragma mark - Bind
- (void)bindData {
    @weakify(self)
    [self.contentView.dismissSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self dismissViewControllerAnimated:true completion:nil];
    }];
    // 跳转
    [self.contentView.viewModel.pushvc subscribeNext:^(NSDictionary * _Nullable x) {
        @strongify(self)
        NSDictionary *dic = (NSDictionary *)x;
        [self pushWithDic:dic];
    }];
    self.refreshUpper = self.contentView.viewModel.refreshUpper;
}
- (void)pushWithDic : (NSDictionary *)dic {
    NSString *type = dic[@"type"];
//    NSDictionary *par = dic[@"parameter"];
    // 登录
    if ([type isEqualToString:@"Login"]) {
        @weakify(self)
        [JHRootController presentLoginVCWithTarget:self complete:^(BOOL result) {
            @strongify(self);
            [self.contentView.viewModel getCouponList];
        }];
    }
}
- (void)showProgressHUD {
    [MBProgressHUD showHUDAddedTo:self.view animated:true];
}
- (void)hideProgressHUD {
    [MBProgressHUD hideHUDForView:self.view animated:true];
}
#pragma mark - Private Functions
- (void)setupViews {
    self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    [self.view addSubview:self.contentView];
}
- (void)layoutViews {
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
    
        if (ScreenH / ScreenW >= 2) {
            make.top.equalTo(self.view).offset(ScreenW);
        }else {
            make.height.equalTo(self.view.mas_width).multipliedBy(460 / 375);
        }
//        make.height.equalTo(self.view.mas_width).multipliedBy(460 / 375);
    }];
}
#pragma mark - Action functions
#pragma mark - Lazy
- (void)setParameter:(NSDictionary *)parameter {
    _parameter = parameter;
    if (parameter[@"sellerId"]) {
        self.contentView.viewModel.sellerId = parameter[@"sellerId"];
    }
}
- (JHStoreDetailCouponListView *)contentView {
    if (!_contentView) {
        _contentView = [[JHStoreDetailCouponListView alloc] initWithFrame:CGRectZero];
    }
    return _contentView;
}

@end
