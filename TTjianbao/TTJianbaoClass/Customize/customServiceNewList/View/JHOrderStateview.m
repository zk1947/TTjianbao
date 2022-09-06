//
//  JHOrderStateview.m
//  TTjianbao
//
//  Created by 王记伟 on 2020/10/29.
//  Copyright © 2020 YiJian Tech. All rights reserved.
//

#import "JHOrderStateview.h"
#import "UIView+JHGradient.h"
#import "JHLastOrderModel.h"
#import "UIImageView+WebCache.h"
#import "TTjianbao.h"
#import "JHCustomizeOrderDetailController.h"
@interface JHOrderStateview()
/** 分割线*/
@property (nonatomic, strong) UIView *lineView;
/** 底图背景*/
@property (nonatomic, strong) UIView *orderBackview;
/** 图片*/
@property (nonatomic, strong) UIImageView *orderImageView;
/** 名字*/
@property (nonatomic, strong) UILabel *orderNameLabel;
/** 订单状态*/
@property (nonatomic, strong) UILabel *orderStatusLabel;
/** 查看按钮*/
@property (nonatomic, strong) UIButton *orderLookButton;
@end
@implementation JHOrderStateview

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.clipsToBounds = YES;
        [self configUI];
    }
    return self;
}

- (void)configUI{
    self.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.lineView];
    [self addSubview:self.orderBackview];
    [self.orderBackview addSubview:self.orderImageView];
    [self.orderBackview addSubview:self.orderNameLabel];
    [self.orderBackview addSubview:self.orderStatusLabel];
    [self.orderBackview addSubview:self.orderLookButton];
}

- (void)setModel:(JHLastOrderModel *)model{
    _model = model;
    [self.orderImageView sd_setImageWithURL:[NSURL URLWithString:model.orderImg] placeholderImage:kDefaultCoverImage];
    self.orderNameLabel.text = model.orderName;
    self.orderStatusLabel.text = [NSString stringWithFormat:@"当前状态: %@", model.orderStatusStr];
}

#pragma mark --事件处理
/** 查看订单按钮*/
- (void)seeOrderButtonClickAction{
    JHCustomizeOrderDetailController * detail=[[JHCustomizeOrderDetailController alloc]init];
    detail.orderId=self.model.orderId;
    detail.isSeller = NO;
    [self.viewController.navigationController pushViewController:detail animated:YES];
}

#pragma  mark -UI绘制
- (UIView *)lineView{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 8)];
        _lineView.backgroundColor = kColorF5F6FA;
    }
    return _lineView;
}

- (UIView *)orderBackview{
    if (_orderBackview == nil) {
        _orderBackview = [[UIView alloc] initWithFrame:CGRectMake(10, self.lineView.bottom + 10, self.width - 20, 76)];
        _orderBackview.backgroundColor = RGB(249, 250, 249);
        _orderBackview.layer.cornerRadius = 8;
        _orderBackview.clipsToBounds = YES;
    }
    return _orderBackview;
}

- (UIImageView *)orderImageView{
    if (_orderImageView == nil) {
        _orderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 56, 56)];
        _orderImageView.layer.cornerRadius = 8;
        _orderImageView.clipsToBounds = YES;
        _orderImageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _orderImageView;
}

- (UIButton *)orderLookButton{
    if (_orderLookButton == nil) {
        _orderLookButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _orderLookButton.frame = CGRectMake(self.orderBackview.width - 10 - 66, (self.orderBackview.height - 30) / 2, 66, 30);
        _orderLookButton.layer.cornerRadius = 15;
        _orderLookButton.layer.borderColor = RGB(189, 191, 194).CGColor;
        _orderLookButton.layer.borderWidth = 1;
        _orderLookButton.clipsToBounds = YES;
        [_orderLookButton setTitle:@"查看" forState:UIControlStateNormal];
        [_orderLookButton setTitleColor:RGB515151 forState:UIControlStateNormal];
        _orderLookButton.titleLabel.font = [UIFont fontWithName:kFontNormal size:13];
        [_orderLookButton addTarget:self action:@selector(seeOrderButtonClickAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _orderLookButton;
}

- (UILabel *)orderNameLabel{
    if (_orderNameLabel == nil) {
        _orderNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.orderImageView.right + 10, 17, self.orderLookButton.left - 23 - self.orderImageView.right - 10, 21)];
        _orderNameLabel.text = @"";
        _orderNameLabel.font = [UIFont fontWithName:kFontMedium size:15];
        _orderNameLabel.textColor = RGB515151;
    }
    return _orderNameLabel;
}

- (UILabel *)orderStatusLabel{
    if (_orderStatusLabel == nil) {
        _orderStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.orderNameLabel.left, self.orderNameLabel.bottom + 5, self.orderNameLabel.width, 17)];
        _orderStatusLabel.text = @"";
        _orderStatusLabel.font = [UIFont fontWithName:kFontNormal size:12];
        _orderStatusLabel.textColor = RGB153153153;
    }
    return _orderStatusLabel;
}


@end
