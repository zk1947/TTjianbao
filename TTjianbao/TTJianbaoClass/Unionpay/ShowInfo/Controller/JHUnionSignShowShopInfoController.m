//
//  JHUnionSignShowShopInfoController.m
//  TTjianbao
//
//  Created by apple on 2020/4/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHUnionSignShowShopInfoController.h"

@interface JHUnionSignShowShopInfoController ()

@end

@implementation JHUnionSignShowShopInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self reloadTbaleView];
}

- (void)reloadTbaleView{
    
    if(self.model){    
        NSMutableArray *array = [NSMutableArray new];
        
        [array addObject:[JHUnionSignShowBaseModel creatWithTitle:@"营业名称" desc:self.model.shopName type:JHUnionSignShowTypeNone hiddenPushIcon:YES]];
        
        [array addObject:[JHUnionSignShowBaseModel creatWithTitle:@"营业地区" desc:self.model.shopProvince type:JHUnionSignShowTypeNone hiddenPushIcon:YES]];
        
        [array addObject:[JHUnionSignShowBaseModel creatWithTitle:@"详细地址" desc:self.model.shopAddrExt type:JHUnionSignShowTypeNone hiddenPushIcon:YES]];
        
        [array addObject:[JHUnionSignShowBaseModel creatWithTitle:@"社会统一代码" desc:self.model.shopLic type:JHUnionSignShowTypeNone hiddenPushIcon:YES]];
        
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 160)];
        footerView.backgroundColor = UIColor.whiteColor;
        
        UIImageView *imageView1 = [UIImageView jh_imageViewAddToSuperview:footerView];
        [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(footerView).insets(UIEdgeInsetsMake(15, 10, 15, 10));
        }];
        
        [imageView1 jh_setImageWithUrl:self.model.licensePicUrl];
        
        [self.dataArray addObject:array];
        self.tableView.tableFooterView = footerView;
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
