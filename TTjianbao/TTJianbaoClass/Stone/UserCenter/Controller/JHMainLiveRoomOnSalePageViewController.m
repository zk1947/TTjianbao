//
//  JHMainLiveRoomOnSalePageViewController.m
//  TTjianbao
//  
//  Created by Jesse on 2019/12/2.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHMainLiveRoomOnSalePageViewController.h"
#import "JHMainRoomOnSaleStoneView.h"

@interface JHMainLiveRoomOnSalePageViewController ()
{
    JHMainRoomOnSaleStoneView* contentView;
}
@end

@implementation JHMainLiveRoomOnSalePageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //title
//    [self setupToolBarWithTitle:@"寄售原石"];
    self.title = @"寄售原石";
    //content view
    contentView = [[JHMainRoomOnSaleStoneView alloc] initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight, self.view.width, self.view.height - UI.statusAndNavBarHeight)];
    [self.view addSubview:contentView];
    [contentView drawSubviewsWithPageType:JHMainLiveRoomTabTypeResaleStone];
}


@end
