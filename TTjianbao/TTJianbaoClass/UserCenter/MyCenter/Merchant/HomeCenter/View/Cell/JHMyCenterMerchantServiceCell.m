//
//  JHMyCenterMerchantServiceCell.m
//  TTjianbao
//
//  Created by wangjianios on 2021/4/8.
//  Copyright © 2021 YiJian Tech. All rights reserved.
//

#import "JHMyCenterMerchantServiceCell.h"
#import "JHWebViewController.h"
#import "YYControl.h"

@implementation JHMyCenterMerchantServiceCell

- (void)addSelfSubViews {
    
    self.contentView.backgroundColor = RGB(248, 248, 248);
    
    UIImageView *imageView = [UIImageView jh_imageViewWithContentModel:UIViewContentModeScaleToFill addToSuperview:self.contentView];
    imageView.userInteractionEnabled = YES;
    imageView.image = JHImageNamed(@"my_center_merchant_service");
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(5, 12, 20, 12));
    }];
    
    UILabel *addLabel = [[UILabel alloc] init];
    addLabel.text = @"＋";
    addLabel.font = [UIFont fontWithName:kFontNormal size:20];
    addLabel.textColor = RGB(247, 181, 0);
    [imageView addSubview:addLabel];
    
    UILabel *serviceLabel = [[UILabel alloc] init];
    serviceLabel.text = @"开通新服务";
    serviceLabel.font = [UIFont fontWithName:kFontNormal size:14.];
    serviceLabel.textColor = kColor333;
    [imageView addSubview:serviceLabel];
    
    [serviceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageView);
        make.centerX.equalTo(imageView).offset(15);
    }];
    
    [addLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(serviceLabel);
        make.right.equalTo(serviceLabel.mas_left).offset(-6);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openNewService)];
    [imageView addGestureRecognizer:tap];
}
- (void)openNewService {
    NSLog(@"==== openNewService ==== ");
    JHWebViewController *vc = [[JHWebViewController alloc] init];
    vc.urlString = H5_BASE_STRING(@"/jianhuo/app/recycle/applyBusiness.html");
    [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
}
@end
