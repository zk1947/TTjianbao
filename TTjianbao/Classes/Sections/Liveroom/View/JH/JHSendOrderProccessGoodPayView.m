//
//  JHSendOrderProccessGoodPayView.m
//  TTjianbao
//
//  Created by Jesse on 2019/11/14.
//  Copyright © 2019 YiJian Tech. All rights reserved.
//

#import "JHSendOrderProccessGoodPayView.h"
#import "JHProccessGoodSubView.h"
#import "JHOrderConfirmViewController.h"
#import "TTjianbaoBussiness.h"


#define kGoodSubViewHeight 106
#define kFontSize 13
#define kTextColor HEXCOLOR(0x333333)
#define kTextExtColor HEXCOLOR(0x999999)
#define kBackgroundColor [UIColor whiteColor]

@interface JHSendOrderProccessGoodPayView ()

@property (nonatomic,strong) UIView* backView;
@property (nonatomic, strong) UILabel* titleText;
@property (nonatomic, strong) UIButton* closeButton;
@property (nonatomic, strong) JHProccessGoodSubView* goodSubView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UILabel* totalLabel;
@property (nonatomic, strong) UILabel* goodFeeLabel;
@property (nonatomic, strong) UILabel* workFeeLabel;
@property (nonatomic, strong) UILabel* descLabel;

@end

@implementation JHSendOrderProccessGoodPayView

- (instancetype)init
{
    return [self initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.backgroundColor = HEXCOLORA(0x000000, 0.2);
//        [self addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
        [self drawSubview];
    }
    return self;
}

- (void)setOrderModel:(OrderMode *)orderModel
{
    _orderModel = orderModel;
    [_goodSubView setData:(OrderMode *)orderModel.parentOrder];
    
    _goodFeeLabel.text = [NSString stringWithFormat:@"¥%@",orderModel.materialCost];
    _workFeeLabel.text = [NSString stringWithFormat:@"¥%@",orderModel.manualCost];
    _totalLabel.text = [NSString stringWithFormat:@"¥%@",orderModel.orderPrice];
    _descLabel.text = [NSString stringWithFormat:@"加工描述：%@",orderModel.processingDes];
//    descLabel.text = @"加工描述：用户想加工成一个小妖怪！";
}

- (void)drawSubview
{
    [self addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(52);
        make.centerY.equalTo(self).offset(-30);
        make.width.mas_equalTo(ScreenW-52*2);
//        make.height.mas_equalTo(342);//默认
    }];
    
    [self.backView addSubview:self.titleText];
    [self.titleText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(10);
        make.centerX.equalTo(self.backView);
        make.width.mas_equalTo(75);
        make.height.mas_equalTo(21);
    }];
    
    [self addSubview:self.closeButton];
    [self.closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(28);
        make.right.equalTo(self.backView).offset(28/2);
        make.top.equalTo(self.backView).offset(-28/2);
    }];
    
    _goodSubView = [[JHProccessGoodSubView alloc] init];
    [self.backView  addSubview:_goodSubView];
    [self.goodSubView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.equalTo(self.backView).offset(41);
        make.width.mas_equalTo(ScreenW-52*2);
        make.height.mas_equalTo(kGoodSubViewHeight);
    }];
    
    //材料费
    UILabel* goodLabel = [[UILabel alloc] init];
    goodLabel.backgroundColor = kBackgroundColor;
    goodLabel.textColor = kTextColor;
    goodLabel.font = [UIFont fontWithName:kFontMedium size:kFontSize];
    goodLabel.textAlignment = NSTextAlignmentLeft;
    goodLabel.text = @"材料费";
    [self.backView addSubview:goodLabel];
    [goodLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goodSubView.mas_bottom).offset(10);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(39);
        make.height.mas_equalTo(18);
    }];
    
    _goodFeeLabel = [[UILabel alloc] init];
    _goodFeeLabel.backgroundColor = kBackgroundColor;
    _goodFeeLabel.textColor = kTextColor;
    _goodFeeLabel.font = [UIFont fontWithName:kFontMedium size:kFontSize];
    _goodFeeLabel.textAlignment = NSTextAlignmentLeft;
    [self.backView addSubview:self.goodFeeLabel];
    [_goodFeeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(goodLabel);
        make.left.mas_equalTo(goodLabel.mas_right).offset(5);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(15);
    }];
    
    //手工费
    UILabel* workLabel = [[UILabel alloc] init];
    workLabel.backgroundColor = kBackgroundColor;
    workLabel.textColor = kTextColor;
    workLabel.font = [UIFont fontWithName:kFontMedium size:kFontSize];
    workLabel.textAlignment = NSTextAlignmentLeft;
    workLabel.text = @"手工费";
    [self.backView addSubview:workLabel];
    [workLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(goodLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(10);
        make.width.mas_equalTo(39);
        make.height.mas_equalTo(18);
    }];
    
    _workFeeLabel = [[UILabel alloc] init];
    _workFeeLabel.backgroundColor = kBackgroundColor;
    _workFeeLabel.textColor = kTextColor;
    _workFeeLabel.font = [UIFont fontWithName:kFontMedium size:kFontSize];
    _workFeeLabel.textAlignment = NSTextAlignmentLeft;
    [self.backView addSubview:self.workFeeLabel];
    [_workFeeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(workLabel);
        make.left.mas_equalTo(workLabel.mas_right).offset(5);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(18);
    }];
    
    //合计
    UILabel* total = [[UILabel alloc] init];
    total.backgroundColor = kBackgroundColor;
    total.textColor = kTextColor;
    total.font = [UIFont fontWithName:kFontMedium size:kFontSize];
    total.textAlignment = NSTextAlignmentLeft;
    total.text = @"合计";
    [self.backView addSubview:total];
    [total mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(workLabel.mas_bottom).offset(13);
          make.left.mas_equalTo(10);
          make.width.mas_equalTo(26);
          make.height.mas_equalTo(18);
      }];
    //合计总价格
    _totalLabel = [[UILabel alloc] init];
    _totalLabel.backgroundColor = kBackgroundColor;
    _totalLabel.textColor = HEXCOLOR(0xFF4200);
    _totalLabel.font = [UIFont fontWithName:kFontMedium size:15];
    _totalLabel.textAlignment = NSTextAlignmentLeft;
    [self.backView addSubview:_totalLabel];
    [_totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(total);
        make.left.mas_equalTo(total.mas_right).offset(18);
        make.width.mas_equalTo(150);//加大点
        make.height.mas_equalTo(17);
    }];
    //描述
    UILabel* descLabel = [[UILabel alloc] init];
    descLabel.backgroundColor = kBackgroundColor;
    descLabel.textColor = HEXCOLOR(0x666666);
    descLabel.font = [UIFont fontWithName:kFontMedium size:kFontSize];
    descLabel.textAlignment = NSTextAlignmentLeft;
    descLabel.numberOfLines = 0;
    descLabel.text = @"加工描述：用户想加工成一个小妖怪！";
    [self.backView addSubview:descLabel];
    self.descLabel = descLabel;
    [descLabel mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.mas_equalTo(workLabel.mas_bottom).offset(44);
          make.left.mas_equalTo(10);
          make.width.mas_equalTo(self.mas_width).offset(-10*2-52*2);
      }];
    //button
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.layer.cornerRadius = 20;
    btn.backgroundColor = HEXCOLOR(0xFEE100);
    [btn setTitle:@"立即支付" forState:UIControlStateNormal];
    [btn setTitleColor:HEXCOLOR(0x333333) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pressComfirmPay) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.backView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(descLabel.mas_bottom).offset(10);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(190);
        make.centerX.equalTo(self);
     }];
    
    //用户i提示
    UILabel* tipLabel = [[UILabel alloc] init];
    tipLabel.backgroundColor = kBackgroundColor;
    tipLabel.textColor = kTextExtColor;
    tipLabel.font = [UIFont fontWithName:kFontMedium size:12];
    tipLabel.textAlignment = NSTextAlignmentLeft;
    tipLabel.text = @"订单宝贝一经加工不支持退货退换服务";
    [self.backView addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(btn.mas_bottom).offset(5);
        make.bottom.mas_equalTo(self.backView.mas_bottom).offset(-10);
        make.width.mas_equalTo(204);
        make.height.mas_equalTo(17);
        make.centerX.equalTo(self);
      }];
}

- (UIView*)backView
{
    if (!_backView)
    {
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = 6;
        _backView.layer.masksToBounds = YES;
    }
    
    return _backView;
}

- (UILabel *)titleText
{
    if (!_titleText)
    {
        _titleText = [UILabel new];
        _titleText.font = [UIFont fontWithName:kFontMedium size:15];
        _titleText.textColor = HEXCOLOR(0x333333);
        _titleText.text = @"加工服务单";
        _titleText.backgroundColor = [UIColor whiteColor];
    }
    
    return _titleText;
}

- (UIButton *)closeButton
{
    if (!_closeButton)
    {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _closeButton.layer.cornerRadius = 14;
        _closeButton.backgroundColor = HEXCOLOR(0x333333);
//        [_closeButton setTitle:@"×" forState:UIControlStateNormal];
        [_closeButton setImage:[UIImage imageNamed:@"icon_alert_close"] forState:UIControlStateNormal];

        [_closeButton setTitleColor:HEXCOLOR(0xFFFFFF) forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _closeButton.titleLabel.font = [UIFont systemFontOfSize:28];
    }
    
    return _closeButton;
}

#pragma event
- (void)dismiss
{
    LiveExtendModel *model = [JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel];
    model.orderCategory = self.orderModel.orderCategory;

    [JHGrowingIO trackEventId:JHTracklive_orderreceive_closebtn_process variables:[model mj_keyValues]];
    
    [self removeFromSuperview];
}

- (void)pressComfirmPay
{
    LiveExtendModel *model = [JHGrowingIO liveExtendModelChannel:JHRootController.serviceCenter.channelModel];
       model.orderCategory = self.orderModel.orderCategory;

       [JHGrowingIO trackEventId:JHTracklive_orderreceive_paybtn_process variables:[model mj_keyValues]];
    JHOrderConfirmViewController *vc = [[JHOrderConfirmViewController alloc] init];
       vc.orderId = self.orderModel.orderId;
       [self.viewController.navigationController pushViewController:vc animated:YES];
       [self dismiss];
}

@end
