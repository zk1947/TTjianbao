//
//  JHUnionSignShowAccountInfoController.m
//  TTjianbao
//
//  Created by apple on 2020/4/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHUnionSignShowAccountInfoController.h"

@interface JHUnionSignShowAccountInfoController ()

@end

@implementation JHUnionSignShowAccountInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self reloadTbaleView];
}

- (void)reloadTbaleView{
    
    if(self.model){
        
        NSMutableArray *array = [NSMutableArray new];
        if(self.model.isPerson){
            
            [array addObject:[JHUnionSignShowBaseModel creatWithTitle:@"银行账号" desc:self.model.bankAcctNo type:JHUnionSignShowTypeNone hiddenPushIcon:YES]];
            
            [array addObject:[JHUnionSignShowBaseModel creatWithTitle:@"开户地区" desc:self.model.bankAcctProvince type:JHUnionSignShowTypeNone hiddenPushIcon:YES]];
            
            [array addObject:[JHUnionSignShowBaseModel creatWithTitle:@"所属支行" desc:self.model.bankBranchName type:JHUnionSignShowTypeNone hiddenPushIcon:YES]];
            
            [array addObject:[JHUnionSignShowBaseModel creatWithTitle:@"银行预留手机号" desc:self.model.bankPhone type:JHUnionSignShowTypeNone hiddenPushIcon:YES]];
            
            
            UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 160)];
            footerView.backgroundColor = UIColor.whiteColor;
            
            UIImageView *imageView1 = [UIImageView jh_imageViewAddToSuperview:footerView];
            [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(footerView).offset(15.f);
                make.left.equalTo(footerView).offset(10.f);
                make.height.mas_equalTo(133);
                make.right.equalTo(footerView.mas_centerX).offset(-7.5);
            }];
            
            UIImageView *imageView2 = [UIImageView jh_imageViewAddToSuperview:footerView];
            [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(footerView).offset(15.f);
                make.right.equalTo(footerView).offset(-10.f);
                make.height.mas_equalTo(133);
                make.left.equalTo(footerView.mas_centerX).offset(7.5);
            }];
            
            [imageView1 jh_setImageWithUrl:self.model.bankCardProsPicUrl];
            [imageView2 jh_setImageWithUrl:self.model.bankCardConsPicUrl];
            
            [self.dataArray addObject:array];
            self.tableView.tableFooterView = footerView;
        }
        else{
            [array addObject:[JHUnionSignShowBaseModel creatWithTitle:@"公司开户名称" desc:self.model.shopName type:JHUnionSignShowTypeNone hiddenPushIcon:YES]];
            
            [array addObject:[JHUnionSignShowBaseModel creatWithTitle:@"银行账号" desc:self.model.bankAcctNo type:JHUnionSignShowTypeNone hiddenPushIcon:YES]];
            
            [array addObject:[JHUnionSignShowBaseModel creatWithTitle:@"开户地区" desc:self.model.bankAcctProvince type:JHUnionSignShowTypeNone hiddenPushIcon:YES]];
            
            [array addObject:[JHUnionSignShowBaseModel creatWithTitle:@"所属支行" desc:self.model.bankBranchName type:JHUnionSignShowTypeNone hiddenPushIcon:YES]];
            
            UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 160)];
            footerView.backgroundColor = UIColor.whiteColor;
            
            UIImageView *imageView1 = [UIImageView jh_imageViewAddToSuperview:footerView];
            [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(footerView).insets(UIEdgeInsetsMake(15, 10, 15, 10));
            }];
            
            [imageView1 jh_setImageWithUrl:self.model.openAccountPicUrl];
            
            [self.dataArray addObject:array];
            self.tableView.tableFooterView = footerView;
        }
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
