//
//  JHLastSaleStoneViewViewController.m
//  TTjianbao
//
//  Created by Jesse on 2019/12/5.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHLastSaleStoneViewViewController.h"
#import "JHLastSaleStoneView.h"

@interface JHLastSaleStoneViewViewController ()
{
    JHLastSaleStoneView* lastSaleView;
}
@end

@implementation JHLastSaleStoneViewViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
//    [self setupToolBarWithTitle:@"最近售出"];
    self.title = @"最近售出";
    //绘制view
    lastSaleView = [[JHLastSaleStoneView alloc] initWithFrame:CGRectMake(0, UI.statusAndNavBarHeight, ScreenW, ScreenH - UI.statusAndNavBarHeight)];
    [self.view addSubview:lastSaleView];
    [lastSaleView drawSubviewsByPagetype:JHLastSaleCellTypeFromUserCenter channelId:@""];
}

@end
