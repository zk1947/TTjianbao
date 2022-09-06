//
//  JHLuckyBagRewardVC.m
//  TTjianbao
//
//  Created by zk on 2021/11/9.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHLuckyBagRewardVC.h"
#import "JHLuckyBagRewardListView.h"

@interface JHLuckyBagRewardVC ()

@end

@implementation JHLuckyBagRewardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    JHLuckyBagRewardListView *view = [[JHLuckyBagRewardListView alloc]init];
    [view loadData];
    [self.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(@(0));
    }];
}

#pragma mark - JXCategoryListContentViewDelegate
- (UIView *)listView {
    return self.view;
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
