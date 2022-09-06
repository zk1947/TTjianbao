//
//  JHUserCenterResaleViewController.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/26.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHUserCenterResaleViewController.h"
#import "JHUserCenterResaleView.h"

@interface JHUserCenterResaleViewController ()
{
    JHUserCenterResaleView* resaleView;
}

@end

@implementation JHUserCenterResaleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //nav bar
//    [self setupToolBarWithTitle:@"寄售原石"];
    self.title = @"寄售原石";
    // subview
    [self drawSubviews];
}

#pragma mark - subviews
- (void)drawSubviews
{
    if(!resaleView)
    {
        resaleView = [[JHUserCenterResaleView alloc] initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight, ScreenW, ScreenH - UI.statusAndNavBarHeight)];
        [self.view addSubview: resaleView];
        resaleView.selectedIndex = self.selectedIndex; //根据需要设置
        [resaleView drawSubviews:@""];//个人中心传空
    }
}

- (void)dealloc{
    NSLog(@"%@*************被释放",[self class])
}
@end
