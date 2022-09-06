//
//  JHChatTransferServiceViewController.m
//  TTjianbao
//
//  Created by 韩笑 on 2021/5/19.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHChatTransferServiceViewController.h"

@interface JHChatTransferServiceViewController ()
@property (nonatomic, strong) UIView *containerView;
@end

@implementation JHChatTransferServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
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
#pragma mark - UI
- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5f];
    [self.view addSubview:self.containerView];
}
- (void)layoutViews {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(312 + + UI.bottomSafeAreaHeight);
    }];
}
#pragma mark - LAZY
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectZero];
        _containerView.backgroundColor = HEXCOLOR(0xffffff);
    }
    return _containerView;
}
@end
