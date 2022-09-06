//
//  JHLiveOrderSelectView.m
//  TTjianbao
//
//  Created by apple on 2020/12/8.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHLiveOrderSelectView.h"
#import "JHUIFactory.h"
#import "UIView+JHGradient.h"
#import "JHOrderListViewController.h"
#import "JHCustomizeOrderListViewController.h"
@implementation JHLiveOrderSelectView

-(void)dealloc
{
}
- (void)showAlert{
    [self makeUI];
    [super showAlert];
}
- (void)makeUI {

    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-30);
        make.size.mas_equalTo(CGSizeMake(260, 167));
    }];
    UILabel * titleLabel = [JHUIFactory createLabelWithTitle:@"请选择待付款订单" titleColor:HEXCOLOR(0x333333) font:JHFont(15) textAlignment:NSTextAlignmentCenter];
    [self.backView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(@40);
        make.right.mas_equalTo(@-40);
    }];
    
    UIButton *firstBtn = [JHUIFactory createThemeBtnWithTitle:@"常规订单" cornerRadius:19 target:self action:@selector(jumpNornalOrderAction)];
    [self.backView addSubview:firstBtn];
    [firstBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [firstBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@61);
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.height.equalTo(@38);
    }];
    
    UIButton *secondBtn = [JHUIFactory createThemeBtnWithTitle:@"定制订单" cornerRadius:19 target:self action:@selector(jumpCustomizeOrderAction)];
    [self.backView addSubview:secondBtn];
    [secondBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFEE100), HEXCOLOR(0xFFC242)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 0)];
    [secondBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(@-20);
        make.left.equalTo(@10);
        make.right.equalTo(@-10);
        make.height.equalTo(@38);
    }];
    
}
- (void)jumpNornalOrderAction{
    
    JHOrderListViewController * orderList = [[JHOrderListViewController alloc]init];
    orderList.fromSource = @"";
    [[JHRootController currentViewController].navigationController pushViewController:orderList animated:YES];
    [self hiddenAlert];
}
- (void)jumpCustomizeOrderAction{
    JHCustomizeOrderListViewController * orderList = [[JHCustomizeOrderListViewController alloc]init];
    orderList.currentIndex = 0;
    [[JHRootController currentViewController].navigationController pushViewController:orderList animated:YES];
    [self hiddenAlert];
}

@end
