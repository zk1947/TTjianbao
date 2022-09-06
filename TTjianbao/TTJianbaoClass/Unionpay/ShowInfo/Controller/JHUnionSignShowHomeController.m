//
//  JHUnionSignShowHomeController.m
//  TTjianbao
//
//  Created by apple on 2020/4/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//
#import "JHUnionPayManager.h"
#import "JHUnionSignShowHomeController.h"
#import "JHUnionSignShowDataSourceModel.h"
@interface JHUnionSignShowHomeController ()

@end

@implementation JHUnionSignShowHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"银联商务签约";
 
    [JHUnionPayManager getUnionSignAllInfoWithQueryType:0 completeBlock:^(NSDictionary * _Nonnull dataDic, BOOL success) {
        if(success){
            self.model = [JHUnionSignShowDataSourceModel mj_objectWithKeyValues:dataDic];
            [self reloadTbaleView];
        }
    }];
}

- (void)reloadTbaleView{
    
    if(self.model){
        [self.dataArray addObject:@[[JHUnionSignShowBaseModel creatWithTitle:@"商户号" desc:self.model.unionpayMerchantNo type:JHUnionSignShowTypeNone hiddenPushIcon:YES]]];
        
        NSMutableArray *array = [NSMutableArray new];
        
        [array addObject:[JHUnionSignShowBaseModel creatWithTitle:@"实名认证" desc:@"" type:JHUnionSignShowTypeRealName hiddenPushIcon:NO]];
        
        if(!self.model.isPerson){
            [array addObject:[JHUnionSignShowBaseModel creatWithTitle:@"营业信息" desc:@"" type:JHUnionSignShowTypeShopInfo hiddenPushIcon:NO]];
        }
        
        [array addObject:[JHUnionSignShowBaseModel creatWithTitle:@"账户信息" desc:@"" type:JHUnionSignShowTypeAccountInfo hiddenPushIcon:NO]];
        
//        [array addObject:[JHUnionSignShowBaseModel creatWithTitle:@"电子签约" desc:@"" type:JHUnionSignShowTypeSignInfo hiddenPushIcon:NO]];
        
        [self.dataArray addObject:array];
        
        [self.tableView reloadData];
    }
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
