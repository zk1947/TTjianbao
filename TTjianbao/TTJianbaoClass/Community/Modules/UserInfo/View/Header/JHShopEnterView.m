//
//  JHShopEnterView.m
//  TTjianbao
//
//  Created by lihui on 2020/6/19.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHShopEnterView.h"
#import "JHNewShopDetailViewController.h"

#import "UIButton+ImageTitleSpacing.h"
#import "CGoodsDetailModel.h"
#import "UIImageView+JHWebImage.h"
#import "JHUserInfoModel.h"

@interface JHShopEnterView ()

///商铺头像
@property (nonatomic, strong) UIImageView *iconImageView;
///店铺名称
@property (nonatomic, strong) UILabel *shopNameLabel;
///商品信息
@property (nonatomic, strong) UILabel *goodsInfoLabel;
///进入店铺按钮
@property (nonatomic, strong) UIButton *enterButton;

@end

@implementation JHShopEnterView

- (void)dealloc {
    NSLog(@"--- 店铺入口 ---");
}

- (void)setStoreInfo:(JHStoreSellerInfo *)storeInfo {
    if (!storeInfo) {
        return;
    }
    
    _storeInfo = storeInfo;
    [_iconImageView jhSetImageWithURL:[NSURL URLWithString:_storeInfo.head_img] placeholder:kDefaultAvatarImage];
    _shopNameLabel.text = _storeInfo.name;
    _goodsInfoLabel.text = [NSString stringWithFormat:@"共%@商品",_storeInfo.publish_num];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.cornerRadius = 8.f;
        self.layer.masksToBounds = YES;
        [self congfigViews];
        ///添加点击事件
        [self addAction];
    }
    return self;
}

- (void)congfigViews {
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.image = kDefaultAvatarImage;
    _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_iconImageView];
    
    _shopNameLabel = [[UILabel alloc] init];
    _shopNameLabel.text = @"--";
    _shopNameLabel.font = [UIFont fontWithName:kFontMedium size:15];
    [self addSubview:_shopNameLabel];
    
    _goodsInfoLabel = [[UILabel alloc] init];
    _goodsInfoLabel.text = @"共0件商品";
    _goodsInfoLabel.font = [UIFont fontWithName:kFontNormal size:11];
    [self addSubview:_goodsInfoLabel];
    
    _enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_enterButton setTitle:@"进店铺" forState:UIControlStateNormal];
    _enterButton.titleLabel.font = [UIFont fontWithName:kFontMedium size:12];
    [_enterButton setTitleColor:HEXCOLOR(0xFE9100) forState:UIControlStateNormal];
    [_enterButton setImage:[UIImage imageNamed:@"icon_user_info_arrow_orange"] forState:UIControlStateNormal];
    _enterButton.userInteractionEnabled = NO;
    [self addSubview:_enterButton];
//    [_enterButton addTarget:self action:@selector(enterShopAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(38, 38));
    }];
    
    [_enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    [_shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.top.equalTo(self.iconImageView);
        make.right.equalTo(self.enterButton.mas_left).offset(-10);
    }];
    
    [_goodsInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.shopNameLabel);
        make.bottom.equalTo(self.iconImageView);
        make.right.equalTo(self.shopNameLabel);
    }];
    
    [self layoutIfNeeded];
    _iconImageView.layer.cornerRadius = _iconImageView.width/2;
    _iconImageView.layer.masksToBounds = YES;
    [_enterButton layoutButtonWithEdgeInsetsStyle:MKButtonEdgeInsetsStyleRight imageTitleSpace:5];
}

- (void)addAction {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterShopAction)];
    [self addGestureRecognizer:tap];
}

///进入店铺 action
- (void)enterShopAction {
    [JHGrowingIO trackEventId:@"profile_shop_enter"];
    if (_storeInfo.seller_id > 0) {
        JHNewShopDetailViewController *vc = [[JHNewShopDetailViewController alloc] init];
        vc.customerId = [NSString stringWithFormat:@"%ld",(long)_storeInfo.seller_id];
        [JHRootController.currentViewController.navigationController pushViewController:vc animated:YES];
    }
}

@end
