//
//
//  Created by jiangchao on 2017/5/23.
//  Copyright © 2017年 jiangchao. All rights reserved.
//

#import "GoodAppraisalViewController.h"
#import "MyLiveViewController.h"
#import "JHMallViewController.h"
#import "JHNewRankingViewController.h"
#import "JHSegmentView.h"
#import "UIImage+GIF.h"
@interface GoodAppraisalViewController ()
@end

@implementation GoodAppraisalViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    NSMutableArray *mutArr = [NSMutableArray array];
    NSArray *titleArr = @[@"直播卖场",@"排行榜"];
    JHMallViewController* mall=[[JHMallViewController alloc]init];
    [mutArr addObject:mall];
    JHNewRankingViewController *rank = [JHNewRankingViewController new];
    [mutArr addObject:rank];

   
    JHSegmentView * segmentView=[[JHSegmentView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH) ViewControllersArr:mutArr TitleArr:titleArr ParentViewController:self ReturnIndexBlock:^(NSInteger index) {
          NSLog(@"点击了%ld模块",(long)index);
    }];
//
    [self.view addSubview:segmentView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)pressLiveVC:(UIGestureRecognizer *)gestureRecognizer {
    
    //我要直播
    MyLiveViewController *myliveVC=[MyLiveViewController new];
    [self.navigationController pushViewController:myliveVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end


