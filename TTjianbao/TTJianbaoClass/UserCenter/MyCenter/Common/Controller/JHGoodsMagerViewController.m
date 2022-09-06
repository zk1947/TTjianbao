//
//  JHGoodsMagerViewController.m
//  TTjianbao
//
//  Created by zk on 2021/7/30.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHGoodsMagerViewController.h"
#import "UIView+JHGradient.h"
#import "JHBusinessPublishGoodsController.h"
#import "JHGoodManagerListViewController.h"
#import "JHGoodManagerNormalModel.h"

@interface JHGoodsMagerViewController ()

@end

@implementation JHGoodsMagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.jhTitleLabel.text = @"商品管理";
    self.view.backgroundColor = HEXCOLOR(0xF8F8F8);
    
    [self setupUI];
}

- (void)setupUI{
    
    UIControl *ctrl1 = [[UIControl alloc]initWithFrame:CGRectMake(12, UI.statusBarHeight+54, kScreenWidth-24, 80)];
    ctrl1.backgroundColor = kColorFFF;
    [ctrl1 jh_cornerRadius:5];
    [ctrl1 addTarget:self action:@selector(ctrl1Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ctrl1];
    
    UIImageView *imgv1 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 50, 50)];
    imgv1.image = JHImageNamed(@"icon-goodmanage-1");
    [ctrl1 addSubview:imgv1];
    
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(imgv1.right+12, 0, 150, 80)];
    lab1.text = @"一口价商品管理";
    lab1.textColor = kColor222;
    lab1.font = JHFont(14);
    [ctrl1 addSubview:lab1];
    
    UIImageView *icon1 = [[UIImageView alloc]initWithFrame:CGRectMake(ctrl1.width-20, 35, 5, 10)];
    icon1.image = JHImageNamed(@"icon_my_right_arrow");
    [ctrl1 addSubview:icon1];
    
    UIControl *ctrl2 = [[UIControl alloc]initWithFrame:CGRectMake(12, ctrl1.bottom+10, kScreenWidth-24, 80)];
    ctrl2.backgroundColor = kColorFFF;
    [ctrl2 jh_cornerRadius:5];
    [ctrl2 addTarget:self action:@selector(ctrl2Action:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ctrl2];
    
    UIImageView *imgv2 = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 50, 50)];
    imgv2.image = JHImageNamed(@"icon-goodmanage-2");
    [ctrl2 addSubview:imgv2];
    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(imgv1.right+12, 0, 150, 80)];
    lab2.text = @"拍卖商品管理";
    lab2.textColor = kColor222;
    lab2.font = JHFont(14);
    [ctrl2 addSubview:lab2];
    
    UIImageView *icon2 = [[UIImageView alloc]initWithFrame:CGRectMake(ctrl1.width-20, 35, 5, 10)];
    icon2.image = JHImageNamed(@"icon_my_right_arrow");
    [ctrl2 addSubview:icon2];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame = CGRectMake(12, kScreenHeight-50-33-UI.bottomSafeAreaHeight, kScreenWidth-24, 50);
    [submitBtn setTitle:@"发布商品" forState:UIControlStateNormal];
    [submitBtn setTitleColor:kColor222 forState:UIControlStateNormal];
    submitBtn.titleLabel.font = JHMediumFont(16);
    [submitBtn jh_cornerRadius:5];
    [submitBtn jh_setGradientBackgroundWithColors:@[HEXCOLOR(0xFED73A), HEXCOLOR(0xFECB33)] locations:nil startPoint:CGPointMake(0, 0) endPoint:CGPointMake(1, 1)];
    [submitBtn addTarget:self action:@selector(submitBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:submitBtn];
    
    
}

/// 一口价
- (void)ctrl1Action:(UIControl *)ctrl{
    JHGoodManagerListViewController *vc = [[JHGoodManagerListViewController alloc] init];
    vc.productType = JHGoodManagerListRequestProductType_OnePrice;
    [self.navigationController pushViewController:vc animated:YES];
}

/// 拍卖
- (void)ctrl2Action:(UIControl *)ctrl{
    JHGoodManagerListViewController *vc = [[JHGoodManagerListViewController alloc] init];
    vc.productType = JHGoodManagerListRequestProductType_Auction;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)submitBtnAction:(UIButton *)btn{
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"" message:@"请选发布商品类型" preferredStyle:UIAlertControllerStyleActionSheet];
    
    //更改标题样式
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"请选发布商品类型"];
    [title addAttributes:@{NSFontAttributeName:JHFont(14),NSForegroundColorAttributeName:kColor999} range:NSMakeRange(0, title.length)];
    //attributedTitle
    //attributedMessage
    [alertVC setValue:title forKey:@"attributedMessage"];

    
    UIAlertAction *button = [UIAlertAction actionWithTitle:@"拍卖商品"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action){
        JHBusinessPublishGoodsController *vc = [[JHBusinessPublishGoodsController alloc] initWithPublishType:(JHB2CPublishGoodsType_Auction)];
        [self.navigationController pushViewController:vc animated:YES];
                                                   }];
    UIAlertAction *button2 = [UIAlertAction actionWithTitle:@"一口价商品"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *action){
        JHBusinessPublishGoodsController *vc = [[JHBusinessPublishGoodsController alloc] initWithPublishType:(JHB2CPublishGoodsType_BuyNow)];
        [self.navigationController pushViewController:vc animated:YES];
                                                   }];
    
    UIAlertAction *button3 = [UIAlertAction actionWithTitle:@"取消"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *action){
                                                   }];
    //文字颜色
    [button3 setValue:kColor666 forKey:@"titleTextColor"];
    
    [alertVC addAction:button];
    [alertVC addAction:button2];
    [alertVC addAction:button3];
    
    [self presentViewController:alertVC animated:YES completion:nil];
    
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
