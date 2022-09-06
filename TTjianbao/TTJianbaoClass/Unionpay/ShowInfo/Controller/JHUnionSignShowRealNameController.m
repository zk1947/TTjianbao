//
//  JHUnionSignShowRealNameController.m
//  TTjianbao
//
//  Created by apple on 2020/4/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHUnionSignShowRealNameController.h"

@interface JHUnionSignShowRealNameController ()

@end

@implementation JHUnionSignShowRealNameController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self reloadTbaleView];
}

- (void)reloadTbaleView{
    if(self.model){
        
        NSMutableArray *array = [NSMutableArray new];
        
        NSString *name = (self.model.isPerson ? @"真实姓名" : @"法人姓名");
        
        [array addObject:[JHUnionSignShowBaseModel creatWithTitle:name desc:self.model.legalName type:JHUnionSignShowTypeNone hiddenPushIcon:YES]];
        
        
        [array addObject:[JHUnionSignShowBaseModel creatWithTitle:@"身份证号" desc:self.model.legalIdcardNo type:JHUnionSignShowTypeNone hiddenPushIcon:YES]];
        
        [array addObject:[JHUnionSignShowBaseModel creatWithTitle:@"邮箱" desc:self.model.legaEmail type:JHUnionSignShowTypeNone hiddenPushIcon:YES]];
        
        [array addObject:[JHUnionSignShowBaseModel creatWithTitle:@"手机号" desc:self.model.legalMobile type:JHUnionSignShowTypeNone hiddenPushIcon:YES]];
        
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 313)];
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
        
        UIImageView *imageView3 = [UIImageView jh_imageViewAddToSuperview:footerView];
        [imageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView1.mas_bottom).offset(15.f);
            make.left.equalTo(footerView).offset(10.f);
            make.height.mas_equalTo(133);
            make.right.equalTo(footerView.mas_centerX).offset(-7.5);
        }];
        
        [imageView1 jh_setImageWithUrl:self.model.cardProsPicUrl];
        [imageView2 jh_setImageWithUrl:self.model.cardConsPicUrl];
        [imageView3 jh_setImageWithUrl:self.model.personCardPicUrl];
        
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
